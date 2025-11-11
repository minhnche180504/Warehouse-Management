package controller.transferorder;

import dao.ProductDAO;
import dao.TransferOrderDAO;
import dao.WarehouseDAO;
import dao.PurchaseOrderDAO;
import dao.SalesOrderDAO;
import dao.InventoryTransferDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.TransferOrder;
import model.TransferOrderItem;
import model.User;
import model.WarehouseDisplay;
import utils.AuthorizationService;

/**
 * Servlet for editing existing transfer orders
 */
@WebServlet(name = "EditTransferOrder", urlPatterns = {"/staff/edit-transfer-order"})
public class EditTransferOrder extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            // Get transfer order ID from request parameter
            String transferOrderIdStr = request.getParameter("id");
            
            // Validate transfer order ID
            if (transferOrderIdStr == null || transferOrderIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            int transferOrderId;
            try {
                transferOrderId = Integer.parseInt(transferOrderIdStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            // Get transfer order data
            TransferOrderDAO transferOrderDAO = new TransferOrderDAO();
            TransferOrder transferOrder = transferOrderDAO.getTransferOrderById(transferOrderId);
            
            // Validate order exists
            if (transferOrder == null) {
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            // Get order items
            List<TransferOrderItem> items = transferOrderDAO.getTransferOrderItems(transferOrderId);
            transferOrder.setItems(items);
            
            // Get all warehouses for dropdowns
            WarehouseDAO warehouseDAO = new WarehouseDAO();
            List<WarehouseDisplay> warehouses = warehouseDAO.getAllWarehouses();
            
            // Get current user's warehouse information
            HttpSession session = request.getSession();
            User loggedInUser = (User) session.getAttribute("user");
            if (loggedInUser != null) {
                request.setAttribute("currentUserWarehouseId", loggedInUser.getWarehouseId());
            }
            
            // Get all products for the item selection
            ProductDAO productDAO = new ProductDAO();
            List<Product> products = productDAO.getAll();
            
            // Set page title based on transfer type and prevent changing it
            String transferType = transferOrder.getTransferType();
            request.setAttribute("transferType", transferType);  // Add transfer type to request to ensure it can't be changed
            
            // Load reference documents based on transfer type
            if ("import".equals(transferType)) {
                // Get pending purchase orders for import type
                PurchaseOrderDAO purchaseOrderDAO = new PurchaseOrderDAO();
                List<model.PurchaseOrder> pendingPurchaseOrders = purchaseOrderDAO.getAllPendingPurchaseOrders();
                request.setAttribute("pendingPurchaseOrders", pendingPurchaseOrders);
                
                // Get processing inventory transfers for import type - only "Delivery" status
                InventoryTransferDAO inventoryTransferDAO = new InventoryTransferDAO();
                List<model.InventoryTransfer> processingInventoryTransfers = inventoryTransferDAO.getInventoryTransfersByStatus("Delivery");
                request.setAttribute("processingInventoryTransfers", processingInventoryTransfers);
            } else if ("export".equals(transferType)) {
                // Get order sales orders for export type (orders with "Order" status)
                SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
                List<model.SalesOrder> orderSalesOrders = salesOrderDAO.getAllPendingSalesOrders();
                request.setAttribute("orderSalesOrders", orderSalesOrders);
                
                // Get processing inventory transfers for export type - only "pending" status
                InventoryTransferDAO inventoryTransferDAO = new InventoryTransferDAO();
                List<model.InventoryTransfer> processingInventoryTransfers = inventoryTransferDAO.getInventoryTransfersByStatus("pending");
                request.setAttribute("processingInventoryTransfers", processingInventoryTransfers);
            }
            
            if (transferType != null) {
                switch (transferType) {
                    case "import":
                        request.setAttribute("pageTitle", "Edit Import Order");
                        request.setAttribute("pageDescription", "Update existing import order details");
                        break;
                    case "export":
                        request.setAttribute("pageTitle", "Edit Export Order");
                        request.setAttribute("pageDescription", "Update existing export order details");
                        break;
                    case "transfer":
                        request.setAttribute("pageTitle", "Edit Transfer Order");
                        request.setAttribute("pageDescription", "Update existing transfer order details");
                        break;
                    default:
                        request.setAttribute("pageTitle", "Edit Transfer Order");
                        break;
                }
            } else {
                request.setAttribute("pageTitle", "Edit Transfer Order");
            }
            
            // Set request attributes
            request.setAttribute("transferOrder", transferOrder);
            request.setAttribute("items", items);
            request.setAttribute("warehouses", warehouses);
            request.setAttribute("products", products);
            
            // Forward to edit page
            request.getRequestDispatcher("/staff/transfer-order-edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User loggedInUser = (User) session.getAttribute("user");

            if (loggedInUser == null) {
                // User not logged in, redirect to login page
                response.sendRedirect("login");
                return;
            }
            
            // Get transfer order ID and validate
            String transferOrderIdStr = request.getParameter("transferOrderId");
            if (transferOrderIdStr == null || transferOrderIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            int transferOrderId;
            try {
                transferOrderId = Integer.parseInt(transferOrderIdStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            // Get the existing transfer order
            TransferOrderDAO transferOrderDAO = new TransferOrderDAO();
            TransferOrder existingOrder = transferOrderDAO.getTransferOrderById(transferOrderId);
            
            if (existingOrder == null) {
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            // Check if order can be edited (only draft orders can be edited)
            if (!"draft".equalsIgnoreCase(existingOrder.getStatus())) {
                session.setAttribute("errorMessage", "Only draft orders can be edited.");
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }            
            // Get form data for the transfer order
            // Use the existing transfer type from the order, don't allow changing it
            String transferType = existingOrder.getTransferType();
            
            // Handle warehouse assignment based on transfer type and requirements
            int sourceWarehouseId;
            Integer destinationWarehouseId = null;
            
            if ("import".equals(transferType)) {
                // For import: source is warehouse 0, destination is current user's warehouse
                sourceWarehouseId = 0;
                Integer userWarehouseId = loggedInUser.getWarehouseId();
                destinationWarehouseId = (userWarehouseId != null) ? userWarehouseId : 1;
            } else if ("export".equals(transferType)) {
                // For export: source is current user's warehouse, destination is warehouse 0
                Integer userWarehouseId = loggedInUser.getWarehouseId();
                sourceWarehouseId = (userWarehouseId != null) ? userWarehouseId : 1;
                destinationWarehouseId = 0;
            } else {
                // For other types (legacy transfer): use form values
                sourceWarehouseId = Integer.parseInt(request.getParameter("sourceWarehouseId"));
                String destWarehouseParam = request.getParameter("destinationWarehouseId");
                if (destWarehouseParam != null && !destWarehouseParam.isEmpty()) {
                    destinationWarehouseId = Integer.parseInt(destWarehouseParam);
                }
            }

            // Handle document reference ID (Sales Order or Purchase Order)
            // Note: Document reference type is preserved from the existing order
            Integer documentRefId = null;
            String documentRefType = null;
            String documentRefIdParam = request.getParameter("documentRefId");
            if (documentRefIdParam != null && !documentRefIdParam.isEmpty()) {
                // Extract document type and numeric ID from prefixed values (SO-123, PO-456, IR-789, IT-012)
                if (documentRefIdParam.startsWith("SO-")) {
                    documentRefType = "SO";
                    documentRefId = Integer.parseInt(documentRefIdParam.substring(3));
                } else if (documentRefIdParam.startsWith("PO-")) {
                    documentRefType = "PO";
                    documentRefId = Integer.parseInt(documentRefIdParam.substring(3));
                } else if (documentRefIdParam.startsWith("IR-")) {
                    documentRefType = "IR";
                    documentRefId = Integer.parseInt(documentRefIdParam.substring(3));
                } else if (documentRefIdParam.startsWith("IT-")) {
                    documentRefType = "IT";
                    documentRefId = Integer.parseInt(documentRefIdParam.substring(3));
                } else {
                    // Handle legacy numeric-only reference IDs
                    try {
                        documentRefId = Integer.parseInt(documentRefIdParam);
                        documentRefType = existingOrder.getDocumentRefType(); // Keep existing type
                    } catch (NumberFormatException e) {
                        // Invalid format, ignore
                    }
                }
            }

            String description = request.getParameter("description");            // Update the transfer order object
            existingOrder.setSourceWarehouseId(sourceWarehouseId);
            existingOrder.setDestinationWarehouseId(destinationWarehouseId);
            // Don't change the transfer type - use the existing one
            existingOrder.setDescription(description);
            existingOrder.setDocumentRefId(documentRefId);
            if (documentRefType != null) {
                existingOrder.setDocumentRefType(documentRefType); // Set the document reference type
            }
            
            // Keep original created info
            // existingOrder.setStatus("draft");

            // Parse item data from the form
            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");
            
            List<TransferOrderItem> items = new ArrayList<>();

            if (productIds != null && quantities != null && productIds.length == quantities.length) {
                for (int i = 0; i < productIds.length; i++) {
                    int productId = Integer.parseInt(productIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);

                    // Skip items with quantity <= 0
                    if (quantity <= 0) {
                        continue;
                    }

                    TransferOrderItem item = new TransferOrderItem();
                    item.setProductId(productId);
                    item.setQuantity(quantity);
                    items.add(item);
                }
            }

            // Update the transfer order with items
            boolean success = transferOrderDAO.updateTransferOrderWithItems(existingOrder, items);

            if (success) {
                // Set success message and redirect to the list page
                session.setAttribute("successMessage", "Transfer order updated successfully!");
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
            } else {
                // If update failed, return to the form with an error message
                request.setAttribute("errorMessage", "Failed to update transfer order. Please try again.");

                // Repopulate form data
                request.setAttribute("transferOrder", existingOrder);
                request.setAttribute("items", items);

                // Reload warehouses and products
                WarehouseDAO warehouseDAO = new WarehouseDAO();
                List<WarehouseDisplay> warehouses = warehouseDAO.getAllWarehouses();
                request.setAttribute("warehouses", warehouses);

                ProductDAO productDAO = new ProductDAO();
                List<Product> products = productDAO.getAll();
                request.setAttribute("products", products);

                request.getRequestDispatcher("/staff/transfer-order-edit.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Edit Transfer Order Servlet";
    }
}
