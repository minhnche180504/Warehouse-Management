package controller.transferorder;

import dao.InventoryDAO;
import dao.ProductDAO;
import dao.PurchaseOrderDAO;
import dao.PurchaseOrderItemDAO;
import dao.SalesOrderDAO;
import dao.SalesOrderItemDAO;
import dao.TransferOrderDAO;
import dao.WarehouseDAO;
import dao.InventoryTransferDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import model.SalesOrder;
import model.SalesOrderItem;
import model.TransferOrder;
import model.TransferOrderItem;
import model.User;
import model.WarehouseDisplay;
import model.InventoryTransfer;
import model.InventoryTransferItem;
import utils.AuthorizationService;

/**
 * Servlet for creating new transfer orders
 */
@WebServlet(name = "CreateTransferOrder", urlPatterns = {"/staff/create-transfer-order"})
public class CreateTransferOrder extends HttpServlet {

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
                response.sendRedirect("login");
                return;
            }

            // Get all warehouses for dropdowns
            WarehouseDAO warehouseDAO = new WarehouseDAO();
            List<WarehouseDisplay> warehouses = warehouseDAO.getAllWarehouses();
            request.setAttribute("warehouses", warehouses);

            // Get current user's warehouse information
            request.setAttribute("currentUserWarehouseId", loggedInUser.getWarehouseId());

            // Get all products for the item selection
            ProductDAO productDAO = new ProductDAO();
            List<Product> products = productDAO.getAll();
            request.setAttribute("products", products);            // Transfer type must be specified in request - required parameter
            String transferType = request.getParameter("type");
            if (transferType == null || transferType.isEmpty()) {
                // Redirect to list page if no type specified
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            // Only allow import and export types (transfer is now handled by InventoryTransfer)
            if (!"import".equals(transferType) && !"export".equals(transferType)) {
                // Invalid transfer type - redirect to list page
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                return;
            }
            
            // Set the transfer type as a hidden attribute - can't be changed later
            request.setAttribute("transferType", transferType);
            request.setAttribute("selectedType", transferType);
                       
            SalesOrderDAO salesOrderDAO = new SalesOrderDAO();

            // Set page title based on transfer type and load specific data
            switch (transferType) {
                case "import":
                    request.setAttribute("pageTitle", "Create Import Order");
                    request.setAttribute("pageDescription", "Create a new import order to bring items into inventory");
                    
                    // Get pending purchase orders for import type
                    PurchaseOrderDAO purchaseOrderDAO = new PurchaseOrderDAO();
                    List<PurchaseOrder> pendingPurchaseOrders = purchaseOrderDAO.getAllPendingPurchaseOrders();
                    request.setAttribute("pendingPurchaseOrders", pendingPurchaseOrders);
                    
                    // Get processing inventory transfers for import type - only "Delivery" status
                    InventoryTransferDAO inventoryTransferDAO = new InventoryTransferDAO();
                    List<InventoryTransfer> processingInventoryTransfers = inventoryTransferDAO.getInventoryTransfersByStatus("Delivery");
                    request.setAttribute("processingInventoryTransfers", processingInventoryTransfers);
                    
                    // Get returning sales orders for import type (for returns)
                    
                    List<SalesOrder> returningSalesOrders = salesOrderDAO.getReturningSalesOrdersByWarehouse(loggedInUser.getWarehouseId());
                    request.setAttribute("returningSalesOrders", returningSalesOrders);
                    
                    // Check if a specific purchase order is selected for pre-population
                    String selectedPoId = request.getParameter("poId");
                    if (selectedPoId != null && !selectedPoId.isEmpty()) {
                        try {
                            Integer poId = Integer.parseInt(selectedPoId);
                            PurchaseOrder selectedPO = purchaseOrderDAO.getById(poId);
                            if (selectedPO != null && "Pending".equals(selectedPO.getStatus())) {
                                // Get purchase order items
                                PurchaseOrderItemDAO poItemDAO = new PurchaseOrderItemDAO();
                                List<PurchaseOrderItem> poItems = poItemDAO.getByPurchaseOrderId(poId);
                                
                                request.setAttribute("selectedPurchaseOrder", selectedPO);
                                request.setAttribute("selectedPurchaseOrderItems", poItems);
                            }
                        } catch (NumberFormatException e) {
                            // Invalid PO ID, ignore
                        }
                    }
                    
                    // Check if a specific inventory transfer is selected for pre-population
                    String selectedItId = request.getParameter("itId");
                    if (selectedItId != null && !selectedItId.isEmpty()) {
                        try {
                            Integer itId = Integer.parseInt(selectedItId);
                            InventoryTransfer selectedIT = inventoryTransferDAO.getInventoryTransferById(itId);
                            if (selectedIT != null && "delivery".equalsIgnoreCase(selectedIT.getStatus())) {
                                // Get inventory transfer items
                                List<InventoryTransferItem> itItems = inventoryTransferDAO.getInventoryTransferItems(itId);
                                
                                request.setAttribute("selectedInventoryTransfer", selectedIT);
                                request.setAttribute("selectedInventoryTransferItems", itItems);
                            }
                        } catch (NumberFormatException e) {
                            // Invalid IT ID, ignore
                        }
                    }
                    
                    // Check if a specific returning sales order is selected for pre-population
                    String selectedReturningSoId = request.getParameter("returningSoId");
                    if (selectedReturningSoId != null && !selectedReturningSoId.isEmpty()) {
                        try {
                            Integer soId = Integer.parseInt(selectedReturningSoId);
                            SalesOrder selectedSO = salesOrderDAO.getSalesOrderById(soId);
                            if (selectedSO != null && "returning".equals(selectedSO.getStatus()) && selectedSO.getWarehouseId() == loggedInUser.getWarehouseId()) {
                                // Get sales order items
                                SalesOrderItemDAO soItemDAO = new SalesOrderItemDAO();
                                List<SalesOrderItem> soItems = soItemDAO.getSalesOrderItemsBySoId(soId);
                                
                                request.setAttribute("selectedReturningSalesOrder", selectedSO);
                                request.setAttribute("selectedReturningSalesOrderItems", soItems);
                            }
                        } catch (NumberFormatException e) {
                            // Invalid SO ID, ignore
                        }
                    }
                    break;
                case "export":
                    request.setAttribute("pageTitle", "Create Export Order");
                    request.setAttribute("pageDescription", "Create a new export order to send items out from inventory");
                    
                    // Get order sales orders for export type (orders with "Order" status)
                    List<SalesOrder> orderSalesOrders = salesOrderDAO.getAllPendingSalesOrders();
                    request.setAttribute("orderSalesOrders", orderSalesOrders);
                    
                    // Get processing inventory transfers for export type - only "pending" status
                    InventoryTransferDAO inventoryTransferDAO2 = new InventoryTransferDAO();
                    List<InventoryTransfer> processingInventoryTransfers2 = inventoryTransferDAO2.getInventoryTransfersByStatus("processing");
                    request.setAttribute("processingInventoryTransfers", processingInventoryTransfers2);
                    
                    // Check if a specific sales order is selected for pre-population
                    String selectedSoId = request.getParameter("soId");
                    if (selectedSoId != null && !selectedSoId.isEmpty()) {
                        try {
                            Integer soId = Integer.parseInt(selectedSoId);
                            SalesOrder selectedSO = salesOrderDAO.getSalesOrderById(soId);
                            if (selectedSO != null && "Order".equals(selectedSO.getStatus())) {
                                // Get sales order items
                                SalesOrderItemDAO soItemDAO = new SalesOrderItemDAO();
                                List<SalesOrderItem> soItems = soItemDAO.getSalesOrderItemsBySoId(soId);
                                
                                request.setAttribute("selectedSalesOrder", selectedSO);
                                request.setAttribute("selectedSalesOrderItems", soItems);
                            }
                        } catch (NumberFormatException e) {
                            // Invalid SO ID, ignore
                        }
                    }
                    
                    // Check if a specific inventory transfer is selected for pre-population
                    String selectedItId2 = request.getParameter("itId");
                    if (selectedItId2 != null && !selectedItId2.isEmpty()) {
                        try {
                            Integer itId = Integer.parseInt(selectedItId2);
                            InventoryTransfer selectedIT = inventoryTransferDAO2.getInventoryTransferById(itId);
                            if (selectedIT != null && "processing".equals(selectedIT.getStatus())) {
                                // Get inventory transfer items
                                List<InventoryTransferItem> itItems = inventoryTransferDAO2.getInventoryTransferItems(itId);
                                
                                request.setAttribute("selectedInventoryTransfer", selectedIT);
                                request.setAttribute("selectedInventoryTransferItems", itItems);
                            }
                        } catch (NumberFormatException e) {
                            // Invalid IT ID, ignore
                        }
                    }
                    break;
                default:
                    // Invalid transfer type - only import and export are supported
                    response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                    return;
            }

            // Forward to the form page
            request.getRequestDispatcher("/staff/transfer-order-create.jsp").forward(request, response);
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

            // Get form data for the transfer order            
            String transferType = request.getParameter("transferType");
            
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
                // For other types (legacy): use form values
                sourceWarehouseId = Integer.parseInt(request.getParameter("sourceWarehouseId"));
                String destWarehouseParam = request.getParameter("destinationWarehouseId");
                if (destWarehouseParam != null && !destWarehouseParam.isEmpty()) {
                    destinationWarehouseId = Integer.parseInt(destWarehouseParam);
                }
            }

            // Handle document reference ID (Sales Order, Purchase Order, Import Request, or Inventory Transfer)
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
                } else if (documentRefIdParam.startsWith("RSO-")) {
                    documentRefType = "RSO";
                    documentRefId = Integer.parseInt(documentRefIdParam.substring(4));
                } else if (documentRefIdParam.startsWith("RSO-")) {
                    documentRefType = "RSO";
                    documentRefId = Integer.parseInt(documentRefIdParam.substring(4));
                } else {
                    // Fallback for legacy numeric values
                    documentRefId = Integer.parseInt(documentRefIdParam);
                }
            }

            String description = request.getParameter("description");

            // Determine status based on the action button clicked
            String action = request.getParameter("action");
            String status = "completed"; // Default to completed
            if ("saveDraft".equals(action)) {
                status = "draft";
            }

            // Create the transfer order object
            TransferOrder order = new TransferOrder();
            order.setSourceWarehouseId(sourceWarehouseId);
            order.setDestinationWarehouseId(destinationWarehouseId);
            order.setTransferType(transferType);
            order.setStatus(status);
            order.setDescription(description);
            order.setDocumentRefId(documentRefId); // Set the document reference ID
            order.setDocumentRefType(documentRefType); // Set the document reference type
            order.setCreatedBy(loggedInUser.getUserId());
            order.setTransferDate(LocalDateTime.now());
            order.setCreatedDate(LocalDateTime.now());

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

            // Check inventory and update if status is completed
            if ("completed".equals(status)) {
                InventoryDAO inventoryDAO = new InventoryDAO();
                boolean inventoryCheckSuccess = true;
                String inventoryError = null;
                
                // First, check if we have enough stock for exports and transfers
                for (TransferOrderItem item : items) {
                    switch (transferType) {
                        case "export":
                            if (!inventoryDAO.checkStock(item.getProductId(), sourceWarehouseId, item.getQuantity())) {
                                inventoryError = "Not enough stock in source warehouse for product ID " + item.getProductId() + 
                                               ". Required: " + item.getQuantity() + ", Available: " + 
                                               inventoryDAO.getCurrentStock(item.getProductId(), sourceWarehouseId);
                                inventoryCheckSuccess = false;
                            }
                            break;
                        case "import":
                            // No stock check needed for imports
                            break;
                    }
                    
                    if (!inventoryCheckSuccess) {
                        break;
                    }
                }
                
                if (!inventoryCheckSuccess) {
                    // Return to form with error message
                    request.setAttribute("errorMessage", inventoryError);
                    request.setAttribute("transferOrder", order);
                    request.setAttribute("items", items);
                    
                    // Reload warehouses and products
                    WarehouseDAO warehouseDAO = new WarehouseDAO();
                    List<WarehouseDisplay> warehouses = warehouseDAO.getAllWarehouses();
                    request.setAttribute("warehouses", warehouses);
                    request.setAttribute("currentUserWarehouseId", loggedInUser.getWarehouseId());

                    ProductDAO productDAO = new ProductDAO();
                    List<Product> products = productDAO.getAll();
                    request.setAttribute("products", products);
                    
                    request.setAttribute("transferType", transferType);
                    request.setAttribute("selectedType", transferType);
                    
                    // Set page title based on transfer type
                    switch (transferType) {
                        case "import":
                            request.setAttribute("pageTitle", "Create Import Order");
                            request.setAttribute("pageDescription", "Create a new import order to bring items into inventory");

                            // Get pending purchase orders for import type
                            PurchaseOrderDAO purchaseOrderDAO = new PurchaseOrderDAO();
                            List<PurchaseOrder> pendingPurchaseOrders = purchaseOrderDAO.getAllPendingPurchaseOrders();
                            request.setAttribute("pendingPurchaseOrders", pendingPurchaseOrders);

                            // Get processing inventory transfers for import type
                            InventoryTransferDAO inventoryTransferDAO = new InventoryTransferDAO();
                            List<InventoryTransfer> processingInventoryTransfers = inventoryTransferDAO.getInventoryTransfersByStatus("pending");
                            request.setAttribute("processingInventoryTransfers", processingInventoryTransfers);
                            break;
                        case "export":
                            request.setAttribute("pageTitle", "Create Export Order");
                            request.setAttribute("pageDescription", "Create a new export order to send items out from inventory");

                            // Get order sales orders for export type (orders with "Order" status)
                            SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
                            List<SalesOrder> orderSalesOrders = salesOrderDAO.getAllPendingSalesOrders();
                            request.setAttribute("orderSalesOrders", orderSalesOrders);

                            // Get processing inventory transfers for export type
                            InventoryTransferDAO inventoryTransferDAO2 = new InventoryTransferDAO();
                            List<InventoryTransfer> processingInventoryTransfers2 = inventoryTransferDAO2.getInventoryTransfersByStatus("pending");
                            request.setAttribute("processingInventoryTransfers", processingInventoryTransfers2);
                            break;
                    }

                    request.getRequestDispatcher("/staff/transfer-order-create.jsp").forward(request, response);
                    return;
                }
            }

            // Save the transfer order with items
            TransferOrderDAO transferOrderDAO = new TransferOrderDAO();
            
            boolean success;
            
            // If status is completed, create order and then complete it properly
            if ("completed".equals(status)) {
                int orderId = transferOrderDAO.createTransferOrderWithItemsAndReturnId(order, items);
                if (orderId > 0) {
                    // Use the completion method to handle sales order updates
                    String refDocId = order.getDocumentRefIdString();
                    success = transferOrderDAO.completeTransferOrderWithSalesOrderUpdate(
                        orderId, 
                        loggedInUser.getUserId(), 
                        refDocId
                    );
                } else {
                    success = false;
                }
            } else {
                // For draft orders, use the regular method
                success = transferOrderDAO.createTransferOrderWithItems(order, items);
            }

            if (success) {
                // If status is completed, update inventory
                if ("completed".equals(status)) {
                    InventoryDAO inventoryDAO = new InventoryDAO();
                    boolean inventoryUpdateSuccess = true;
                    String inventoryError = null;
                    
                    try {
                        for (TransferOrderItem item : items) {
                            switch (transferType) {
                                case "export":
                                    // Decrease stock (negative quantity)
                                    if (!inventoryDAO.updateInventory(item.getProductId(), sourceWarehouseId, -item.getQuantity())) {
                                        inventoryError = "Failed to update inventory for export";
                                        inventoryUpdateSuccess = false;
                                        break;
                                    }
                                    break;
                                    
                                case "import":
                                    // Check if inventory record exists, create if not
                                    if (inventoryDAO.getCurrentStock(item.getProductId(), destinationWarehouseId) == 0) {
                                        inventoryDAO.createInventoryRecord(item.getProductId(), destinationWarehouseId, 0);
                                    }
                                    // Increase stock (positive quantity)
                                    if (!inventoryDAO.updateInventory(item.getProductId(), destinationWarehouseId, item.getQuantity())) {
                                        inventoryError = "Failed to update inventory for import";
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
                    
                    if (!inventoryUpdateSuccess) {
                        // Log the error but still show success message since order was created
                        session.setAttribute("errorMessage", "Transfer order created but inventory update failed: " + inventoryError);
                        response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
                        return;
                    }

                    // Update InventoryTransfer status if applicable
                    if (documentRefType != null && "IT".equals(documentRefType) && documentRefId != null) {
                        InventoryTransferDAO inventoryTransferDAO = new InventoryTransferDAO();
                        InventoryTransfer it = inventoryTransferDAO.getInventoryTransferById(documentRefId);
                        
                        if (it != null) {
                            String newStatus = null;
                            
                            // Determine new status based on transfer type and warehouse
                            if ("export".equals(transferType) && destinationWarehouseId != null && destinationWarehouseId == 0) {
                                newStatus = "Delivery";
                            } else if ("import".equals(transferType) && sourceWarehouseId == 0) {
                                newStatus = "Complete";
                            }
                            
                            // Update the inventory transfer status if needed
                            if (newStatus != null && !newStatus.equals(it.getStatus())) {
                                it.setStatus(newStatus);
                                inventoryTransferDAO.updateInventoryTransfer(it);
                            }
                        }
                    }
                }
                
                // Set success message based on the status
                String successMessage = "draft".equals(status) ? 
                    "Transfer order saved as draft successfully!" : 
                    "Transfer order created and completed successfully!";
                session.setAttribute("successMessage", successMessage);
                response.sendRedirect(request.getContextPath() + "/staff/list-transfer-order");
            } else {
                // If save failed, return to the form with an error message
                request.setAttribute("errorMessage", "Failed to create transfer order. Please try again.");

                // Repopulate form data
                request.setAttribute("transferOrder", order);
                request.setAttribute("items", items);

                // Reload warehouses and products
                WarehouseDAO warehouseDAO = new WarehouseDAO();
                List<WarehouseDisplay> warehouses = warehouseDAO.getAllWarehouses();
                request.setAttribute("warehouses", warehouses);
                request.setAttribute("currentUserWarehouseId", loggedInUser.getWarehouseId());

                ProductDAO productDAO = new ProductDAO();
                List<Product> products = productDAO.getAll();
                request.setAttribute("products", products);

                request.getRequestDispatcher("/staff/transfer-order-create.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Create Transfer Order Servlet";
    }
}
