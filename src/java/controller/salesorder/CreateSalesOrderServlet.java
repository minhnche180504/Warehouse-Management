package controller.salesorder;

import dao.CustomerDAO;
import dao.WarehouseDAO;
import dao.SalesOrderDAO;
import dao.SalesOrderItemDAO;
import dao.InventoryDAO;
import model.Customer;
import model.User;
import model.WarehouseDisplay;
import model.SalesOrder;
import model.SalesOrderItem;

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

@WebServlet("/sale/create-sales-order")
public class CreateSalesOrderServlet extends HttpServlet {

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

        try {
            // Load customers
            CustomerDAO customerDAO = new CustomerDAO();
            List<Customer> customers = customerDAO.getAllCustomers();
            request.setAttribute("customers", customers);

            // WAREHOUSE FILTERING: Load warehouses theo quyền user
            WarehouseDAO warehouseDAO = new WarehouseDAO();
            List<WarehouseDisplay> allWarehouses = warehouseDAO.getAllWarehouses();
            List<WarehouseDisplay> allowedWarehouses = WarehouseAuthUtil.filterAllowedWarehouses(currentUser, allWarehouses);
            
            request.setAttribute("warehouses", allowedWarehouses);
            request.setAttribute("currentUser", currentUser);
            
            request.getRequestDispatcher("/sale/sale-order-add.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading form data: " + e.getMessage());
            request.getRequestDispatcher("/sale/sale-order-add.jsp").forward(request, response);
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

        try {
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
                request.setAttribute("error", "You don't have permission to create orders for this warehouse.");
                doGet(request, response);
                return;
            }
            
            // Lấy thông tin products được chọn - UPDATED WITH SELLING PRICE
            List<SalesOrderItem> orderItems = new ArrayList<>();
            BigDecimal totalAmount = BigDecimal.ZERO;
            
            // Parse products from request parameters
            String productCountStr = request.getParameter("productCount");
            
            if (productCountStr != null && !productCountStr.trim().isEmpty()) {
                try {
                    int productCount = Integer.parseInt(productCountStr.trim());
                    
                    for (int i = 0; i < productCount; i++) {
                        String productIdParam = request.getParameter("productId_" + i);
                        String quantityParam = request.getParameter("quantity_" + i);
                        String sellingPriceParam = request.getParameter("sellingPrice_" + i); // UPDATED: Thêm selling price
                        
                        if (productIdParam != null && quantityParam != null && 
                            !productIdParam.trim().isEmpty() && !quantityParam.trim().isEmpty()) {
                            
                            int productId = Integer.parseInt(productIdParam.trim());
                            int quantity = Integer.parseInt(quantityParam.trim());
                            
                            // CHỈ KIỂM TRA TỒN KHO - KHÔNG TRỪ KHO NGAY
                            InventoryDAO inventoryDAO = new InventoryDAO();
                            if (!inventoryDAO.checkStock(productId, warehouseId, quantity)) {
                                request.setAttribute("error", "Insufficient stock for product ID: " + productId + ". Please check inventory or request restock.");
                                doGet(request, response);
                                return;
                            }
                            
                            // Get product unit price (cost price)
                            BigDecimal unitPrice = getProductPrice(productId);
                            if (unitPrice.compareTo(BigDecimal.ZERO) <= 0) {
                                request.setAttribute("error", "Invalid price for product ID: " + productId);
                                doGet(request, response);
                                return;
                            }
                            
                            // UPDATED: Xử lý selling price
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
                            
                            // UPDATED: Tạo SalesOrderItem với cả unit price và selling price
                            SalesOrderItem item = new SalesOrderItem();
                            item.setProductId(productId);
                            item.setQuantity(quantity);
                            item.setUnitPrice(unitPrice);        // Giá gốc từ kho
                            item.setSellingPrice(sellingPrice);   // Giá bán thực tế
                            item.calculateTotalPrice();
                            
                            orderItems.add(item);
                            totalAmount = totalAmount.add(item.getTotalPrice()); // Tính theo selling price
                        }
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid product count format.");
                    doGet(request, response);
                    return;
                }
            }
            
            // Kiểm tra có sản phẩm được chọn không
            if (orderItems.isEmpty()) {
                request.setAttribute("error", "Please select at least one product for this order.");
                doGet(request, response);
                return;
            }
            
            // Kiểm tra customer và warehouse có tồn tại không
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerById(customerId);
            
            WarehouseDAO warehouseDAO = new WarehouseDAO();
            WarehouseDisplay warehouse = warehouseDAO.getWarehouseById(warehouseId);
            
            if (customer == null) {
                request.setAttribute("error", "Selected customer not found.");
                doGet(request, response);
                return;
            }
            
            if (warehouse == null) {
                request.setAttribute("error", "Selected warehouse not found.");
                doGet(request, response);
                return;
            }
            
            // Tạo Sales Order object
            SalesOrder salesOrder = new SalesOrder();
            salesOrder.setCustomerId(customerId);
            salesOrder.setUserId(currentUser.getUserId());
            salesOrder.setWarehouseId(warehouseId);
            
            // ★ FIX CHÍNH: Xử lý order date - LUÔN SỬ DỤNG THỜI GIAN HIỆN TẠI
            Date orderDate = new Date(); // Thời gian hiện tại với giờ phút giây
            
            // Nếu người dùng nhập ngày khác thì chỉ lấy ngày, giữ nguyên giờ hiện tại
            if (orderDateStr != null && !orderDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    Date inputDate = inputDateFormat.parse(orderDateStr);
                    
                    // Tạo Calendar để kết hợp ngày từ input và thời gian hiện tại
                    java.util.Calendar inputCal = java.util.Calendar.getInstance();
                    inputCal.setTime(inputDate);
                    
                    java.util.Calendar currentCal = java.util.Calendar.getInstance();
                    currentCal.setTime(new Date()); // Thời gian hiện tại
                    
                    // Set ngày từ input, giữ nguyên giờ phút giây hiện tại
                    currentCal.set(java.util.Calendar.YEAR, inputCal.get(java.util.Calendar.YEAR));
                    currentCal.set(java.util.Calendar.MONTH, inputCal.get(java.util.Calendar.MONTH));
                    currentCal.set(java.util.Calendar.DAY_OF_MONTH, inputCal.get(java.util.Calendar.DAY_OF_MONTH));
                    
                    orderDate = currentCal.getTime();
                    
                    System.out.println("DEBUG: Input date: " + orderDateStr + ", Final order date: " + orderDate);
                } catch (ParseException e) {
                    System.err.println("Invalid date format: " + orderDateStr + ", using current time");
                    orderDate = new Date(); // Fallback to current time
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
                finalDeliveryAddress = customer.getAddress() != null ? customer.getAddress() : "";
            }
            
            // UPDATED: TẠO ĐƠN VỚI STATUS "Order" (thay vì "Pending")
            salesOrder.setStatus("Order");
            salesOrder.setOrderNumber(generateOrderNumber());
            salesOrder.setTotalAmount(totalAmount);
            salesOrder.setNotes(notes != null ? notes.trim() : "");
            salesOrder.setDeliveryAddress(finalDeliveryAddress.trim());
            
            // Lưu vào database - CHỈ TẠO ORDER VÀ ITEMS
            SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
            int newOrderId = salesOrderDAO.createSalesOrder(salesOrder);
            
            if (newOrderId > 0) {
                // Lưu order items
                SalesOrderItemDAO itemDAO = new SalesOrderItemDAO();
                for (SalesOrderItem item : orderItems) {
                    item.setSoId(newOrderId);
                }
                
                boolean itemsCreated = itemDAO.createSalesOrderItems(orderItems);
                
                if (itemsCreated) {
                    // Tính tổng lãi để hiển thị
                    BigDecimal totalProfit = BigDecimal.ZERO;
                    for (SalesOrderItem item : orderItems) {
                        totalProfit = totalProfit.add(item.getTotalProfit());
                    }
                    
                    session.setAttribute("success", 
                        "Sales order created successfully! Order #" + salesOrder.getOrderNumber() + 
                        " for customer " + customer.getCustomerName() + 
                        " with " + orderItems.size() + " items from warehouse " + warehouse.getWarehouseName() + 
                        ". Status: Order - Total: " + String.format("%,.0f ₫", totalAmount) +
                        " (Profit: " + String.format("%,.0f ₫", totalProfit) + ")" +
                        " - Created at: " + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(orderDate));
                    response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-detail?id=" + newOrderId);
                } else {
                    request.setAttribute("error", "Failed to create order items. Please try again.");
                    doGet(request, response);
                }
            } else {
                request.setAttribute("error", "Failed to create sales order. Please try again.");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid input data format.");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error creating sales order: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    /**
     * Tạo order number unique theo format SO-XXXX
     */
    private String generateOrderNumber() {
        long timestamp = System.currentTimeMillis() % 10000;
        return "SO-" + String.format("%04d", timestamp);
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