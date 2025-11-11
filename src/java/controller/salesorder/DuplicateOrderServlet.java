package controller.salesorder;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.SalesOrderDAO;
import dao.SalesOrderItemDAO;
import model.SalesOrder;
import model.SalesOrderItem;
import model.User;
import utils.AuthorizationService;

@WebServlet(name = "DuplicateOrderServlet", urlPatterns = {"/sale/duplicate-order", "/manager/duplicate-order"})
public class DuplicateOrderServlet extends HttpServlet {
    
    private SalesOrderDAO salesOrderDAO;
    private SalesOrderItemDAO salesOrderItemDAO;
    
    @Override
    public void init() throws ServletException {
        salesOrderDAO = new SalesOrderDAO();
        salesOrderItemDAO = new SalesOrderItemDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String orderIdParam = request.getParameter("id");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            session.setAttribute("error", "Order ID is required");
            response.sendRedirect(request.getHeader("Referer"));
            return;
        }
        
        try {
            int originalOrderId = Integer.parseInt(orderIdParam);
            SalesOrder originalOrder = salesOrderDAO.getSalesOrderById(originalOrderId, currentUser);
            
            if (originalOrder == null) {
                session.setAttribute("error", "Original order not found");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }
            
            // Create duplicate order
            SalesOrder duplicateOrder = new SalesOrder();
            duplicateOrder.setCustomerId(originalOrder.getCustomerId());
            duplicateOrder.setUserId(currentUser.getUserId());
            duplicateOrder.setWarehouseId(originalOrder.getWarehouseId());
            duplicateOrder.setOrderDate(new Date());
            duplicateOrder.setStatus("Order"); // Set to initial status
            duplicateOrder.setDeliveryDate(originalOrder.getDeliveryDate());
            duplicateOrder.setDeliveryAddress(originalOrder.getDeliveryAddress());
            duplicateOrder.setNotes("Duplicated from Order #" + originalOrder.getOrderNumber() + 
                    (originalOrder.getNotes() != null ? ". " + originalOrder.getNotes() : ""));
            
            // Generate new order number
            String newOrderNumber = generateOrderNumber();
            duplicateOrder.setOrderNumber(newOrderNumber);
            
            // Calculate total amount from items
            BigDecimal totalAmount = BigDecimal.ZERO;
            if (originalOrder.getItems() != null) {
                for (SalesOrderItem item : originalOrder.getItems()) {
                    totalAmount = totalAmount.add(item.getTotalPrice());
                }
            }
            duplicateOrder.setTotalAmount(totalAmount);
            
            // Create the duplicate order
            int newOrderId = salesOrderDAO.createSalesOrder(duplicateOrder);
            
            if (newOrderId > 0) {
                // Duplicate order items
                List<SalesOrderItem> duplicateItems = new ArrayList<>();
                if (originalOrder.getItems() != null) {
                    for (SalesOrderItem originalItem : originalOrder.getItems()) {
                        SalesOrderItem duplicateItem = new SalesOrderItem();
                        duplicateItem.setSoId(newOrderId);
                        duplicateItem.setProductId(originalItem.getProductId());
                        duplicateItem.setQuantity(originalItem.getQuantity());
                        duplicateItem.setUnitPrice(originalItem.getUnitPrice());
                        duplicateItem.setSellingPrice(originalItem.getSellingPrice());
                        duplicateItems.add(duplicateItem);
                    }
                }
                
                // Save duplicate items
                boolean itemsCreated = salesOrderItemDAO.createSalesOrderItems(duplicateItems);
                
                if (itemsCreated) {
                    session.setAttribute("success", 
                        "Order duplicated successfully! New Order #" + newOrderNumber + 
                        " has been created with " + duplicateItems.size() + " items.");
                    
                    // Redirect to the new order detail page
                    String contextPath = request.getContextPath();
                    if (request.getRequestURI().contains("/manager/")) {
                        response.sendRedirect(contextPath + "/manager/view-sales-order-detail?id=" + newOrderId);
                    } else {
                        response.sendRedirect(contextPath + "/sale/view-sales-order-detail?id=" + newOrderId);
                    }
                } else {
                    session.setAttribute("error", "Failed to duplicate order items. Please try again.");
                    response.sendRedirect(request.getHeader("Referer"));
                }
            } else {
                session.setAttribute("error", "Failed to create duplicate order. Please try again.");
                response.sendRedirect(request.getHeader("Referer"));
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid order ID");
            response.sendRedirect(request.getHeader("Referer"));
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error duplicating order: " + e.getMessage());
            response.sendRedirect(request.getHeader("Referer"));
        }
    }
    
    /**
     * Generate unique order number - Same format as CreateSalesOrderServlet
     */
    private String generateOrderNumber() {
        long timestamp = System.currentTimeMillis() % 10000;
        return "SO-" + String.format("%04d", timestamp);
    }
}

