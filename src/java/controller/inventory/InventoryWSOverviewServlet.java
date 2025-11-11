package controller.inventory;

import dao.InventoryDAO;
import model.InventoryDetail;
import model.User;
import dao.AuthorizationUtil; // Import AuthorizationUtil

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import utils.AuthorizationService;

@WebServlet(name = "InventoryWSOverviewServlet", urlPatterns = {"/staff/inventory-ws-overview"})
public class InventoryWSOverviewServlet extends HttpServlet {

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

        // Authorization: Allow Warehouse Staff, Manager, or Admin
        if (!(AuthorizationUtil.isWarehouseStaff(currentUser) || 
              AuthorizationUtil.isWarehouseManager(currentUser) || 
              AuthorizationUtil.isAdmin(currentUser))) {
            request.setAttribute("errorMessage", "You do not have permission to view this page.");
            request.getRequestDispatcher("/staff/error.jsp").forward(request, response); // Or a suitable error page
            return;
        }

        String productIdStr = request.getParameter("productId");
        String warehouseIdStr = request.getParameter("warehouseId");

        if (productIdStr == null || productIdStr.trim().isEmpty() ||
            warehouseIdStr == null || warehouseIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Product ID and Warehouse ID are required.");
            request.getRequestDispatcher("/staff/error.jsp").forward(request, response);
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int warehouseId = Integer.parseInt(warehouseIdStr);

            InventoryDAO inventoryDAO = new InventoryDAO();
            InventoryDetail inventoryDetail = inventoryDAO.getInventoryDetail(productId, warehouseId);

            request.setAttribute("inventoryDetail", inventoryDetail); // inventoryDetail có thể null nếu không tìm thấy
            request.setAttribute("currentUser", currentUser); // Để JSP có thể sử dụng thông tin user nếu cần
            request.getRequestDispatcher("/staff/inventory-WSoverview.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Product ID or Warehouse ID format.");
            request.getRequestDispatcher("/staff/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while retrieving inventory overview: " + e.getMessage());
            request.getRequestDispatcher("/staff/error.jsp").forward(request, response);
        }
    }
}
