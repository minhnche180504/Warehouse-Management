package controller.discount;

import dao.DiscountCodeDAO;
import dao.SpecialDiscountRequestDAO;
import model.DiscountCode;
import model.SpecialDiscountRequest;
import utils.AuthorizationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@WebServlet(name = "DiscountValidationController", urlPatterns = {
    "/sale/available-discount-codes",
    "/sale/validate-discount-code"
})
public class DiscountValidationController extends HttpServlet {

    private DiscountCodeDAO discountDAO;
    private SpecialDiscountRequestDAO specialRequestDAO;
    
    @Override
    public void init() throws ServletException {
        discountDAO = new DiscountCodeDAO();
        specialRequestDAO = new SpecialDiscountRequestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Authorization check
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        
        String action = request.getServletPath();
        
        try {
            if ("/sale/available-discount-codes".equals(action)) {
                getAvailableDiscountCodes(request, response);
            } else if ("/sale/validate-discount-code".equals(action)) {
                validateDiscountCode(request, response);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.out.println("Error in DiscountValidationController: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void getAvailableDiscountCodes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderAmountStr = request.getParameter("orderAmount");
        double orderAmount = 0;
        
        if (orderAmountStr != null && !orderAmountStr.trim().isEmpty()) {
            try {
                orderAmount = Double.parseDouble(orderAmountStr);
            } catch (NumberFormatException e) {
                orderAmount = 0;
            }
        }
        
        List<DiscountCode> activeCodes = discountDAO.getActiveDiscountCodes();
        
        // FIXED: Replace lambda with traditional iterator approach
        if (orderAmount > 0) {
            Iterator<DiscountCode> iterator = activeCodes.iterator();
            while (iterator.hasNext()) {
                DiscountCode code = iterator.next();
                if (code.getMinOrderAmount() > orderAmount) {
                    iterator.remove();
                }
            }
        }
        
        request.setAttribute("discountCodes", activeCodes);
        request.setAttribute("orderAmount", orderAmount);
        
        request.getRequestDispatcher("/sale/available-discount-codes.jsp").forward(request, response);
    }

    private void validateDiscountCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String code = request.getParameter("code");
        String orderAmountStr = request.getParameter("orderAmount");
        
        PrintWriter out = response.getWriter();
        
        if (code == null || code.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Discount code is required\"}");
            return;
        }
        
        if (orderAmountStr == null || orderAmountStr.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Order amount is required\"}");
            return;
        }
        
        try {
            double orderAmount = Double.parseDouble(orderAmountStr);
            
            // First, try to find regular discount code
            DiscountCode discountCode = discountDAO.getDiscountCodeByCode(code.trim());
            
            if (discountCode != null) {
                // Validate discount code
                String validationResult = validateRegularDiscountCode(discountCode, orderAmount);
                out.print(validationResult);
                return;
            }
            
            // If not found in regular codes, try special discount requests
            SpecialDiscountRequest specialRequest = specialRequestDAO.getRequestByCode(code.trim());
            
            if (specialRequest != null) {
                // Validate special discount
                String validationResult = validateSpecialDiscountCode(specialRequest, orderAmount);
                out.print(validationResult);
                return;
            }
            
            // Code not found
            out.print("{\"success\": false, \"message\": \"Invalid discount code\"}");
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid order amount\"}");
        } catch (Exception e) {
            System.out.println("Error validating discount code: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Error validating discount code\"}");
        }
    }

    private String validateRegularDiscountCode(DiscountCode discountCode, double orderAmount) {
        try {
            // Check if code is valid
            if (!discountCode.isValid()) {
                return "{\"success\": false, \"message\": \"Discount code has expired or is not active\"}";
            }
            
            // Check minimum order amount
            if (orderAmount < discountCode.getMinOrderAmount()) {
                return String.format("{\"success\": false, \"message\": \"Minimum order amount is %.0f VND\"}", 
                    discountCode.getMinOrderAmount());
            }
            
            // Calculate discount amount
            double discountAmount = discountCode.calculateDiscountAmount(orderAmount);
            double finalAmount = orderAmount - discountAmount;
            
            // FIXED: Use String concatenation instead of String.format for better compatibility
            StringBuilder result = new StringBuilder();
            result.append("{\"success\": true, \"valid\": true, ");
            result.append("\"discountInfo\": {");
            result.append("\"discountId\": ").append(discountCode.getDiscountId()).append(", ");
            result.append("\"discountType\": \"").append(discountCode.getDiscountType()).append("\", ");
            result.append("\"discountValue\": ").append(discountCode.getDiscountValue()).append(", ");
            result.append("\"calculatedDiscount\": ").append((long)discountAmount).append(", ");
            result.append("\"finalAmount\": ").append((long)finalAmount).append(", ");
            result.append("\"type\": \"regular\"");
            result.append("}}");
            
            return result.toString();
            
        } catch (Exception e) {
            System.out.println("Error in validateRegularDiscountCode: " + e.getMessage());
            return "{\"success\": false, \"message\": \"Error processing discount code\"}";
        }
    }

    private String validateSpecialDiscountCode(SpecialDiscountRequest specialRequest, double orderAmount) {
        try {
            // Check if request is approved and not expired
            if (!"Approved".equals(specialRequest.getStatus())) {
                return "{\"success\": false, \"message\": \"Special discount code is not approved\"}";
            }
            
            if (specialRequest.getExpiryDate() != null && 
                specialRequest.getExpiryDate().before(new java.sql.Timestamp(System.currentTimeMillis()))) {
                return "{\"success\": false, \"message\": \"Special discount code has expired\"}";
            }
            
            // Calculate discount amount
            double discountAmount = 0;
            if ("PERCENTAGE".equals(specialRequest.getDiscountType())) {
                discountAmount = orderAmount * specialRequest.getDiscountValue() / 100;
            } else if ("FIXED_AMOUNT".equals(specialRequest.getDiscountType())) {
                discountAmount = specialRequest.getDiscountValue();
            }
            
            // Ensure discount doesn't exceed order amount
            discountAmount = Math.min(discountAmount, orderAmount);
            double finalAmount = orderAmount - discountAmount;
            
            // FIXED: Use String concatenation instead of String.format
            StringBuilder result = new StringBuilder();
            result.append("{\"success\": true, \"valid\": true, ");
            result.append("\"discountInfo\": {");
            result.append("\"requestId\": ").append(specialRequest.getRequestId()).append(", ");
            result.append("\"discountType\": \"").append(specialRequest.getDiscountType()).append("\", ");
            result.append("\"discountValue\": ").append(specialRequest.getDiscountValue()).append(", ");
            result.append("\"calculatedDiscount\": ").append((long)discountAmount).append(", ");
            result.append("\"finalAmount\": ").append((long)finalAmount).append(", ");
            result.append("\"type\": \"special\"");
            result.append("}}");
            
            return result.toString();
            
        } catch (Exception e) {
            System.out.println("Error in validateSpecialDiscountCode: " + e.getMessage());
            return "{\"success\": false, \"message\": \"Error processing special discount code\"}";
        }
    }
}