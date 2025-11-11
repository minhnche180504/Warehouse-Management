package controller.warehouse;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.WarehouseDisplay;
import dao.WarehouseDAO;
import utils.AuthorizationService;

@WebServlet("/admin/addWarehouse")
public class AddWarehouseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        // Forward to warehouse-add.jsp page
        request.getRequestDispatcher("/admin/warehouse-add.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String warehouseName = request.getParameter("name");
        String address = request.getParameter("address");
        String managerIdStr = request.getParameter("manager_id");
        String status = request.getParameter("status");
        String region = request.getParameter("region");

        // ==== VALIDATE ====
        if (warehouseName == null || warehouseName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()+"/admin/warehouse-add.jsp?msg=empty_name");
            return;
        }
        // Tên chỉ cho phép chữ, số, khoảng trắng, -, ,
        if (!warehouseName.matches("^[\\p{L}0-9\\s\\-,]+$")) {
            response.sendRedirect(request.getContextPath()+"/admin/warehouse-add.jsp?msg=invalid_name");
            return;
        }
        if (address == null || address.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()+"/admin/warehouse-add.jsp?msg=empty_address");
            return;
        }
        if (address.matches("^\\d+$")) {
            response.sendRedirect(request.getContextPath()+"/admin/warehouse-add.jsp?msg=invalid_address_number");
            return;
        }
        if (!address.matches("^[\\p{L}0-9\\s\\-,]+$")) {
            response.sendRedirect(request.getContextPath()+"/admin/warehouse-add.jsp?msg=invalid_address");
            return;
        }
        if (status == null || status.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()+"/admin/warehouse-add.jsp?msg=empty_status");
            return;
        }
        
        int managerId = 0;
        managerId = Integer.parseInt(managerIdStr);
        
        WarehouseDAO dao = new WarehouseDAO();
        if (dao.isWarehouseNameExists(warehouseName)) {
            response.sendRedirect(request.getContextPath()+"/admin/warehouse-add.jsp?msg=duplicate");
            return;
        }

        WarehouseDisplay warehouse = new WarehouseDisplay();
        warehouse.setWarehouseName(warehouseName);
        warehouse.setAddress(address);
        warehouse.setStatus(status);
        warehouse.setManagerId(managerId);
        warehouse.setRegion(region);

        boolean success = dao.insertWarehouse(warehouse);

        if (success) {
            response.sendRedirect(request.getContextPath()+"/admin/warehouse-add.jsp?msg=success");
        } else {
            response.sendRedirect(request.getContextPath()+"/admin/warehouse-add.jsp?msg=fail");
        }
    }
}
