package controller.warehouse;
import dao.WarehouseDAO;
import model.WarehouseDisplay;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import utils.AuthorizationService;

@WebServlet("/admin/UpdateWarehouseServlet")
public class UpdateWarehouseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        // Bỏ kiểm tra warehouseId, luôn forward đến trang cập nhật
        String warehouseId = request.getParameter("id");
        request.setAttribute("id", warehouseId);
        request.getRequestDispatcher("/admin/warehouse-edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String warehouseIdStr = request.getParameter("warehouseId");
        String warehouseName = request.getParameter("warehouseName");
        String address = request.getParameter("address");
        String managerIdStr = request.getParameter("managerId");
        String status = request.getParameter("status");
        String region = request.getParameter("region");

        String contextPath = request.getContextPath();
        String redirectURL = contextPath + "/admin/warehouse-update.jsp?id=" + warehouseIdStr;

        // ==== VALIDATE ====
        if (warehouseIdStr == null || warehouseName == null || warehouseName.trim().isEmpty()
                || managerIdStr == null || status == null || status.trim().isEmpty()) {
            response.sendRedirect(redirectURL + "&msg=error");
            return;
        }
        if (!warehouseName.matches("^[\\p{L}0-9\\s\\-,]+$")) {
            response.sendRedirect(redirectURL + "&msg=invalid_name");
            return;
        }
        if (address == null || address.trim().isEmpty()) {
            response.sendRedirect(redirectURL + "&msg=empty_address");
            return;
        }
        if (address.matches("^\\d+$")) {
            response.sendRedirect(redirectURL + "&msg=invalid_address_number");
            return;
        }
        if (!address.matches("^[\\p{L}0-9\\s\\-,]+$")) {
            response.sendRedirect(redirectURL + "&msg=invalid_address");
            return;
        }

        int warehouseId;
        int managerId;
        try {
            warehouseId = Integer.parseInt(warehouseIdStr);
            managerId = Integer.parseInt(managerIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(redirectURL + "&msg=error");
            return;
        }

        try {
            WarehouseDAO warehouseDAO = new WarehouseDAO();

            // Kiểm tra tồn kho
            int totalProducts = warehouseDAO.getTotalProductsPerWarehouse(warehouseId);
            if (totalProducts > 0 && "Inactive".equalsIgnoreCase(status)) {
                response.sendRedirect(redirectURL + "&msg=error_inactive_with_stock");
                return;
            }
            
            // Kiểm tra trùng tên (ngoại trừ warehouse hiện tại)
            if (warehouseDAO.isWarehouseNameExistsExcept(warehouseName, warehouseId)) {
                response.sendRedirect(redirectURL + "&msg=duplicate");
                return;
            }

            // Tạo object warehouse để update
            WarehouseDisplay warehouse = new WarehouseDisplay();
            warehouse.setWarehouseId(warehouseId);
            warehouse.setWarehouseName(warehouseName);
            warehouse.setAddress(address);
            warehouse.setManagerId(managerId == 0 ? 0 : managerId);
            warehouse.setStatus(status);
            warehouse.setRegion(region);

            boolean success = warehouseDAO.updateWarehouse(warehouse);

            if (success) {
                response.sendRedirect(redirectURL + "&msg=success");
            } else {
                response.sendRedirect(redirectURL + "&msg=fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(redirectURL + "&msg=error");
        }
    }
}
