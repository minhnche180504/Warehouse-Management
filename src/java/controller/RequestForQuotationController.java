package controller;

import dao.RequestForQuotationDAO;
import dao.RfqItemDAO;
import dao.SupplierDAO;
import dao.ProductDAO;
import dao.WarehouseDAO;
import dao.ImportRequestDAO;
import dao.PurchaseRequestDAO;
import model.RequestForQuotation;
import model.RfqItem;
import model.Supplier;
import model.Product;
import model.User;
import model.Warehouse;
import model.ImportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.stream.Collectors;
import utils.AuthorizationService;
import utils.WarehouseAuthUtil;
import model.ImportRequestDetail;
import model.PurchaseRequest;
import model.PurchaseRequestItem;

@WebServlet(name = "RequestForQuotationController", urlPatterns = {"/purchase/rfq"})
public class RequestForQuotationController extends HttpServlet {

    private RequestForQuotationDAO rfqDAO = new RequestForQuotationDAO();
    private RfqItemDAO rfqItemDAO = new RfqItemDAO();
    private SupplierDAO supplierDAO = new SupplierDAO();
    private ProductDAO productDAO = new ProductDAO();
    private WarehouseDAO warehouseDAO = new WarehouseDAO();
    private ImportRequestDAO importRequestDAO = new ImportRequestDAO();
    private PurchaseRequestDAO purchaseRequestDAO = new PurchaseRequestDAO();

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
                handleListWithPagination(request, response);
                break;
            case "create":
                handleShowCreateForm(request, response);
                break;
            case "view":
                handleViewDetails(request, response);
                break;
            case "get-supplier-info":
                handleGetSupplierInfo(request, response);
                break;
            case "get-products":
                handleGetProductsBySupplier(request, response);
                break;
            case "get-import-request-details":
                handleGetImportRequestDetails(request, response);
                break;
            case "get-purchase-request-details":
                handleGetPurchaseRequestDetails(request, response);
                break;
            case "update-status":
                handleUpdateStatus(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            default:
                handleListWithPagination(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("rfq?action=list");
            return;
        }
        
        switch (action) {
            case "save":
                handleSaveRfq(request, response);
                break;
            default:
                response.sendRedirect("rfq?action=list");
                break;
        }
    }

    private void handleListWithPagination(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get pagination parameters
        Integer page = 1;
        Integer pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Get RFQs only for current user
        List<RequestForQuotation> rfqList = rfqDAO.getAllByUserWithPagination(currentUser.getUserId(), page, pageSize);
        Integer totalRfqs = rfqDAO.getTotalCountByUser(currentUser.getUserId());
        Integer totalPages = (int) Math.ceil((double) totalRfqs / pageSize);

        // Set attributes for JSP
        request.setAttribute("rfqList", rfqList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRfqs", totalRfqs);

        request.getRequestDispatcher("/purchase/rfq-list.jsp").forward(request, response);
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
            response.sendRedirect(request.getContextPath() + "/purchase/rfq?action=list");
            return;
        }
        
        // Get all suppliers for dropdown
        List<Supplier> suppliers = supplierDAO.getAll();
        
        // Get all warehouses for dropdown
        List<Warehouse> warehouses = warehouseDAO.getAll();
        
        // Get available import requests (only Pending ones)
        List<ImportRequest> importRequests = importRequestDAO.getByOrderType("Purchase Order");

        // Get available purchase requests (Pending and Purchasing ones)
        List<PurchaseRequest> purchaseRequests = purchaseRequestDAO.getAllPurchaseRequests()
                .stream()
                .filter(pr -> "Pending".equals(pr.getStatus()) || "Purchasing".equals(pr.getStatus()))
                .collect(Collectors.toList());

        // Format reason field as "prNumber / reason / preferredDeliveryDate" with fallback if reason is empty, exclude status and avoid duplicate date
        purchaseRequests.forEach(pr -> {
            String reasonPart = (pr.getReason() != null && !pr.getReason().trim().isEmpty()) ? pr.getReason() : pr.getPreferredDeliveryDate() != null ? pr.getPreferredDeliveryDate().toString() : "";
            String formattedReason = pr.getPrNumber() + " / " + reasonPart;
            if (pr.getPreferredDeliveryDate() != null && (pr.getReason() != null && !pr.getReason().trim().isEmpty()) && !reasonPart.contains(pr.getPreferredDeliveryDate().toString())) {
                formattedReason += " / Ngày nhận hàng: " + pr.getPreferredDeliveryDate().toString();
            }
            pr.setReason(formattedReason);
            // Remove status to avoid showing in dropdown
            pr.setStatus(null);
        });
        
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("importRequests", importRequests);
        request.setAttribute("purchaseRequests", purchaseRequests);
        request.setAttribute("defaultWarehouseId", defaultWarehouseId);
        request.setAttribute("isWarehouseLocked", true); // Lock warehouse for purchase staff
        request.getRequestDispatcher("/purchase/rfq-create.jsp").forward(request, response);
    }

