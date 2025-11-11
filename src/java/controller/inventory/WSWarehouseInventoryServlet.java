package controller.inventory;

import dao.InventoryDAO;
import dao.AuthorizationUtil;
import model.Inventory;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import utils.AuthorizationService;

@WebServlet(name = "WSWarehouseInventoryServlet", urlPatterns = {"/staff/ws-warehouse-inventory"})
public class WSWarehouseInventoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Chỉ Warehouse Staff mới được truy cập
        if (!AuthorizationUtil.isWarehouseStaff(currentUser)) {
            request.setAttribute("errorMessage", "You do not have permission to view this page.");
            request.getRequestDispatcher("/staff/error.jsp").forward(request, response);
            return;
        }

        Integer warehouseId = currentUser.getWarehouseId();
        if (warehouseId == null) {
            request.setAttribute("errorMessage", "You are not assigned to any warehouse. Please contact an administrator.");
            // Load warehouses and products for dropdowns if needed by the error page or a generic page
            request.getRequestDispatcher("/staff/ws-warehouse-inventory.jsp").forward(request, response); // Hoặc trang lỗi phù hợp
            return;
        }

        try {
            InventoryDAO inventoryDAO = new InventoryDAO();
            List<model.Inventory> inventoryItems = inventoryDAO.getProductsByWarehouse(warehouseId);

            request.setAttribute("inventoryItems", inventoryItems);
            request.setAttribute("currentUser", currentUser);
            if (!inventoryItems.isEmpty()) {
                request.setAttribute("warehouseNameForTitle", inventoryItems.get(0).getWarehouseName());
            } else {
                 // Nếu kho không có sản phẩm, cần lấy tên kho từ WarehouseDAO
                dao.WarehouseDAO warehouseDAO = new dao.WarehouseDAO();
                model.WarehouseDisplay warehouse = warehouseDAO.getWarehouseById(warehouseId);
                if (warehouse != null) {
                    request.setAttribute("warehouseNameForTitle", warehouse.getWarehouseName());
                }
            }
            request.getRequestDispatcher("/staff/ws-warehouse-inventory.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while retrieving your warehouse inventory: " + e.getMessage());
            request.getRequestDispatcher("/staff/error.jsp").forward(request, response);
        }
    }
}
