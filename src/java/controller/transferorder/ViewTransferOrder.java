package controller.transferorder;

import dao.TransferOrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.TransferOrder;
import utils.AuthorizationService;

/**
 * Servlet for viewing transfer order details
 */
@WebServlet(name = "ViewTransferOrder", urlPatterns = {"/staff/view-transfer-order"})
public class ViewTransferOrder extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            // Get transfer order ID from request parameter
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.isEmpty()) {
                // No ID provided, redirect to list page
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            int transferOrderId = Integer.parseInt(idParam);
            
            // Fetch transfer order details from database
            TransferOrderDAO transferOrderDAO = new TransferOrderDAO();
            TransferOrder transferOrder = transferOrderDAO.getTransferOrderById(transferOrderId);
            
            if (transferOrder == null) {
                // Transfer order not found
                request.setAttribute("errorMessage", "Transfer order not found with ID: " + transferOrderId);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            // Set the transfer order details in the request
            request.setAttribute("transferOrder", transferOrder);
            
            // Set page title based on transfer type
            String pageTitle;
            switch(transferOrder.getTransferType()) {
                case "import":
                    pageTitle = "Import Order Details #" + transferOrderId;
                    break;
                case "export":
                    pageTitle = "Export Order Details #" + transferOrderId;
                    break;
                default:
                    pageTitle = "Transfer Order Details #" + transferOrderId;
                    break;
            }
            request.setAttribute("pageTitle", pageTitle);
            
            // Forward to the view page
            request.getRequestDispatcher("/staff/transfer-order-view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Invalid ID format
            request.setAttribute("errorMessage", "Invalid transfer order ID format");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "View Transfer Order Servlet";
    }
}