    private void handleViewDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
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
            Integer rfqId = Integer.parseInt(idStr);
            RequestForQuotation rfq = rfqDAO.getById(rfqId);
            
            if (rfq != null) {
                // Check if the RFQ belongs to the current user
                if (!rfq.getCreatedBy().equals(currentUser.getUserId())) {
                    setToastMessage(request, "You don't have permission to view this Request for Quotation!", "error");
                    response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
                    return;
                }
                
                List<RfqItem> items = rfqItemDAO.getByRfqId(rfqId);
                
                request.setAttribute("rfq", rfq);
                request.setAttribute("rfqItems", items);
                request.getRequestDispatcher("/purchase/rfq-view.jsp").forward(request, response);
            } else {
                setToastMessage(request, "Request for Quotation not found!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid RFQ ID!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
        }
    }

    private void handleGetSupplierInfo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String supplierIdStr = request.getParameter("supplierId");
        
        if (supplierIdStr == null || supplierIdStr.trim().isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("{}");
            return;
        }

        try {
            Integer supplierId = Integer.parseInt(supplierIdStr);
            Supplier supplier = supplierDAO.getById(supplierId);
            
            response.setContentType("application/json");
            if (supplier != null) {
                StringBuilder json = new StringBuilder("{");
                json.append("\"email\":\"").append(supplier.getEmail() != null ? supplier.getEmail() : "").append("\",");
                json.append("\"phone\":\"").append(supplier.getPhone() != null ? supplier.getPhone() : "").append("\"");
                json.append("}");
                response.getWriter().write(json.toString());
            } else {
                response.getWriter().write("{}");
            }
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.getWriter().write("{}");
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
                jsonProducts.append("\"unitName\":\"").append(product.getUnitName() != null ? product.getUnitName().replace("\"", "\\\"") : "").append("\"");
                jsonProducts.append("}");
                
                if (i < products.size() - 1) {
                    jsonProducts.append(",");
                }
            }
            jsonProducts.append("]");
            
