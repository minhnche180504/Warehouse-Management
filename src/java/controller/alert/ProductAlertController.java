package controller.alert;

import dao.ProductAlertDAO;
import dao.ProductDAO;
import dao.WarehouseDAO;
import dao.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ProductAlert;
import model.Product;
import model.Warehouse;
import model.User;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet(name = "ProductAlertController", urlPatterns = {
    "/manager/low-stock-alerts",
    "/manager/low-stock-config",
    "/manager/alert-history",
    "/manager/alert/create",
    "/manager/alert/update",
    "/manager/alert/deactivate",
    "/manager/alert/cleanup-expired"
})
public class ProductAlertController extends HttpServlet {

    private ProductAlertDAO productAlertDAO;
    private ProductDAO productDAO;
    private WarehouseDAO warehouseDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() throws ServletException {
        productAlertDAO = new ProductAlertDAO();
        productDAO = new ProductDAO();
        warehouseDAO = new WarehouseDAO();
        roleDAO = new RoleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        String roleName = getRoleName(user.getRoleId());

        switch (path) {
            case "/manager/low-stock-alerts":
                showAlertList(request, response, user, roleName);
                break;
            case "/manager/low-stock-config":
                showAlertConfiguration(request, response, user, roleName);
                break;
            case "/manager/alert-history":
                showAlertHistory(request, response, user, roleName);
                break;
            case "/manager/alert/cleanup-expired":
                cleanupExpiredAlerts(request, response, user, roleName);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        String roleName = getRoleName(user.getRoleId());

        switch (path) {
            case "/manager/alert/create":
                createAlert(request, response, user, roleName);
                break;
            case "/manager/alert/update":
                updateAlert(request, response, user, roleName);
                break;
            case "/manager/alert/deactivate":
                deactivateAlert(request, response, user, roleName);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showAlertList(HttpServletRequest request, HttpServletResponse response,
            User user, String roleName) throws ServletException, IOException {
        try {
            List<ProductAlert> alerts;
            Map<String, Integer> alertCounts;

            // Chỉ Warehouse Manager và Admin mới được xem alerts
            if ("Warehouse Manager".equals(roleName) || "Admin".equals(roleName)) {
                if (user.getWarehouseId() != null) {
                    alerts = productAlertDAO.getAlertsByWarehouse(user.getWarehouseId());
                    alertCounts = productAlertDAO.getAlertCountsByWarehouse(user.getWarehouseId());
                    productAlertDAO.updateCurrentStockByWarehouse(user.getWarehouseId());
                } else {
                    alerts = productAlertDAO.getAllAlerts();
                    alertCounts = new HashMap<>();
                    // Tính tổng từ tất cả warehouse (implement nếu cần)
                }
            } else {
                // Các role khác không được xem alerts
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            // Tự động dọn dẹp cảnh báo hết hạn
            productAlertDAO.moveExpiredAlertsToHistory();

            request.setAttribute("alerts", alerts);
            request.setAttribute("alertCounts", alertCounts);
            request.setAttribute("userRole", roleName);
            request.setAttribute("canModify", "Warehouse Manager".equals(roleName) || "Admin".equals(roleName));
            request.setAttribute("userWarehouseId", user.getWarehouseId());

            request.getRequestDispatcher("/manager/low-stock-alert-list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách cảnh báo: " + e.getMessage());
            request.getRequestDispatcher("/manager/low-stock-alert-list.jsp").forward(request, response);
        }
    }

    private void showAlertConfiguration(HttpServletRequest request, HttpServletResponse response,
            User user, String roleName) throws ServletException, IOException {
        // Chỉ Manager mới được truy cập trang cấu hình
        if (!"Warehouse Manager".equals(roleName) && !"Admin".equals(roleName)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only managers can access configuration");
            return;
        }

        try {
            // Load products và warehouses cho dropdown
            List<Product> products = productDAO.getAll();
            List<Warehouse> warehouses = warehouseDAO.getAll();

            // Load current alerts
            List<ProductAlert> currentAlerts;
            if (user.getWarehouseId() != null) {
                currentAlerts = productAlertDAO.getAlertsByWarehouse(user.getWarehouseId());
            } else {
                currentAlerts = productAlertDAO.getAllAlerts();
            }

            request.setAttribute("products", products);
            request.setAttribute("warehouses", warehouses);
            request.setAttribute("currentAlerts", currentAlerts);
            request.setAttribute("userWarehouseId", user.getWarehouseId());

            request.getRequestDispatcher("/manager/low-stock-alert-config.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang cấu hình: " + e.getMessage());
            request.getRequestDispatcher("/manager/low-stock-alert-config.jsp").forward(request, response);
        }
    }

    private void createAlert(HttpServletRequest request, HttpServletResponse response,
            User user, String roleName) throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
            int warningThreshold = Integer.parseInt(request.getParameter("warningThreshold"));
            int criticalThreshold = Integer.parseInt(request.getParameter("criticalThreshold"));
            int durationDays = Integer.parseInt(request.getParameter("durationDays"));

            // Validation
            if (criticalThreshold >= warningThreshold) {
                request.setAttribute("error", "Ngưỡng nguy hiểm phải nhỏ hơn ngưỡng cảnh báo");
                showAlertConfiguration(request, response, user, roleName);
                return;
            }

            // FIXED: Kiểm tra alert đã tồn tại - sử dụng method đã sửa
            // Nếu đã có alert active hoặc deactive thì createOrUpdateAlert sẽ xử lý
            boolean success = productAlertDAO.createOrUpdateAlert(productId, warehouseId,
                    warningThreshold, criticalThreshold, durationDays, user.getUserId());

            // Nếu tạo mới thành công, kiểm tra có alertId mới để ghi lịch sử
            if (success) {
                // Lấy lại alert vừa tạo (vì chỉ có 1 alert active cho productId, warehouseId)
                List<ProductAlert> alerts = productAlertDAO.getAlertsByWarehouse(warehouseId);
                ProductAlert createdAlert = null;
                for (ProductAlert a : alerts) {
                    if (a.getProductId() == productId) {
                        createdAlert = a;
                        break;
                    }
                }
                if (createdAlert != null) {
                    productAlertDAO.logAlertCreated(createdAlert.getAlertId(), user.getUserId(), "Tạo mới cảnh báo");
                }
                request.setAttribute("success", "Cấu hình cảnh báo thành công (Hết hạn sau " + durationDays + " ngày)");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cấu hình cảnh báo");
            }

            showAlertConfiguration(request, response, user, roleName);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu đầu vào không hợp lệ");
            String roleName2 = getRoleName(user.getRoleId());
            showAlertConfiguration(request, response, user, roleName2);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            String roleName2 = getRoleName(user.getRoleId());
            showAlertConfiguration(request, response, user, roleName2);
        }
    }

    private void updateAlert(HttpServletRequest request, HttpServletResponse response,
            User user, String roleName) throws ServletException, IOException {
        try {
            int alertId = Integer.parseInt(request.getParameter("alertId"));
            int warningThreshold = Integer.parseInt(request.getParameter("warningThreshold"));
            int criticalThreshold = Integer.parseInt(request.getParameter("criticalThreshold"));
            int durationDays = Integer.parseInt(request.getParameter("durationDays"));

            // Validation
            if (criticalThreshold >= warningThreshold) {
                request.setAttribute("error", "Ngưỡng nguy hiểm phải nhỏ hơn ngưỡng cảnh báo");
                showAlertConfiguration(request, response, user, roleName);
                return;
            }

            // Get alert to update
            ProductAlert alert = productAlertDAO.getAlertById(alertId);
            if (alert == null) {
                request.setAttribute("error", "Không tìm thấy cảnh báo");
                showAlertConfiguration(request, response, user, roleName);
                return;
            }

            // Lưu lại giá trị cũ để ghi lịch sử
            int oldWarning = alert.getWarningThreshold();
            int oldCritical = alert.getCriticalThreshold();
            java.sql.Timestamp oldExpiry = alert.getAlertExpiryDate();

            boolean success = productAlertDAO.createOrUpdateAlert(alert.getProductId(),
                    alert.getWarehouseId(), warningThreshold, criticalThreshold, durationDays, user.getUserId());

            // Nếu cập nhật thành công, ghi lịch sử
            if (success) {
                // Lấy lại alert để lấy ngày hết hạn mới
                ProductAlert updatedAlert = productAlertDAO.getAlertById(alertId);
                java.sql.Timestamp newExpiry = updatedAlert != null ? updatedAlert.getAlertExpiryDate() : null;
                productAlertDAO.logAlertUpdated(alertId, user.getUserId(), oldWarning, oldCritical, oldExpiry, warningThreshold, criticalThreshold, newExpiry, "Cập nhật ngưỡng cảnh báo");
                request.setAttribute("success", "Cập nhật cảnh báo thành công");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật cảnh báo");
            }

            showAlertConfiguration(request, response, user, roleName);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu đầu vào không hợp lệ");
            showAlertConfiguration(request, response, user, roleName);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showAlertConfiguration(request, response, user, roleName);
        }
    }

    /**
     * FIXED: Vô hiệu hóa cảnh báo thay vì xóa
     */
    private void deactivateAlert(HttpServletRequest request, HttpServletResponse response,
            User user, String roleName) throws ServletException, IOException {
        try {
            int alertId = Integer.parseInt(request.getParameter("alertId"));

            boolean success = productAlertDAO.deactivateAlert(alertId);

            // Nếu vô hiệu hóa thành công, ghi lịch sử
            if (success) {
                productAlertDAO.logAlertDeactivated(alertId, user.getUserId(), "Vô hiệu hóa cảnh báo");
                request.setAttribute("success", "Vô hiệu hóa cảnh báo thành công");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi vô hiệu hóa cảnh báo");
            }

            showAlertConfiguration(request, response, user, roleName);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID cảnh báo không hợp lệ");
            showAlertConfiguration(request, response, user, roleName);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showAlertConfiguration(request, response, user, roleName);
        }
    }

    private void cleanupExpiredAlerts(HttpServletRequest request, HttpServletResponse response,
            User user, String roleName) throws ServletException, IOException {
        try {
            productAlertDAO.moveExpiredAlertsToHistory();
            request.setAttribute("success", "Dọn dẹp cảnh báo hết hạn thành công");
            showAlertList(request, response, user, roleName);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi dọn dẹp: " + e.getMessage());
            showAlertList(request, response, user, roleName);
        }
    }

    private String getRoleName(int roleId) {
        try {
            model.Role role = roleDAO.getRoleById(roleId);
            if (role != null) {
                return role.getRoleName();
            } else {
                return "Unknown";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Unknown";
        }
    }
    // Thêm method mới cho alert history

    private void showAlertHistory(HttpServletRequest request, HttpServletResponse response, User user, String roleName)
            throws ServletException, IOException {

        try {
            List<Map<String, Object>> alertHistory;
            Map<String, Integer> historyStats;

            if ("Warehouse Staff".equals(roleName)) {
                if (user.getWarehouseId() == null) {
                    request.setAttribute("error", "Bạn chưa được phân công kho nào");
                    request.getRequestDispatcher("/manager/alert-history.jsp").forward(request, response);
                    return;
                }
                // Staff chỉ xem được lịch sử của warehouse mình
                alertHistory = productAlertDAO.getDetailedAlertHistoryByWarehouse(user.getWarehouseId(), 100);
                historyStats = productAlertDAO.getAlertHistoryStats(user.getWarehouseId());
            } else if ("Warehouse Manager".equals(roleName) && user.getWarehouseId() != null) {
                // Manager xem lịch sử của warehouse mình quản lý
                alertHistory = productAlertDAO.getDetailedAlertHistoryByWarehouse(user.getWarehouseId(), 100);
                historyStats = productAlertDAO.getAlertHistoryStats(user.getWarehouseId());
            } else {
                // Admin xem tất cả lịch sử
                alertHistory = productAlertDAO.getAllDetailedAlertHistory(100);
                historyStats = new HashMap<>(); // Có thể implement stats tổng cho admin
            }

            request.setAttribute("alertHistory", alertHistory);
            request.setAttribute("historyStats", historyStats);
            request.setAttribute("userRole", roleName);
            request.setAttribute("canModify", "Warehouse Manager".equals(roleName) || "Admin".equals(roleName));

            request.getRequestDispatcher("/manager/alert-history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải lịch sử cảnh báo: " + e.getMessage());
            request.getRequestDispatcher("/manager/alert-history.jsp").forward(request, response);
        }
    }

}
