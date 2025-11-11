package controller.transferorder;

import dao.InventoryDAO;
import dao.TransferOrderDAO;
import dao.TransferOrderItemDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.TransferOrder;
import model.TransferOrderItem;
import model.User;
import utils.AuthorizationService;

/**
 * Servlet for completing transfer orders
 */
@WebServlet(name = "CompleteTransferOrder", urlPatterns = {"/staff/complete-transfer-order"})
public class CompleteTransferOrder extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            HttpSession session = request.getSession();
            User loggedInUser = (User) session.getAttribute("user");
            
            if (loggedInUser == null) {
                // User not logged in, redirect to login page
                response.sendRedirect("login");
                return;
            }
            
            // Get transfer order ID from request parameter
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.isEmpty()) {
                // No ID provided, redirect to list page
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            int transferOrderId = Integer.parseInt(idParam);
            
            // Fetch transfer order from database
            TransferOrderDAO transferOrderDAO = new TransferOrderDAO();
            TransferOrder transferOrder = transferOrderDAO.getTransferOrderById(transferOrderId);
            
            if (transferOrder == null) {
                // Transfer order not found
                session.setAttribute("errorMessage", "Transfer order not found with ID: " + transferOrderId);
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            // Only draft orders can be completed
            if (!"draft".equals(transferOrder.getStatus())) {
                String message = "completed".equals(transferOrder.getStatus()) ? 
                    "This transfer order is already completed" : 
                    "Only draft transfer orders can be completed";
                session.setAttribute("errorMessage", message);
                response.sendRedirect(request.getContextPath() + "/staff/view-transfer-order?id=" + transferOrderId);
                return;
            }
            
            // Get transfer order items
            TransferOrderItemDAO itemDAO = new TransferOrderItemDAO();
            List<TransferOrderItem> items = itemDAO.getItemsByTransferOrderId(transferOrderId);
            
            // Perform inventory adjustments based on the transfer type
            InventoryDAO inventoryDAO = new InventoryDAO();
            boolean inventoryUpdateSuccess = true;
            String inventoryError = null;
            
            try {
                for (TransferOrderItem item : items) {
                    switch (transferOrder.getTransferType()) {
                        case "export":
                            // For export: Decrease inventory in source warehouse
                            if (!inventoryDAO.checkStock(item.getProductId(), transferOrder.getSourceWarehouseId(), item.getQuantity())) {
                                inventoryError = "Not enough stock in source warehouse for product ID " + item.getProductId() + 
                                               ". Required: " + item.getQuantity() + ", Available: " + 
                                               inventoryDAO.getCurrentStock(item.getProductId(), transferOrder.getSourceWarehouseId());
                                inventoryUpdateSuccess = false;
                                break;
                            }
                            // Decrease stock (negative quantity)
                            if (!inventoryDAO.updateInventory(item.getProductId(), transferOrder.getSourceWarehouseId(), -item.getQuantity())) {
                                inventoryError = "Failed to update inventory for export";
                                inventoryUpdateSuccess = false;
                                break;
                            }
                            break;
                            
                        case "import":
                            // For import: Increase inventory in destination warehouse
                            // Check if inventory record exists, create if not
                            if (inventoryDAO.getCurrentStock(item.getProductId(), transferOrder.getDestinationWarehouseId()) == 0) {
                                // Try to create inventory record first
                                inventoryDAO.createInventoryRecord(item.getProductId(), transferOrder.getDestinationWarehouseId(), 0);
                            }
                            // Increase stock (positive quantity)
                            if (!inventoryDAO.updateInventory(item.getProductId(), transferOrder.getDestinationWarehouseId(), item.getQuantity())) {
                                inventoryError = "Failed to update inventory for import";
                                inventoryUpdateSuccess = false;
                                break;
                            }
                            break;
                            
                        case "transfer":
                            // For transfer: Decrease in source and increase in destination warehouse
                            // Check source warehouse stock first
                            if (!inventoryDAO.checkStock(item.getProductId(), transferOrder.getSourceWarehouseId(), item.getQuantity())) {
                                inventoryError = "Not enough stock in source warehouse for product ID " + item.getProductId() + 
                                               ". Required: " + item.getQuantity() + ", Available: " + 
                                               inventoryDAO.getCurrentStock(item.getProductId(), transferOrder.getSourceWarehouseId());
                                inventoryUpdateSuccess = false;
                                break;
                            }
                            
                            // Decrease from source
                            if (!inventoryDAO.updateInventory(item.getProductId(), transferOrder.getSourceWarehouseId(), -item.getQuantity())) {
                                inventoryError = "Failed to update source warehouse inventory for transfer";
                                inventoryUpdateSuccess = false;
                                break;
                            }
                            
                            // Check if destination inventory record exists, create if not
                            if (inventoryDAO.getCurrentStock(item.getProductId(), transferOrder.getDestinationWarehouseId()) == 0) {
                                inventoryDAO.createInventoryRecord(item.getProductId(), transferOrder.getDestinationWarehouseId(), 0);
                            }
                            
                            // Increase in destination
                            if (!inventoryDAO.updateInventory(item.getProductId(), transferOrder.getDestinationWarehouseId(), item.getQuantity())) {
                                inventoryError = "Failed to update destination warehouse inventory for transfer";
                                inventoryUpdateSuccess = false;
                                break;
                            }
                            break;
                    }
                    
                    if (!inventoryUpdateSuccess) {
                        break;
                    }
                }
            } catch (Exception e) {
                inventoryUpdateSuccess = false;
                inventoryError = "Error during inventory update: " + e.getMessage();
            }
            
            // If inventory update failed, show error and don't complete the order
            if (!inventoryUpdateSuccess) {
                session.setAttribute("errorMessage", inventoryError != null ? inventoryError : "Failed to update inventory");
                response.sendRedirect(request.getContextPath() + "/staff/view-transfer-order?id=" + transferOrderId);
                return;
            }
            
            // Update transfer order status to completed
            transferOrder.setStatus("completed");
            
            // Save changes and update referenced sales order if applicable
            String refDocId = transferOrder.getDocumentRefIdString();
            boolean success = transferOrderDAO.completeTransferOrderWithSalesOrderUpdate(
                transferOrderId, 
                loggedInUser.getUserId(), 
                refDocId
            );
            
            if (success) {
                session.setAttribute("successMessage", "Transfer order completed successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to complete transfer order");
            }
            
            // Redirect back to the view page
            response.sendRedirect(request.getContextPath() + "/staff/view-transfer-order?id=" + transferOrderId);
            
        } catch (NumberFormatException e) {
            // Invalid ID format
            request.getSession().setAttribute("errorMessage", "Invalid transfer order ID format");
            response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
        }
    }

    @Override
    public String getServletInfo() {
        return "Complete Transfer Order Servlet";
    }
}