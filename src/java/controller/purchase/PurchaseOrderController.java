package controller.purchase;

import dao.PurchaseOrderDAO;
import dao.PurchaseOrderItemDAO;
import dao.SupplierDAO;
import dao.ProductDAO;
import dao.WarehouseDAO;
import dao.RequestForQuotationDAO;
import dao.RfqItemDAO;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import model.Supplier;
import model.Product;
import model.Warehouse;
import model.RequestForQuotation;
import model.RfqItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;
import model.User;
import utils.AuthorizationService;
import utils.WarehouseAuthUtil;

@WebServlet(name = "PurchaseOrderController", urlPatterns = {"/purchase/purchase-order"})
public class PurchaseOrderController extends HttpServlet {

    private PurchaseOrderDAO purchaseOrderDAO = new PurchaseOrderDAO();
    private PurchaseOrderItemDAO purchaseOrderItemDAO = new PurchaseOrderItemDAO();
    private SupplierDAO supplierDAO = new SupplierDAO();
    private ProductDAO productDAO = new ProductDAO();
    private WarehouseDAO warehouseDAO = new WarehouseDAO();
    private RequestForQuotationDAO rfqDAO = new RequestForQuotationDAO();
    private RfqItemDAO rfqItemDAO = new RfqItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                handleListWithFilters(request, response);
                break;
            case "create":
                handleShowCreateForm(request, response);
                break;
            case "view":
                handleViewDetails(request, response);
                break;
            case "get-products":
                handleGetProductsBySupplier(request, response);
                break;
            case "get-rfq-details":
                handleGetRfqDetails(request, response);
                break;
            case "update-status":
                handleUpdateStatus(request, response);
                break;
            default:
                handleListWithFilters(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=list");
            return;
        }

        switch (action) {
            case "save":
                handleSavePurchaseOrder(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=list");
                break;
        }
    }

    private void handleListWithFilters(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get filter parameters
        String supplierFilterStr = request.getParameter("supplier");
        String statusFilter = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        Integer supplierFilter = null;
        if (supplierFilterStr != null && !supplierFilterStr.trim().isEmpty()) {
            try {
                supplierFilter = Integer.parseInt(supplierFilterStr);
            } catch (NumberFormatException e) {
                // Ignore invalid supplier ID
            }
        }

        // Get pagination parameters
        Integer page = 1;
        Integer pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Get purchase orders only for current user
        List<PurchaseOrder> purchaseOrders = purchaseOrderDAO.findPurchaseOrdersByUserWithFilters(
                currentUser.getUserId(), supplierFilter, statusFilter, startDate, endDate, page, pageSize);

        Integer totalOrders = purchaseOrderDAO.getTotalFilteredPurchaseOrdersByUser(
                currentUser.getUserId(), supplierFilter, statusFilter, startDate, endDate);
        Integer totalPages = (int) Math.ceil((double) totalOrders / pageSize);

        // Get all suppliers for filter dropdown
        List<Supplier> suppliers = supplierDAO.getAll();

        // Set attributes for JSP
        request.setAttribute("purchaseOrders", purchaseOrders);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);

        // Set filter values for maintaining state
        request.setAttribute("supplierFilter", supplierFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        request.getRequestDispatcher("/purchase/purchase-order-list.jsp").forward(request, response);
    }

    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get the default warehouse for the current user
        Integer defaultWarehouseId = WarehouseAuthUtil.getDefaultWarehouseId(currentUser);
        if (defaultWarehouseId == null) {
            setToastMessage(request, "No warehouse assigned to your account. Please contact administrator.", "error");
            response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=list");
            return;
        }
        
        // Get all suppliers, products and warehouses for dropdowns
        List<Supplier> suppliers = supplierDAO.getAll();
        List<Product> products = productDAO.getAll();
        List<Warehouse> warehouses = warehouseDAO.getAll();
        
        // Get available RFQs (Sent ones created by current user)
        List<RequestForQuotation> rfqs = rfqDAO.getAllByUserWithPagination(currentUser.getUserId(), 1, 100)
                .stream()
                .filter(rfq -> "Sent".equals(rfq.getStatus()))
                .collect(Collectors.toList());