            response.setContentType("application/json");
            response.getWriter().write(jsonProducts.toString());
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.getWriter().write("[]");
        }
    }

    private void handleGetImportRequestDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestIdParam = request.getParameter("requestId");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Request ID is required\"}");
            return;
        }

        try {
            Integer requestId = Integer.parseInt(requestIdParam);
            System.out.println("DEBUG: Getting import request details for ID: " + requestId);
            
            ImportRequest importRequest = importRequestDAO.getById(requestId);
            
            if (importRequest == null) {
                System.out.println("DEBUG: Import request not found for ID: " + requestId);
                response.getWriter().write("{\"success\": false, \"message\": \"Import request not found\"}");
                return;
            }
            
            // Get the details for this import request
            List<ImportRequestDetail> details = importRequest.getDetails();
            System.out.println("DEBUG: Found " + (details != null ? details.size() : 0) + " details for import request");
            
            if (details == null || details.isEmpty()) {
                System.out.println("DEBUG: No details found for import request ID: " + requestId);
                response.getWriter().write("{\"success\": false, \"message\": \"No details found for this import request\"}");
                return;
            }
            
            // Build JSON response manually
            StringBuilder jsonResponse = new StringBuilder();
            jsonResponse.append("{\"success\": true, \"details\": [");
            
            for (int i = 0; i < details.size(); i++) {
                ImportRequestDetail detail = details.get(i);
                Product product = productDAO.getById(detail.getProductId());
                String unitName = product != null ? product.getUnitName() : "";
                System.out.println("DEBUG: Processing detail " + i + " - ProductID: " + detail.getProductId() + 
                                 ", ProductName: " + detail.getProductName() + 
                                 ", ProductCode: " + detail.getProductCode() + 
                                 ", Quantity: " + detail.getQuantity() +
                                 ", UnitName: " + unitName);
                if (i > 0) {
                    jsonResponse.append(",");
                }
                jsonResponse.append("{");
                jsonResponse.append("\"productId\": ").append(detail.getProductId()).append(",");
                jsonResponse.append("\"quantity\": ").append(detail.getQuantity()).append(",");
                jsonResponse.append("\"productName\": \"").append(escapeJson(detail.getProductName())).append("\",");
                jsonResponse.append("\"productCode\": \"").append(escapeJson(detail.getProductCode())).append("\",");
                jsonResponse.append("\"unitName\": \"").append(escapeJson(unitName)).append("\"");
                jsonResponse.append("}");
            }
            
            jsonResponse.append("]}");
            System.out.println("DEBUG: Final JSON response: " + jsonResponse.toString());
            
            response.getWriter().write(jsonResponse.toString());
        } catch (NumberFormatException e) {
            System.out.println("DEBUG: Invalid request ID format: " + requestIdParam);
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid request ID format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"An error occurred: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private void handleGetPurchaseRequestDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestIdParam = request.getParameter("purchaseRequestId");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Purchase Request ID is required\"}");
            return;
        }

        try {
            Integer purchaseRequestId = Integer.parseInt(requestIdParam);
            System.out.println("DEBUG: Getting purchase request details for ID: " + purchaseRequestId);
            
            PurchaseRequest purchaseRequest = purchaseRequestDAO.getPurchaseRequestById(purchaseRequestId);
            
            if (purchaseRequest == null) {
                System.out.println("DEBUG: Purchase request not found for ID: " + purchaseRequestId);
                response.getWriter().write("{\"success\": false, \"message\": \"Purchase request not found\"}");
                return;
            }
            
            // Get the details for this purchase request
            List<PurchaseRequestItem> details = purchaseRequest.getItems();
            System.out.println("DEBUG: Found " + (details != null ? details.size() : 0) + " details for purchase request");
            
            if (details == null || details.isEmpty()) {
                System.out.println("DEBUG: No details found for purchase request ID: " + purchaseRequestId);
                response.getWriter().write("{\"success\": false, \"message\": \"No details found for this purchase request\"}");
                return;
            }
            
            // Build JSON response manually
            StringBuilder jsonResponse = new StringBuilder();
            jsonResponse.append("{\"success\": true, \"details\": [");
            
            for (int i = 0; i < details.size(); i++) {
                PurchaseRequestItem detail = details.get(i);
                Product product = productDAO.getById(detail.getProductId());
                String unitName = product != null ? product.getUnitName() : "";
                System.out.println("DEBUG: Processing detail " + i + " - ProductID: " + detail.getProductId() + 
                                 ", ProductName: " + detail.getProductName() + 
                                 ", ProductCode: " + detail.getProductCode() + 
                                 ", Quantity: " + detail.getQuantity() +
                                 ", UnitName: " + unitName);
                if (i > 0) {
                    jsonResponse.append(",");
                }
                jsonResponse.append("{");
                jsonResponse.append("\"productId\": ").append(detail.getProductId()).append(",");
                jsonResponse.append("\"quantity\": ").append(detail.getQuantity()).append(",");
                jsonResponse.append("\"productName\": \"").append(escapeJson(detail.getProductName())).append("\",");
                jsonResponse.append("\"productCode\": \"").append(escapeJson(detail.getProductCode())).append("\",");
                jsonResponse.append("\"unitName\": \"").append(escapeJson(unitName)).append("\"");
                jsonResponse.append("}");
            }
            
            jsonResponse.append("]}");
            System.out.println("DEBUG: Final JSON response: " + jsonResponse.toString());
            
            response.getWriter().write(jsonResponse.toString());
        } catch (NumberFormatException e) {
            System.out.println("DEBUG: Invalid purchase request ID format: " + requestIdParam);
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid purchase request ID format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"An error occurred: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    private void handleSaveRfq(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Get form data
            Integer supplierId = Integer.parseInt(request.getParameter("supplierId"));
            String description = request.getParameter("description");
            String notes = request.getParameter("notes");
            Integer warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
            String expectedDeliveryDate = request.getParameter("expectedDeliveryDate");
            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");
            String purchaseRequestIdStr = request.getParameter("purchaseRequestId");

            // Validate required fields
            if (supplierId == null || warehouseId == null || productIds == null || quantities == null || 
                productIds.length == 0 || quantities.length == 0 || 
                productIds.length != quantities.length) {
                setToastMessage(request, "Please provide valid supplier, warehouse and at least one product with quantity!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=create");
                return;
            }

            // Create RFQ
            RequestForQuotation rfq = new RequestForQuotation();
            rfq.setCreatedBy(currentUser.getUserId());
            rfq.setSupplierId(supplierId);
            rfq.setDescription(description);
            rfq.setNotes(notes);
            rfq.setWarehouseId(warehouseId);
            if (expectedDeliveryDate != null && !expectedDeliveryDate.trim().isEmpty()) {
                rfq.setExpectedDeliveryDate(Date.valueOf(expectedDeliveryDate));
            }
            rfq.setStatus("Pending");
            rfq.setRequestDate(new Date(System.currentTimeMillis()));

            Integer rfqId = rfqDAO.insert(rfq);

            if (rfqId > 0) {
                // Save RFQ items
                for (int i = 0; i < productIds.length; i++) {
                    try {
                        Integer productId = Integer.parseInt(productIds[i]);
                        Integer quantity = Integer.parseInt(quantities[i]);

                        if (quantity > 0) {
                            RfqItem rfqItem = new RfqItem();
                            rfqItem.setRfqId(rfqId);
                            rfqItem.setProductId(productId);
                            rfqItem.setQuantity(quantity);

                            rfqItemDAO.insert(rfqItem);
                        }
                    } catch (NumberFormatException e) {
                        // Skip invalid items
                        continue;
                    }
                }
                
                // Update purchase request status to "purchase" if purchaseRequestId is provided
                if (purchaseRequestIdStr != null && !purchaseRequestIdStr.trim().isEmpty()) {
                    try {
                        Integer purchaseRequestId = Integer.parseInt(purchaseRequestIdStr);
                        PurchaseRequest purchaseRequest = purchaseRequestDAO.getPurchaseRequestById(purchaseRequestId);
                if (purchaseRequest != null) {
                    purchaseRequest.setStatus("Purchasing");
                    purchaseRequest.setConfirmBy(currentUser.getUserId());
                    purchaseRequestDAO.updatePurchaseRequest(purchaseRequest);
                }
                    } catch (NumberFormatException e) {
                        // Ignore invalid purchaseRequestId
                    }
                }

                setToastMessage(request, "The request for quotation has been created successfully!", "success");
                response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
            } else {
                setToastMessage(request, "Could not create the request for quotation!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=create");
            }

        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid data!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=create");
        } catch (Exception e) {
            setToastMessage(request, "An error occurred: " + e.getMessage(), "error");
            response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=create");
        }
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");

        if (idStr == null || status == null) {
            setToastMessage(request, "Invalid parameters!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
            return;
        }

        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Validate status - only allow Pending and Sent
        if (!status.equals("Pending") && !status.equals("Sent")) {
            setToastMessage(request, "Invalid status! Only 'Pending' and 'Sent' are allowed.", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
            return;
        }

        try {
            Integer rfqId = Integer.parseInt(idStr);
            
            // Check if the RFQ belongs to the current user
            RequestForQuotation rfq = rfqDAO.getById(rfqId);
            if (rfq == null) {
                setToastMessage(request, "Request for quotation not found!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
                return;
            }
            
            if (!rfq.getCreatedBy().equals(currentUser.getUserId())) {
                setToastMessage(request, "You don't have permission to update this Request for Quotation!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
                return;
            }
            
            boolean success = rfqDAO.updateStatus(rfqId, status);

            if (success) {
                setToastMessage(request, "Status updated successfully!", "success");
            } else {
                setToastMessage(request, "Could not update status!", "error");
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid RFQ ID!", "error");
        }

        response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");

        if (idStr == null) {
            setToastMessage(request, "Invalid RFQ ID!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
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
            Integer rfqId = Integer.parseInt(idStr);
            
            // Check RFQ status before deleting
            RequestForQuotation rfq = rfqDAO.getById(rfqId);
            if (rfq == null) {
                setToastMessage(request, "Request for quotation not found!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
                return;
            }
            
            // Check if the RFQ belongs to the current user
            if (!rfq.getCreatedBy().equals(currentUser.getUserId())) {
                setToastMessage(request, "You don't have permission to delete this Request for Quotation!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
                return;
            }
            
            // Only allow deletion if status is "Pending"
            if (!"Pending".equals(rfq.getStatus())) {
                setToastMessage(request, "Cannot delete a request for quotation that has already been sent!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
                return;
            }
            
            boolean success = rfqDAO.delete(rfqId);

            if (success) {
                setToastMessage(request, "The request for quotation has been deleted successfully!", "success");
            } else {
                setToastMessage(request, "Could not delete the request for quotation!", "error");
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid RFQ ID!", "error");
        }

        response.sendRedirect(request.getContextPath()+"/purchase/rfq?action=list");
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", message);
        session.setAttribute("toastType", type);
    }

    @Override
    public String getServletInfo() {
        return "Request for Quotation Controller";
    }
} 