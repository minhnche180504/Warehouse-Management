package controller.transferorder;

import dao.TransferOrderDAO;
import dao.WarehouseDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.TransferOrder;
import model.WarehouseDisplay;
import utils.AuthorizationService;

/**
 * Servlet for handling transfer order listing
 */
@WebServlet(name = "ListTransferOrder", urlPatterns = {"/staff/list-transfer-order"})
public class ListTransferOrder extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            // Get filter parameters
            String transferType = request.getParameter("type");
            String status = request.getParameter("status");
            
            TransferOrderDAO transferOrderDAO = new TransferOrderDAO();
            List<TransferOrder> transferOrders;
            
            // Apply filters if provided
            if (transferType != null && !transferType.isEmpty()) {
                // Filter by transfer type
                transferOrders = transferOrderDAO.getTransferOrdersByType(transferType);
                request.setAttribute("selectedType", transferType);
            } else if (status != null && !status.isEmpty()) {
                // Filter by status
                transferOrders = transferOrderDAO.getTransferOrdersByStatus(status);
                request.setAttribute("selectedStatus", status);
            } else {
                // Get all transfer orders
                transferOrders = transferOrderDAO.getAllTransferOrders();
            }
            
            // Get warehouses for filter dropdown
            WarehouseDAO warehouseDAO = new WarehouseDAO();
            List<WarehouseDisplay> warehouses = warehouseDAO.getAllWarehouses();
            
            // Set attributes for the view
            request.setAttribute("transferOrders", transferOrders);
            request.setAttribute("warehouses", warehouses);
            
            // Forward to the transfer order list JSP
            request.getRequestDispatcher("/staff/transfer-order-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // For form submissions (if any), just redirect to doGet
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Transfer Order Listing Servlet";
    }
}
