package controller.discount;

import dao.DiscountCodeDAO;
import model.DiscountCode;
import model.User;
import utils.AuthorizationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(name = "ManagerDiscountController", urlPatterns = {
    "/manager/discount-codes",
    "/manager/create-discount-code",
    "/manager/edit-discount-code",
    "/manager/delete-discount-code"
})
public class ManagerDiscountController extends HttpServlet {

    private DiscountCodeDAO discountDAO;
    
    @Override
    public void init() throws ServletException {
        discountDAO = new DiscountCodeDAO();
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
            switch (action) {
                case "/manager/discount-codes":
                    listDiscountCodes(request, response);
                    break;
                case "/manager/create-discount-code":
                    showCreateForm(request, response);
                    break;
                case "/manager/edit-discount-code":
                    showEditForm(request, response);
                    break;
                default:
                    listDiscountCodes(request, response);
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error in ManagerDiscountController doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            listDiscountCodes(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        try {
            switch (action) {
                case "/manager/create-discount-code":
                    createDiscountCode(request, response);
                    break;
                case "/manager/edit-discount-code":
                    updateDiscountCode(request, response);
                    break;
                case "/manager/delete-discount-code":
                    deleteDiscountCode(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/manager/discount-codes");
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error in ManagerDiscountController doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            listDiscountCodes(request, response);
        }
    }

    private void listDiscountCodes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<DiscountCode> discountCodes = discountDAO.getAllDiscountCodes();
        request.setAttribute("discountCodes", discountCodes);
        request.getRequestDispatcher("/manager/discount-codes.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/manager/create-discount-code.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/discount-codes?error=Invalid discount ID");
            return;
        }
        
        try {
            int discountId = Integer.parseInt(idParam);
            DiscountCode discountCode = discountDAO.getDiscountCodeById(discountId);
            
            if (discountCode == null) {
                response.sendRedirect(request.getContextPath() + "/manager/discount-codes?error=Discount code not found");
                return;
            }
            
            request.setAttribute("discountCode", discountCode);
            request.getRequestDispatcher("/manager/edit-discount-code.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/discount-codes?error=Invalid discount ID format");
        }
    }

    private void createDiscountCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get form data
            String code = request.getParameter("code");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String discountType = request.getParameter("discountType");
            String discountValueStr = request.getParameter("discountValue");
            String minOrderAmountStr = request.getParameter("minOrderAmount");
            String maxDiscountAmountStr = request.getParameter("maxDiscountAmount");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String usageLimitStr = request.getParameter("usageLimit");
            
            // Validation
            if (code == null || code.trim().isEmpty() ||
                name == null || name.trim().isEmpty() ||
                discountType == null || discountType.trim().isEmpty() ||
                discountValueStr == null || discountValueStr.trim().isEmpty() ||
                startDateStr == null || startDateStr.trim().isEmpty() ||
                endDateStr == null || endDateStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Please fill in all required fields.");
                request.setAttribute("formData", request.getParameterMap());
                showCreateForm(request, response);
                return;
            }
            
            // Check if code already exists
            if (discountDAO.codeExists(code.trim())) {
                request.setAttribute("error", "Discount code already exists. Please use a different code.");
                request.setAttribute("formData", request.getParameterMap());
                showCreateForm(request, response);
                return;
            }
            
            // Parse and validate numeric values
            double discountValue = Double.parseDouble(discountValueStr);
            double minOrderAmount = minOrderAmountStr.isEmpty() ? 0 : Double.parseDouble(minOrderAmountStr);
            Double maxDiscountAmount = maxDiscountAmountStr.isEmpty() ? null : Double.parseDouble(maxDiscountAmountStr);
            Integer usageLimit = usageLimitStr.isEmpty() ? null : Integer.parseInt(usageLimitStr);
            
            // Parse dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Timestamp startDate = new Timestamp(dateFormat.parse(startDateStr).getTime());
            Timestamp endDate = new Timestamp(dateFormat.parse(endDateStr).getTime());
            
            // Create discount code object
            DiscountCode discountCode = new DiscountCode();
            discountCode.setCode(code.trim());
            discountCode.setName(name.trim());
            discountCode.setDescription(description);
            discountCode.setDiscountType(discountType);
            discountCode.setDiscountValue(discountValue);
            discountCode.setMinOrderAmount(minOrderAmount);
            discountCode.setMaxDiscountAmount(maxDiscountAmount);
            discountCode.setStartDate(startDate);
            discountCode.setEndDate(endDate);
            discountCode.setUsageLimit(usageLimit);
            discountCode.setCreatedBy(currentUser.getUserId());
            
            // Save to database
            boolean success = discountDAO.addDiscountCode(discountCode);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manager/discount-codes?success=Discount code created successfully");
            } else {
                request.setAttribute("error", "Failed to create discount code. Please try again.");
                request.setAttribute("formData", request.getParameterMap());
                showCreateForm(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("Error creating discount code: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Invalid input data. Please check your entries.");
            request.setAttribute("formData", request.getParameterMap());
            showCreateForm(request, response);
        }
    }

    private void updateDiscountCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/discount-codes?error=Invalid discount ID");
            return;
        }
        
        try {
            int discountId = Integer.parseInt(idParam);
            DiscountCode existingCode = discountDAO.getDiscountCodeById(discountId);
            
            if (existingCode == null) {
                response.sendRedirect(request.getContextPath() + "/manager/discount-codes?error=Discount code not found");
                return;
            }
            
            // Get form data
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String discountType = request.getParameter("discountType");
            String discountValueStr = request.getParameter("discountValue");
            String minOrderAmountStr = request.getParameter("minOrderAmount");
            String maxDiscountAmountStr = request.getParameter("maxDiscountAmount");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String usageLimitStr = request.getParameter("usageLimit");
            String isActiveStr = request.getParameter("isActive");
            
            // Update fields
            existingCode.setName(name.trim());
            existingCode.setDescription(description);
            existingCode.setDiscountType(discountType);
            existingCode.setDiscountValue(Double.parseDouble(discountValueStr));
            existingCode.setMinOrderAmount(minOrderAmountStr.isEmpty() ? 0 : Double.parseDouble(minOrderAmountStr));
            existingCode.setMaxDiscountAmount(maxDiscountAmountStr.isEmpty() ? null : Double.parseDouble(maxDiscountAmountStr));
            existingCode.setUsageLimit(usageLimitStr.isEmpty() ? null : Integer.parseInt(usageLimitStr));
            existingCode.setActive("true".equals(isActiveStr));
            
            // Parse dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            existingCode.setStartDate(new Timestamp(dateFormat.parse(startDateStr).getTime()));
            existingCode.setEndDate(new Timestamp(dateFormat.parse(endDateStr).getTime()));
            
            // Update in database
            boolean success = discountDAO.updateDiscountCode(existingCode);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manager/discount-codes?success=Discount code updated successfully");
            } else {
                request.setAttribute("error", "Failed to update discount code.");
                request.setAttribute("discountCode", existingCode);
                showEditForm(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("Error updating discount code: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager/discount-codes?error=Error updating discount code");
        }
    }

    private void deleteDiscountCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/discount-codes?error=Invalid discount ID");
            return;
        }
        
        try {
            int discountId = Integer.parseInt(idParam);
            boolean success = discountDAO.deleteDiscountCode(discountId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manager/discount-codes?success=Discount code deactivated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/discount-codes?error=Failed to deactivate discount code");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/discount-codes?error=Invalid discount ID format");
        }
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}