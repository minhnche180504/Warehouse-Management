package controller.stockcheck;

import dao.InventoryDAO;
import dao.StockCheckReportDAO;
import dao.WarehouseDAO;
import model.Inventory;
import model.StockCheckReport;
import model.StockCheckReportItem;
import model.User;
import model.WarehouseDisplay;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CreateStockCheckReportServlet", urlPatterns = {"/manager/create-stock-check-report", "/staff/create-stock-check-report"})
public class CreateStockCheckReportServlet extends HttpServlet {

    private WarehouseDAO warehouseDAO;
    private InventoryDAO inventoryDAO;
    private StockCheckReportDAO stockCheckReportDAO;

    @Override
    public void init() throws ServletException {
        warehouseDAO = new WarehouseDAO();
        inventoryDAO = new InventoryDAO();
        stockCheckReportDAO = new StockCheckReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int roleId = currentUser.getRoleId();
        if (roleId != 2 && roleId != 4) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền tạo phiếu kiểm kê kho.");
            return;
        }

        int warehouseId = currentUser.getWarehouseId();
        WarehouseDisplay warehouse = warehouseDAO.getWarehouseById(warehouseId);

        // Lấy sản phẩm tồn kho tại warehouse từ InventoryDAO 
        List<Inventory> productsInStock = inventoryDAO.getProductsByWarehouse(warehouseId);

        // Sinh mã phiếu tự động
        String reportCode = stockCheckReportDAO.generateUniqueReportCode();

        // Ngày hôm nay
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String currentDate = sdf.format(new java.util.Date());

        request.setAttribute("warehouse", warehouse);
        request.setAttribute("products", productsInStock);
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("reportCode", reportCode);
        request.setAttribute("reportDate", currentDate);

        String servletPath = request.getServletPath();
        if (servletPath.startsWith("/staff")) {
            request.getRequestDispatcher("/staff/create-stock-check-report.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/manager/create-stock-check-report.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User currentUser = (User) session.getAttribute("user");
        int warehouseId = currentUser.getWarehouseId();

        String reportCode = stockCheckReportDAO.generateUniqueReportCode();

        java.sql.Date reportDate = new java.sql.Date(System.currentTimeMillis());
        String notesFromRequest = request.getParameter("notes"); // Lấy ghi chú từ form

        // Lấy dữ liệu sản phẩm kiểm kê từ form
        String[] productIdsParam = request.getParameterValues("productId");
        String[] systemQuantitiesParam = request.getParameterValues("systemQuantity");
        String[] countedQuantitiesParam = request.getParameterValues("countedQuantity");
        String[] reasonsParam = request.getParameterValues("reason");

        List<StockCheckReportItem> validItems = new ArrayList<>();
        if (productIdsParam != null) {
            for (int i = 0; i < productIdsParam.length; i++) {
                int productId = Integer.parseInt(productIdsParam[i]);
                int sysQty = Integer.parseInt(systemQuantitiesParam[i]);
                int countedQty = Integer.parseInt(countedQuantitiesParam[i]);
                String reason = (reasonsParam != null && i < reasonsParam.length) ? reasonsParam[i] : "";

                StockCheckReportItem item = new StockCheckReportItem();
                item.setProductId(productId);
                item.setSystemQuantity(sysQty);
                item.setCountedQuantity(countedQty);
                item.setDiscrepancy(countedQty - sysQty);
                item.setReason(reason != null ? reason.trim() : "");
                validItems.add(item);
            }
        }

        if (validItems.isEmpty()) {
            request.setAttribute("errorMessage", "Stock check report must have at least one valid product.");
            doGet(request, response);
            return;
        }

        // Xác định trạng thái lưu dựa trên nút submit
        String action = request.getParameter("action");
        String status = "Pending";
        if ("saveDraft".equalsIgnoreCase(action)) {
            status = "Draft";
        } else if ("saveReport".equalsIgnoreCase(action)) {
            if (currentUser.getRoleId() == 2) { // Manager
                status = "Completed";
            } else { // Staff
                status = "Pending";
            }
        }

        // Tạo report
        StockCheckReport report = new StockCheckReport();
        report.setReportCode(reportCode);
        report.setWarehouseId(warehouseId);
        report.setReportDate(reportDate);
        report.setCreatedBy(currentUser.getUserId());
        report.setStatus(status);
        report.setItems(validItems);

        // Logic mới: Gán ghi chú dựa trên vai trò người dùng
        if (currentUser.getRoleId() == 2) { // Manager
            report.setManagerNotes(notesFromRequest != null ? notesFromRequest.trim() : "");
            // Đảm bảo notes (staff note) không bị ghi đè nếu manager tạo
            report.setNotes(""); 
        } else { // Staff (roleId = 4)
            report.setNotes(notesFromRequest != null ? notesFromRequest.trim() : "");
            // Đảm bảo managerNotes không bị ghi đè nếu staff tạo
            report.setManagerNotes(""); 
        }

        int generatedReportId = stockCheckReportDAO.createStockCheckReport(report);

        if (generatedReportId > 0) {
            session.setAttribute("successMessage", "Stock check report '" + report.getReportCode() + "' created successfully!");
            if (request.getServletPath().startsWith("/staff")) {
                response.sendRedirect(request.getContextPath() + "/staff/list-stock-check-reports");
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
            }
        } else {
            request.setAttribute("errorMessage", "Error creating stock check report. Please try again.");
            doGet(request, response);
        }
    }
}
