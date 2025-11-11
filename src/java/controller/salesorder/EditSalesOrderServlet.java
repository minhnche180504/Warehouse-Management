package controller.salesorder;

import dao.AuthorizationUtil;
import dao.SalesOrderDAO;
import dao.SalesOrderItemDAO;
import dao.CustomerDAO;
import dao.WarehouseDAO;
import dao.InventoryDAO;
import model.SalesOrder;
import model.SalesOrderItem;
import model.Customer;
import model.WarehouseDisplay;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import utils.AuthorizationService;
import utils.WarehouseAuthUtil;

@WebServlet("/sale/edit-sales-order")
public class EditSalesOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Kiểm tra quyền: Admin hoặc Sales Staff
        if (!AuthorizationUtil.canManageSales(currentUser)) {
            session.setAttribute("error", "You don't have permission to edit sales orders.");
            response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
            return;
        }

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                session.setAttribute("error", "Sales order ID is required.");
                response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
                return;
            }

            int soId = Integer.parseInt(idParam);
            
            // WAREHOUSE FILTERING: Lấy thông tin sales order với warehouse check
            SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
            SalesOrder salesOrder = salesOrderDAO.getSalesOrderById(soId, currentUser);
            
            if (salesOrder == null) {
                session.setAttribute("error", "Sales order not found or you don't have permission to access it.");
                response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
                return;
            }

            // FIXED: Kiểm tra trạng thái order có thể edit không - chỉ cho phép edit "Order"
            if (!"Order".equals(salesOrder.getStatus())) {
                session.setAttribute("error", "Cannot edit this order. Only orders with 'Order' status can be edited. Current status: " + salesOrder.getStatus());
                response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-detail?id=" + soId);
                return;
            }

            // Load customers
            CustomerDAO customerDAO = new CustomerDAO();
            List<Customer> customers = customerDAO.getAllCustomers();
            request.setAttribute("customers", customers);

            // WAREHOUSE FILTERING: Load warehouses theo quyền user
            WarehouseDAO warehouseDAO = new WarehouseDAO();
            List<WarehouseDisplay> allWarehouses = warehouseDAO.getAllWarehouses();
            List<WarehouseDisplay> allowedWarehouses = WarehouseAuthUtil.filterAllowedWarehouses(currentUser, allWarehouses);
            
            request.setAttribute("warehouses", allowedWarehouses);

            // Load order items
            SalesOrderItemDAO itemDAO = new SalesOrderItemDAO();
            List<SalesOrderItem> items = itemDAO.getSalesOrderItemsBySoId(soId);
            salesOrder.setItems(items);

            request.setAttribute("salesOrder", salesOrder);
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/sale/sale-order-edit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid sales order ID format.");
            response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error loading edit form: " + e.getMessage());
            response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Kiểm tra quyền
        if (!AuthorizationUtil.canManageSales(currentUser)) {
            session.setAttribute("error", "You don't have permission to edit sales orders.");
            response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
            return;
        }

        try {
            // ★ FIX CHÍNH: Thử lấy cả 2 parameter 'soId' và 'id'
            String soIdParam = request.getParameter("soId"); // Từ form hidden field
            String idParam = request.getParameter("id");     // Từ URL parameter
            
            // Sử dụng soId từ form nếu có, nếu không thì dùng id từ URL
            String finalIdParam = (soIdParam != null && !soIdParam.trim().isEmpty()) ? soIdParam : idParam;
            
            System.out.println("DEBUG: soIdParam from form = '" + soIdParam + "'");
            System.out.println("DEBUG: idParam from URL = '" + idParam + "'");
            System.out.println("DEBUG: finalIdParam selected = '" + finalIdParam + "'");
            
            if (finalIdParam == null || finalIdParam.trim().isEmpty()) {
                session.setAttribute("error", "Sales order ID is missing. Both form data and URL parameter are empty.");
                response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
                return;
            }
            
            int soId;
            try {
                soId = Integer.parseInt(finalIdParam.trim());
                if (soId <= 0) {
                    throw new NumberFormatException("Invalid order ID: " + soId);
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid ID format: " + finalIdParam);
                session.setAttribute("error", "Invalid sales order ID format: " + finalIdParam);
                response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
                return;
            }
            
            System.out.println("DEBUG: Processing edit for soId = " + soId); // Debug log
            
            // WAREHOUSE FILTERING: Lấy thông tin order để kiểm tra lại trạng thái và quyền
            SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
            SalesOrder existingOrder = salesOrderDAO.getSalesOrderById(soId, currentUser);
            
            if (existingOrder == null) {
                session.setAttribute("error", "Sales order not found or you don't have permission to access it.");
                response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
                return;
            }

            // FIXED: Check for Order status instead of Pending
            if (!"Order".equals(existingOrder.getStatus())) {
                session.setAttribute("error", "Cannot edit this order. Only orders with 'Order' status can be edited. Current status: " + existingOrder.getStatus());
                response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-detail?id=" + soId);
                return;
            }

            // Lấy thông tin từ form
            String customerIdStr = request.getParameter("customerId");
            String warehouseIdStr = request.getParameter("warehouseId");
            String orderDateStr = request.getParameter("orderDate");
            String notes = request.getParameter("notes");
            String deliveryAddress = request.getParameter("deliveryAddress");
            String deliveryDateStr = request.getParameter("deliveryDate");
            
            // Validation cơ bản
            if (customerIdStr == null || warehouseIdStr == null || 
                customerIdStr.trim().isEmpty() || warehouseIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Please select both customer and warehouse.");
                doGet(request, response);
                return;
            }
            
            int customerId = Integer.parseInt(customerIdStr);
            int warehouseId = Integer.parseInt(warehouseIdStr);
            
            // WAREHOUSE ACCESS VALIDATION
            if (!WarehouseAuthUtil.canAccessWarehouse(currentUser, warehouseId)) {
                request.setAttribute("error", "You don't have permission to assign orders to this warehouse.");
                doGet(request, response);
                return;
            }
            
            // Lấy thông tin products được chọn - UPDATED WITH SELLING PRICE
            List<SalesOrderItem> orderItems = new ArrayList<>();
            BigDecimal totalAmount = BigDecimal.ZERO;
            
            // Parse products from request parameters
            String productCountStr = request.getParameter("productCount");
            
            // Nếu không có sản phẩm mới được chọn, giữ nguyên sản phẩm cũ
            if (productCountStr == null || productCountStr.trim().isEmpty() || "0".equals(productCountStr.trim())) {
                // Sử dụng sản phẩm hiện tại
                SalesOrderItemDAO itemDAO = new SalesOrderItemDAO();
                orderItems = itemDAO.getSalesOrderItemsBySoId(soId);
                
                for (SalesOrderItem item : orderItems) {
                    totalAmount = totalAmount.add(item.getTotalPrice());
                }
            } else {
                // Có sản phẩm mới được chọn - UPDATED: Handle selling price
                int productCount = Integer.parseInt(productCountStr.trim());
                
                for (int i = 0; i < productCount; i++) {
                    String productIdParam = request.getParameter("productId_" + i);
                    String quantityParam = request.getParameter("quantity_" + i);
                    String sellingPriceParam = request.getParameter("sellingPrice_" + i); // NEW: Selling price
                    
                    if (productIdParam != null && quantityParam != null && 
                        !productIdParam.trim().isEmpty() && !quantityParam.trim().isEmpty()) {
                        
                        int productId = Integer.parseInt(productIdParam.trim());
                        int quantity = Integer.parseInt(quantityParam.trim());
                        
                        // Kiểm tra tồn kho
                        InventoryDAO inventoryDAO = new InventoryDAO();
                        if (!inventoryDAO.checkStock(productId, warehouseId, quantity)) {
                            request.setAttribute("error", "Insufficient stock for product ID: " + productId + ". Please check inventory.");
                            doGet(request, response);
                            return;
                        }
                        
                        // Get product cost price
                        BigDecimal unitPrice = getProductPrice(productId);
                        
                        if (unitPrice.compareTo(BigDecimal.ZERO) <= 0) {
                            request.setAttribute("error", "Invalid price for product ID: " + productId);
                            doGet(request, response);
                            return;
                        }
                        
                        // UPDATED: Xử lý selling price giống như CreateSalesOrderServlet
                        BigDecimal sellingPrice = unitPrice; // Mặc định bằng unit price
                        if (sellingPriceParam != null && !sellingPriceParam.trim().isEmpty()) {
                            try {
                                sellingPrice = new BigDecimal(sellingPriceParam.trim());
                                // Kiểm tra selling price hợp lệ
                                if (sellingPrice.compareTo(BigDecimal.ZERO) < 0) {
                                    sellingPrice = unitPrice; // Không cho phép giá âm
                                }
                            } catch (NumberFormatException e) {
                                System.out.println("Invalid selling price format, using unit price");
                                sellingPrice = unitPrice;
                            }
                        }
                        
                        SalesOrderItem item = new SalesOrderItem();
                        item.setProductId(productId);
                        item.setQuantity(quantity);
                        item.setUnitPrice(unitPrice); // Giá gốc
                        item.setSellingPrice(sellingPrice); // Giá bán
                        item.calculateTotalPrice(); // Tính theo selling price
                        
                        orderItems.add(item);
                        totalAmount = totalAmount.add(item.getTotalPrice());
                    }
                }
            }
            
            // Kiểm tra có sản phẩm không
            if (orderItems.isEmpty()) {
                request.setAttribute("error", "Order must have at least one product.");
                doGet(request, response);
                return;
            }
            
            // Lấy thông tin customer để có địa chỉ mặc định
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerById(customerId);
            
            // Cập nhật Sales Order object
            SalesOrder salesOrder = new SalesOrder();
            salesOrder.setSoId(soId);
            salesOrder.setCustomerId(customerId);
            salesOrder.setUserId(currentUser.getUserId());
            salesOrder.setWarehouseId(warehouseId);
            
            // ★ FIX CHÍNH: Xử lý order date - GIỮ NGUYÊN GIỜ PHÚT GIÂY CỦA ORDER GỐC
            Date orderDate = existingOrder.getOrderDate(); // Mặc định giữ nguyên thời gian gốc
            
            // Nếu người dùng thay đổi ngày thì chỉ thay đổi ngày, giữ nguyên giờ phút giây gốc
            if (orderDateStr != null && !orderDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    Date inputDate = inputDateFormat.parse(orderDateStr);
                    
                    // Tạo Calendar để kết hợp ngày từ input và thời gian từ order gốc
                    java.util.Calendar inputCal = java.util.Calendar.getInstance();
                    inputCal.setTime(inputDate);
                    
                    java.util.Calendar originalCal = java.util.Calendar.getInstance();
                    originalCal.setTime(existingOrder.getOrderDate()); // Thời gian từ order gốc
                    
                    // Set ngày từ input, giữ nguyên giờ phút giây từ order gốc
                    originalCal.set(java.util.Calendar.YEAR, inputCal.get(java.util.Calendar.YEAR));
                    originalCal.set(java.util.Calendar.MONTH, inputCal.get(java.util.Calendar.MONTH));
                    originalCal.set(java.util.Calendar.DAY_OF_MONTH, inputCal.get(java.util.Calendar.DAY_OF_MONTH));
                    
                    orderDate = originalCal.getTime();
                    
                    System.out.println("DEBUG: Input date: " + orderDateStr + ", Original time: " + existingOrder.getOrderDate() + ", Final order date: " + orderDate);
                } catch (ParseException e) {
                    System.err.println("Invalid date format: " + orderDateStr + ", keeping original date: " + existingOrder.getOrderDate());
                    orderDate = existingOrder.getOrderDate(); // Fallback to original date
                }
            }
            
            System.out.println("DEBUG: Final order date to be saved: " + orderDate);
            salesOrder.setOrderDate(orderDate);
            
            // Xử lý delivery date - CHỈ NGÀY, KHÔNG CẦN GIỜ
            if (deliveryDateStr != null && !deliveryDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date deliveryDate = sdf.parse(deliveryDateStr);
                    salesOrder.setDeliveryDate(deliveryDate);
                } catch (ParseException e) {
                    System.err.println("Invalid delivery date format: " + deliveryDateStr);
                }
            }
            
            // Xử lý delivery address - sử dụng customer address nếu không có
            String finalDeliveryAddress = deliveryAddress;
            if (finalDeliveryAddress == null || finalDeliveryAddress.trim().isEmpty()) {
                finalDeliveryAddress = customer != null && customer.getAddress() != null ? customer.getAddress() : "";
            }
            
            salesOrder.setStatus("Order"); // FIXED: Giữ nguyên status Order
            salesOrder.setOrderNumber(existingOrder.getOrderNumber()); // Giữ nguyên order number
            salesOrder.setTotalAmount(totalAmount);
            salesOrder.setNotes(notes != null ? notes.trim() : "");
            salesOrder.setDeliveryAddress(finalDeliveryAddress.trim());
            
            // Cập nhật trong database
            boolean success = salesOrderDAO.updateSalesOrder(salesOrder);
            
            if (success) {
                // Xóa items cũ và thêm items mới
                SalesOrderItemDAO itemDAO = new SalesOrderItemDAO();
                itemDAO.deleteItemsBySoId(soId);
                
                for (SalesOrderItem item : orderItems) {
                    item.setSoId(soId);
                }
                
                boolean itemsUpdated = itemDAO.createSalesOrderItems(orderItems);
                
                if (itemsUpdated) {
                    // Get warehouse info for success message
                    WarehouseDAO warehouseDAO = new WarehouseDAO();
                    WarehouseDisplay warehouse = warehouseDAO.getWarehouseById(warehouseId);
                    String warehouseName = warehouse != null ? warehouse.getWarehouseName() : "Warehouse " + warehouseId;
                    
                    // Calculate profit for success message
                    BigDecimal totalProfit = BigDecimal.ZERO;
                    for (SalesOrderItem item : orderItems) {
                        totalProfit = totalProfit.add(item.getTotalProfit());
                    }
                    
                    // FIX: Đảm bảo redirect với đúng soId và log để debug
                    System.out.println("DEBUG: Update successful, redirecting to view-sales-order-detail with id=" + soId);
                    
                    session.setAttribute("success", "Sales order updated successfully! Order contains " + 
                        orderItems.size() + " items from " + warehouseName + " with total value: " + 
                        String.format("%,.0f ₫", totalAmount) + " (Profit: " + String.format("%,.0f ₫", totalProfit) + ")" +
                        " - Updated at: " + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(orderDate));
                    
                    // FIX: Thêm validation cho redirect URL
                    String redirectUrl = request.getContextPath() + "/sale/view-sales-order-detail?id=" + soId;
                    System.out.println("DEBUG: Redirect URL = " + redirectUrl);
                    
                    response.sendRedirect(redirectUrl);
                } else {
                    System.err.println("ERROR: Failed to update order items for soId = " + soId);
                    request.setAttribute("error", "Failed to update order items. Please try again.");
                    doGet(request, response);
                }
            } else {
                System.err.println("ERROR: Failed to update sales order for soId = " + soId);
                request.setAttribute("error", "Failed to update sales order. Please try again.");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            System.err.println("NumberFormatException in edit sales order: " + e.getMessage());
            request.setAttribute("error", "Invalid input data format: " + e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Exception in edit sales order: " + e.getMessage());
            request.setAttribute("error", "Error updating sales order: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    /**
     * Lấy giá sản phẩm từ database
     */
    private BigDecimal getProductPrice(int productId) {
        try {
            InventoryDAO inventoryDAO = new InventoryDAO();
            return inventoryDAO.getProductPrice(productId);
        } catch (Exception e) {
            System.err.println("Error getting product price: " + e.getMessage());
            return BigDecimal.ZERO;
        }
    }
}