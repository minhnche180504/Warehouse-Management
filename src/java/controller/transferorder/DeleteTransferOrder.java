package controller.transferorder;

import dao.TransferOrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.TransferOrder;
import model.User;
import utils.AuthorizationService;

/**
 * Servlet for deleting transfer orders
 */
@WebServlet(name = "DeleteTransferOrder", urlPatterns = {"/staff/delete-transfer-order"})
public class DeleteTransferOrder extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");
        
        // Check if user is logged in
        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Get transfer order ID from request parameter
        String transferOrderIdStr = request.getParameter("id");
        
        // Validate transfer order ID
        if (transferOrderIdStr == null || transferOrderIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid transfer order ID.");
            response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
            return;
        }
        
        int transferOrderId;
        try {
            transferOrderId = Integer.parseInt(transferOrderIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid transfer order ID format.");
            response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
            return;
        }
        
        try {
            // Get the transfer order to check its status
            TransferOrderDAO transferOrderDAO = new TransferOrderDAO();
            TransferOrder transferOrder = transferOrderDAO.getTransferOrderById(transferOrderId);
            
            if (transferOrder == null) {
                session.setAttribute("errorMessage", "Transfer order not found.");
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            // Only allow deletion of draft orders
            if (!"draft".equalsIgnoreCase(transferOrder.getStatus())) {
                session.setAttribute("errorMessage", "Only draft orders can be deleted.");
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            // Delete the transfer order
            boolean success = transferOrderDAO.deleteTransferOrder(transferOrderId);
            
            if (success) {
                session.setAttribute("successMessage", "Transfer order deleted successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to delete transfer order.");
            }
            
            // Redirect to the transfer order list page
            response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
        }
    }

    @Override
    public String getServletInfo() {
        return "Delete Transfer Order Servlet";
    }
}
