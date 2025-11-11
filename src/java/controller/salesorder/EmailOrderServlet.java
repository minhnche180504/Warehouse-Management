package controller.salesorder;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.SalesOrderDAO;
import model.SalesOrder;
import model.SalesOrderItem;
import model.SendMailOK;
import model.User;
import utils.AuthorizationService;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(name = "EmailOrderServlet", urlPatterns = {"/sale/email-order", "/manager/email-order"})
public class EmailOrderServlet extends HttpServlet {
    
    private SalesOrderDAO salesOrderDAO;
    
    @Override
    public void init() throws ServletException {
        salesOrderDAO = new SalesOrderDAO();
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
            int orderId = Integer.parseInt(orderIdParam);
            SalesOrder order = salesOrderDAO.getSalesOrderById(orderId, currentUser);
            
            if (order == null) {
                session.setAttribute("error", "Order not found");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }
            
            // Check if customer has email
            if (order.getCustomerEmail() == null || order.getCustomerEmail().trim().isEmpty()) {
                session.setAttribute("error", "Customer email is not available. Cannot send email.");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }
            
            // Generate email content
            String emailBody = generateEmailContent(order);
            String subject = "Sales Order #" + order.getOrderNumber() + " - Warehouse Management System";
            
            // Email configuration - You need to set these in your system
            String smtpServer = "smtp.gmail.com";
            String fromEmail = System.getenv("SMTP_FROM_EMAIL") != null 
                    ? System.getenv("SMTP_FROM_EMAIL") 
                    : "your-email@gmail.com"; // Thay bằng email của bạn
            String fromPassword = System.getenv("SMTP_FROM_PASSWORD") != null 
                    ? System.getenv("SMTP_FROM_PASSWORD") 
                    : "your-app-password"; // Thay bằng app password của bạn
            
            // Send email
            try {
                SendMailOK.send(smtpServer, order.getCustomerEmail(), fromEmail, fromPassword, subject, emailBody);
                session.setAttribute("success", "Email sent successfully to " + order.getCustomerEmail());
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Failed to send email: " + e.getMessage());
            }
            
            // Redirect back to order detail page
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/sale/view-sales-order-detail?id=" + orderId);
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid order ID");
            response.sendRedirect(request.getHeader("Referer"));
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error processing email request: " + e.getMessage());
            response.sendRedirect(request.getHeader("Referer"));
        }
    }
    
    private String generateEmailContent(SalesOrder order) {
        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html>");
        html.append("<html>");
        html.append("<head><meta charset='UTF-8'></head>");
        html.append("<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>");
        html.append("<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>");
        
        // Header
        html.append("<div style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px 10px 0 0;'>");
        html.append("<h2 style='margin: 0;'>Sales Order Confirmation</h2>");
        html.append("<p style='margin: 5px 0 0 0;'>Order #").append(order.getOrderNumber()).append("</p>");
        html.append("</div>");
        
        // Order Details
        html.append("<div style='background: #f9fafb; padding: 20px; border: 1px solid #e5e7eb;'>");
        html.append("<h3 style='color: #667eea; margin-top: 0;'>Order Details</h3>");
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        html.append("<p><strong>Order Date:</strong> ").append(dateFormat.format(order.getOrderDate())).append("</p>");
        html.append("<p><strong>Status:</strong> <span style='padding: 4px 8px; background: #eef2ff; color: #667eea; border-radius: 4px;'>").append(order.getStatus()).append("</span></p>");
        
        if (order.getDeliveryDate() != null) {
            html.append("<p><strong>Delivery Date:</strong> ").append(new SimpleDateFormat("dd/MM/yyyy").format(order.getDeliveryDate())).append("</p>");
        }
        
        if (order.getDeliveryAddress() != null && !order.getDeliveryAddress().isEmpty()) {
            html.append("<p><strong>Delivery Address:</strong> ").append(order.getDeliveryAddress()).append("</p>");
        }
        
        html.append("</div>");
        
        // Customer Info
        html.append("<div style='background: white; padding: 20px; border: 1px solid #e5e7eb; border-top: none;'>");
        html.append("<h3 style='color: #667eea; margin-top: 0;'>Customer Information</h3>");
        html.append("<p><strong>Name:</strong> ").append(order.getCustomerName() != null ? order.getCustomerName() : "N/A").append("</p>");
        html.append("<p><strong>Email:</strong> ").append(order.getCustomerEmail() != null ? order.getCustomerEmail() : "N/A").append("</p>");
        html.append("</div>");
        
        // Items
        html.append("<div style='background: white; padding: 20px; border: 1px solid #e5e7eb; border-top: none;'>");
        html.append("<h3 style='color: #667eea; margin-top: 0;'>Order Items</h3>");
        html.append("<table style='width: 100%; border-collapse: collapse; margin-top: 10px;'>");
        html.append("<thead>");
        html.append("<tr style='background: #f3f4f6;'>");
        html.append("<th style='padding: 10px; text-align: left; border-bottom: 2px solid #e5e7eb;'>Product</th>");
        html.append("<th style='padding: 10px; text-align: center; border-bottom: 2px solid #e5e7eb;'>Quantity</th>");
        html.append("<th style='padding: 10px; text-align: right; border-bottom: 2px solid #e5e7eb;'>Unit Price</th>");
        html.append("<th style='padding: 10px; text-align: right; border-bottom: 2px solid #e5e7eb;'>Total</th>");
        html.append("</tr>");
        html.append("</thead>");
        html.append("<tbody>");
        
        List<SalesOrderItem> items = order.getItems();
        if (items != null) {
            for (SalesOrderItem item : items) {
                html.append("<tr>");
                html.append("<td style='padding: 10px; border-bottom: 1px solid #e5e7eb;'>");
                html.append("<strong>").append(item.getProductName() != null ? item.getProductName() : "N/A").append("</strong><br>");
                html.append("<small style='color: #6b7280;'>").append(item.getProductCode() != null ? item.getProductCode() : "").append("</small>");
                html.append("</td>");
                html.append("<td style='padding: 10px; text-align: center; border-bottom: 1px solid #e5e7eb;'>").append(item.getQuantity()).append("</td>");
                html.append("<td style='padding: 10px; text-align: right; border-bottom: 1px solid #e5e7eb;'>").append(String.format("%,.0f ₫", item.getSellingPrice())).append("</td>");
                html.append("<td style='padding: 10px; text-align: right; border-bottom: 1px solid #e5e7eb;'><strong>").append(String.format("%,.0f ₫", item.getTotalPrice())).append("</strong></td>");
                html.append("</tr>");
            }
        }
        
        html.append("</tbody>");
        html.append("</table>");
        html.append("</div>");
        
        // Summary
        html.append("<div style='background: #f9fafb; padding: 20px; border: 1px solid #e5e7eb; border-top: none;'>");
        html.append("<div style='text-align: right;'>");
        html.append("<p style='margin: 5px 0;'><strong>Total Amount: </strong><span style='font-size: 1.5em; color: #667eea;'>").append(String.format("%,.0f ₫", order.getTotalAmount())).append("</span></p>");
        html.append("</div>");
        html.append("</div>");
        
        // Footer
        html.append("<div style='background: #e5e7eb; padding: 15px; text-align: center; border-radius: 0 0 10px 10px; margin-top: 20px;'>");
        html.append("<p style='margin: 0; color: #6b7280; font-size: 0.9em;'>Thank you for your business!</p>");
        html.append("<p style='margin: 5px 0 0 0; color: #6b7280; font-size: 0.85em;'>Warehouse Management System</p>");
        html.append("</div>");
        
        html.append("</div>");
        html.append("</body>");
        html.append("</html>");
        
        return html.toString();
    }
}

