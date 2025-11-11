package controller.inventorytransfer;

import dao.InventoryTransferDAO;
import dao.ProductDAO;
import dao.WarehouseDAO;
import dao.ImportRequestDAO;
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
import model.InventoryTransfer;
import model.InventoryTransferItem;
import model.Product;
import model.User;
import model.WarehouseDisplay;
import model.ImportRequest;
import model.ImportRequestDetail;
import utils.AuthorizationService;

@WebServlet(name = "CreateInventoryTransfer", urlPatterns = {"/manager/create-inventory-transfer"})
public class CreateInventoryTransfer extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            AuthorizationService authService = AuthorizationService.getInstance();
            if (!authService.authorize(request, response)) {
                return;
            }
            
            HttpSession session = request.getSession();
            User loggedInUser = (User) session.getAttribute("user");

            if (loggedInUser == null) {
                response.sendRedirect("login");
                return;
            }
            
            WarehouseDAO warehouseDAO = new WarehouseDAO();
            List<WarehouseDisplay> warehouses = warehouseDAO.getAllWarehouses();
            request.setAttribute("warehouses", warehouses);

            // Get current user's warehouse information
            request.setAttribute("currentUserWarehouseId", loggedInUser.getWarehouseId());
            
            // Get current user's warehouse name
            String currentUserWarehouseName = "Unknown Warehouse";
            if (loggedInUser.getWarehouseId() != null) {
                for (WarehouseDisplay warehouse : warehouses) {
                    if (warehouse.getWarehouseId() == loggedInUser.getWarehouseId().intValue()) {
                        currentUserWarehouseName = warehouse.getWarehouseName();
                        break;
                    }
                }
            }
            request.setAttribute("currentUserWarehouseName", currentUserWarehouseName);

            ProductDAO productDAO = new ProductDAO();
            List<Product> products = productDAO.getAll();
            request.setAttribute("products", products);

            // Get all import requests for the dropdown
            ImportRequestDAO importRequestDAO = new ImportRequestDAO();
            List<ImportRequest> approvedImportRequest = importRequestDAO.getAllApprovedImportRequests();
            request.setAttribute("approvedImportRequests", approvedImportRequest);

            request.getRequestDispatcher("/manager/inventory-transfer-create.jsp").forward(request, response);
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
                response.sendRedirect("login");
                return;
            }

            int sourceWarehouseId = Integer.parseInt(request.getParameter("sourceWarehouseId"));
            int destinationWarehouseId = Integer.parseInt(request.getParameter("destinationWarehouseId"));
            String description = request.getParameter("description");

            // Handle import request ID
            Integer importRequestId = null;
            String importRequestIdParam = request.getParameter("importRequestId");
            if (importRequestIdParam != null && !importRequestIdParam.isEmpty()) {
                importRequestId = Integer.parseInt(importRequestIdParam);
            }

            if (sourceWarehouseId == destinationWarehouseId) {
                request.setAttribute("errorMessage", "Source and destination warehouses cannot be the same.");
                setupRequestAttributes(request, loggedInUser);
                request.getRequestDispatcher("/manager/inventory-transfer-create.jsp").forward(request, response);
                return;
            }

            String action = request.getParameter("action");
            String status = "pending";
            if ("saveDraft".equals(action)) {
                status = "draft";
            }

            InventoryTransfer transfer = new InventoryTransfer();
            transfer.setSourceWarehouseId(sourceWarehouseId);
            transfer.setDestinationWarehouseId(destinationWarehouseId);
            transfer.setDate(LocalDateTime.now());
            transfer.setStatus(status);
            transfer.setDescription(description);
            transfer.setCreatedBy(loggedInUser.getUserId());
            transfer.setImportRequestId(importRequestId);

            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");

            List<InventoryTransferItem> items = new ArrayList<>();

            if (productIds != null && quantities != null && productIds.length == quantities.length) {
                for (int i = 0; i < productIds.length; i++) {
                    if (productIds[i] != null && !productIds[i].trim().isEmpty()
                            && quantities[i] != null && !quantities[i].trim().isEmpty()) {

                        int productId = Integer.parseInt(productIds[i]);
                        int quantity = Integer.parseInt(quantities[i]);

                        if (quantity > 0) {
                            InventoryTransferItem item = new InventoryTransferItem();
                            item.setProductId(productId);
                            item.setQuantity(quantity);
                            items.add(item);
                        }
                    }
                }
            }

            if (items.isEmpty()) {
                request.setAttribute("errorMessage", "Please add at least one item to the transfer.");
                setupRequestAttributes(request, loggedInUser);
                request.getRequestDispatcher("/manager/inventory-transfer-create.jsp").forward(request, response);
                return;
            }

            InventoryTransferDAO transferDAO = new InventoryTransferDAO();
            boolean success = transferDAO.createInventoryTransferWithItems(transfer, items);

            if (success) {
                String successMessage = "draft".equals(status)
                        ? "Inventory transfer saved as draft successfully!"
                        : "Inventory transfer created successfully!";
                session.setAttribute("successMessage", successMessage);
                response.sendRedirect(request.getContextPath() + "/manager/list-inventory-transfer");
            } else {
                request.setAttribute("errorMessage", "Failed to create inventory transfer. Please try again.");
                setupRequestAttributes(request, loggedInUser);
                request.getRequestDispatcher("/manager/inventory-transfer-create.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void setupRequestAttributes(HttpServletRequest request, User loggedInUser) {
        try {
            WarehouseDAO warehouseDAO = new WarehouseDAO();
            List<WarehouseDisplay> warehouses = warehouseDAO.getAllWarehouses();
            request.setAttribute("warehouses", warehouses);

            // Get current user's warehouse information
            request.setAttribute("currentUserWarehouseId", loggedInUser.getWarehouseId());
            
            // Get current user's warehouse name
            String currentUserWarehouseName = "Unknown Warehouse";
            if (loggedInUser.getWarehouseId() != null) {
                for (WarehouseDisplay warehouse : warehouses) {
                    if (warehouse.getWarehouseId() == loggedInUser.getWarehouseId().intValue()) {
                        currentUserWarehouseName = warehouse.getWarehouseName();
                        break;
                    }
                }
            }
            request.setAttribute("currentUserWarehouseName", currentUserWarehouseName);

            ProductDAO productDAO = new ProductDAO();
            List<Product> products = productDAO.getAll();
            request.setAttribute("products", products);

            // Get all import requests for the dropdown
            ImportRequestDAO importRequestDAO = new ImportRequestDAO();
            List<ImportRequest> approvedImportRequests = importRequestDAO.getAllApprovedImportRequests();
            request.setAttribute("approvedImportRequests", approvedImportRequests);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public String getServletInfo() {
        return "Create Inventory Transfer Servlet";
    }
}