        request.setAttribute("suppliers", suppliers);
        request.setAttribute("products", products);
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("rfqs", rfqs);
        request.setAttribute("defaultWarehouseId", defaultWarehouseId);
        request.setAttribute("isWarehouseLocked", true); // Lock warehouse for purchase staff

        request.getRequestDispatcher("/purchase/purchase-order-create.jsp").forward(request, response);
    }

    private void handleViewDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=list");
            return;
        }

        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Integer poId = Integer.parseInt(idStr);
            PurchaseOrder purchaseOrder = purchaseOrderDAO.getById(poId);

            if (purchaseOrder != null) {
                // Check if the Purchase Order belongs to the current user
                if (!purchaseOrder.getUserId().equals(currentUser.getUserId())) {
                    setToastMessage(request, "You don't have permission to view this Purchase Order!", "error");
                    response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=list");
                    return;
                }
                
                List<PurchaseOrderItem> items = purchaseOrderItemDAO.getByPurchaseOrderId(poId);

                request.setAttribute("purchaseOrder", purchaseOrder);
                request.setAttribute("purchaseOrderItems", items);
                request.getRequestDispatcher("/purchase/purchase-order-view.jsp").forward(request, response);
            } else {
                setToastMessage(request, "Purchase order not found!", "error");
                response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=list");
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid purchase order ID!", "error");
            response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=list");
        }
    }

    private void handleGetProductsBySupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String supplierIdStr = request.getParameter("supplierId");

        if (supplierIdStr == null || supplierIdStr.trim().isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("[]");
            return;
        }

        try {
            Integer supplierId = Integer.parseInt(supplierIdStr);
            List<Product> products = productDAO.getAll();

            // Create JSON response manually
            StringBuilder jsonProducts = new StringBuilder("[");
            for (int i = 0; i < products.size(); i++) {
                Product product = products.get(i);
                jsonProducts.append("{");
                jsonProducts.append("\"productId\":").append(product.getProductId()).append(",");
                jsonProducts.append("\"name\":\"").append(product.getName().replace("\"", "\\\"")).append("\",");
                jsonProducts.append("\"code\":\"").append(product.getCode().replace("\"", "\\\"")).append("\",");
                jsonProducts.append("\"price\":").append(product.getPrice() != null ? product.getPrice() : 0);
                jsonProducts.append("}");
                if (i < products.size() - 1) {
                    jsonProducts.append(",");
                }
            }
            jsonProducts.append("]");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonProducts.toString());
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.getWriter().write("[]");
        }
    }

    private void handleGetRfqDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String rfqIdParam = request.getParameter("rfqId");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (rfqIdParam == null || rfqIdParam.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"RFQ ID is required\"}");
            return;
        }

        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Please login first\"}");
            return;
        }

        try {
            Integer rfqId = Integer.parseInt(rfqIdParam);
            RequestForQuotation rfq = rfqDAO.getById(rfqId);
            
            if (rfq == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"RFQ not found\"}");
                return;
            }
            
            // Check if the RFQ belongs to the current user
            if (!rfq.getCreatedBy().equals(currentUser.getUserId())) {
                response.getWriter().write("{\"success\": false, \"message\": \"You don't have permission to access this RFQ\"}");
                return;
            }
            
            // Get RFQ items
            List<RfqItem> rfqItems = rfqItemDAO.getByRfqId(rfqId);
            
            if (rfqItems == null || rfqItems.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"No items found for this RFQ\"}");
                return;
            }
            
            // Build JSON response manually
            StringBuilder jsonResponse = new StringBuilder();
            jsonResponse.append("{\"success\": true, \"rfq\": {");
            jsonResponse.append("\"rfqId\": ").append(rfq.getRfqId()).append(",");
            jsonResponse.append("\"supplierId\": ").append(rfq.getSupplierId()).append(",");
            jsonResponse.append("\"supplierName\": \"").append(escapeJson(rfq.getSupplierName())).append("\",");
            jsonResponse.append("\"warehouseId\": ").append(rfq.getWarehouseId()).append(",");
            jsonResponse.append("\"expectedDeliveryDate\": \"").append(rfq.getExpectedDeliveryDate() != null ? rfq.getExpectedDeliveryDate().toString() : "").append("\"");
            jsonResponse.append("}, \"items\": [");
            
            for (int i = 0; i < rfqItems.size(); i++) {
                RfqItem item = rfqItems.get(i);
                if (i > 0) {
                    jsonResponse.append(",");
                }
                jsonResponse.append("{");
                jsonResponse.append("\"productId\": ").append(item.getProductId()).append(",");
                jsonResponse.append("\"quantity\": ").append(item.getQuantity()).append(",");
                jsonResponse.append("\"productName\": \"").append(escapeJson(item.getProductName())).append("\",");
                jsonResponse.append("\"productCode\": \"").append(escapeJson(item.getProductCode())).append("\"");
                jsonResponse.append("}");
            }
            
            jsonResponse.append("]}");
            
            response.getWriter().write(jsonResponse.toString());
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid RFQ ID format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"An error occurred: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    private void handleSavePurchaseOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Integer userId = (user != null) ? user.getUserId() : null;

        if (userId == null) {
            setToastMessage(request, "Please login to create purchase orders!", "error");
            response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=list");
            return;
        }

        // Get form parameters
        String supplierIdStr = request.getParameter("supplierId");
        String warehouseIdStr = request.getParameter("warehouseId");
        String status = request.getParameter("status");
        String expectedDeliveryDateStr = request.getParameter("expectedDeliveryDate");
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String[] unitPrices = request.getParameterValues("unitPrice");

        // Validate basic parameters
        if (supplierIdStr == null || supplierIdStr.trim().isEmpty()) {
            setToastMessage(request, "Please select a supplier!", "error");
            response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=create");
            return;
        }

        if (warehouseIdStr == null || warehouseIdStr.trim().isEmpty()) {
            setToastMessage(request, "Please select a delivery warehouse!", "error");
            response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=create");
            return;
        }

        if (expectedDeliveryDateStr == null || expectedDeliveryDateStr.trim().isEmpty()) {
            setToastMessage(request, "Expected delivery date is required!", "error");
            response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=create");
            return;
        }

        if (productIds == null || productIds.length == 0) {
            setToastMessage(request, "Please add at least one product!", "error");
            response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=create");
            return;
        }

        try {
            Integer supplierId = Integer.parseInt(supplierIdStr);
            Integer warehouseId = Integer.parseInt(warehouseIdStr);

            // Parse expected delivery date
            java.sql.Date expectedDeliveryDate = null;
            try {
                expectedDeliveryDate = java.sql.Date.valueOf(expectedDeliveryDateStr);

                // Validate that expected delivery date is not in the past
                java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
                if (expectedDeliveryDate.before(today)) {
                    setToastMessage(request, "Expected delivery date cannot be in the past!", "error");
                    response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=create");
                    return;
                }
            } catch (IllegalArgumentException e) {
                setToastMessage(request, "Invalid expected delivery date!", "error");
                response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=create");
                return;
            }

            // Create purchase order
            PurchaseOrder purchaseOrder = new PurchaseOrder();
            purchaseOrder.setSupplierId(supplierId);
            purchaseOrder.setUserId(userId);
            purchaseOrder.setWarehouseId(warehouseId);
            purchaseOrder.setStatus(status != null ? status : "Pending");
            purchaseOrder.setExpectedDeliveryDate(expectedDeliveryDate);

            Integer poId = purchaseOrderDAO.insert(purchaseOrder);

            if (poId > 0) {
                // Create purchase order items
                boolean allItemsCreated = true;

                for (int i = 0; i < productIds.length; i++) {
                    if (productIds[i] != null && !productIds[i].trim().isEmpty()
                            && quantities[i] != null && !quantities[i].trim().isEmpty()
                            && unitPrices[i] != null && !unitPrices[i].trim().isEmpty()) {

                        try {
                            Integer productId = Integer.parseInt(productIds[i]);
                            Integer quantity = Integer.parseInt(quantities[i]);
                            BigDecimal unitPrice = new BigDecimal(unitPrices[i]);

                            PurchaseOrderItem item = new PurchaseOrderItem();
                            item.setPoId(poId);
                            item.setProductId(productId);
                            item.setQuantity(quantity);
                            item.setUnitPrice(unitPrice);

                            Integer itemId = purchaseOrderItemDAO.insert(item);
                            if (itemId <= 0) {
                                allItemsCreated = false;
                                break;
                            }
                        } catch (NumberFormatException e) {
                            allItemsCreated = false;
                            break;
                        }
                    }
                }

                if (allItemsCreated) {
                    setToastMessage(request, "Purchase order created successfully!", "success");
                    response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=view&id=" + poId);
                } else {
                    setToastMessage(request, "Some items could not be added to the purchase order!", "warning");
                    response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=view&id=" + poId);
                }
            } else {
                setToastMessage(request, "Failed to create purchase order!", "error");
                response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=create");
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid input data!", "error");
            response.sendRedirect(request.getContextPath() + "/purchase/purchase-order?action=create");
        }
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String newStatus = request.getParameter("newStatus");

        if (idStr == null || idStr.trim().isEmpty() || newStatus == null || newStatus.trim().isEmpty()) {
            setToastMessage(request, "Invalid parameters!", "error");
            response.sendRedirect(buildFilterUrl(request, request.getContextPath() + "/purchase/purchase-order?action=list"));
            return;
        }

        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Integer poId = Integer.parseInt(idStr);
            
            // Check if the Purchase Order belongs to the current user
            PurchaseOrder purchaseOrder = purchaseOrderDAO.getById(poId);
            if (purchaseOrder == null) {
                setToastMessage(request, "Purchase order not found!", "error");
                response.sendRedirect(buildFilterUrl(request, request.getContextPath() + "/purchase/purchase-order?action=list"));
                return;
            }
            
            if (!purchaseOrder.getUserId().equals(currentUser.getUserId())) {
                setToastMessage(request, "You don't have permission to update this Purchase Order!", "error");
                response.sendRedirect(buildFilterUrl(request, request.getContextPath() + "/purchase/purchase-order?action=list"));
                return;
            }
            
            Boolean success = purchaseOrderDAO.updateStatus(poId, newStatus);

            if (success) {
                setToastMessage(request, "Purchase order status updated successfully!", "success");
            } else {
                setToastMessage(request, "Failed to update status!", "error");
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid purchase order ID!", "error");
        }

        // Redirect back to list page with current filters
        response.sendRedirect(buildFilterUrl(request, request.getContextPath() + "/purchase/purchase-order?action=list"));
    }

    private String buildFilterUrl(HttpServletRequest request, String baseUrl) {
        StringBuilder url = new StringBuilder(baseUrl);

        String supplier = request.getParameter("supplier");
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String page = request.getParameter("page");

        // Don't include newStatus parameter in filter URL as it's for updating, not filtering
        boolean hasParams = baseUrl.contains("?");

        if (supplier != null && !supplier.trim().isEmpty()) {
            url.append(hasParams ? "&" : "?").append("supplier=").append(supplier);
            hasParams = true;
        }
        if (status != null && !status.trim().isEmpty()) {
            url.append(hasParams ? "&" : "?").append("status=").append(status);
            hasParams = true;
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            url.append(hasParams ? "&" : "?").append("startDate=").append(startDate);
            hasParams = true;
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            url.append(hasParams ? "&" : "?").append("endDate=").append(endDate);
            hasParams = true;
        }
        if (page != null && !page.trim().isEmpty()) {
            url.append(hasParams ? "&" : "?").append("page=").append(page);
            hasParams = true;
        }

        return url.toString();
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", message);
        session.setAttribute("toastType", type);
    }

    @Override
    public String getServletInfo() {
        return "PurchaseOrderController manages purchase order operations including create, list, and history";
    }
}
