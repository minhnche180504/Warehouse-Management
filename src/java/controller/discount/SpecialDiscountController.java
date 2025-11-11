package controller.discount;

import dao.SpecialDiscountRequestDAO;
import dao.CustomerDAO;
import model.SpecialDiscountRequest;
import model.User;
import model.Customer;
import utils.AuthorizationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.Random;

@WebServlet(name = "SpecialDiscountController", urlPatterns = {
    "/sale/request-special-discount",
    "/sale/my-special-requests",
    "/manager/special-discount-requests",
    "/manager/approve-special-discount",
    "/manager/reject-special-discount"
})
public class SpecialDiscountController extends HttpServlet {

    private SpecialDiscountRequestDAO requestDAO;
    private CustomerDAO customerDAO;
    
    @Override
    public void init() throws ServletException {
        requestDAO = new SpecialDiscountRequestDAO();
        customerDAO = new CustomerDAO();
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
                case "/sale/request-special-discount":
                    showRequestForm(request, response);
                    break;
                case "/sale/my-special-requests":
                    showMyRequests(request, response);
                    break;
                case "/manager/special-discount-requests":
                    showAllRequests(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/");
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error in SpecialDiscountController doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        try {
            switch (action) {
                case "/sale/request-special-discount":
                    createSpecialRequest(request, response);
                    break;
                case "/manager/approve-special-discount":
                    approveRequest(request, response);
                    break;
                case "/manager/reject-special-discount":
                    rejectRequest(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/");
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error in SpecialDiscountController doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    private void showRequestForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get customers for dropdown
        List<Customer> customers = customerDAO.getAllCustomers();
        request.setAttribute("customers", customers);
        
        request.getRequestDispatcher("/sale/request-special-discount.jsp").forward(request, response);
    }

    private void showMyRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        List<SpecialDiscountRequest> requests = requestDAO.getRequestsByUser(currentUser.getUserId());
        request.setAttribute("requests", requests);
        
        request.getRequestDispatcher("/sale/my-special-requests.jsp").forward(request, response);
    }

    private void showAllRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String filter = request.getParameter("filter");
        List<SpecialDiscountRequest> requests;
        
        if ("pending".equals(filter)) {
            requests = requestDAO.getPendingRequests();
        } else {
            requests = requestDAO.getAllRequests();
        }
        
        request.setAttribute("requests", requests);
        request.setAttribute("filter", filter);
        
        request.getRequestDispatcher("/manager/special-discount-requests.jsp").forward(request, response);
    }

    private void createSpecialRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get form data
            String customerIdStr = request.getParameter("customerId");
            String discountType = request.getParameter("discountType");
            String discountValueStr = request.getParameter("discountValue");
            String reason = request.getParameter("reason");
            String estimatedOrderValueStr = request.getParameter("estimatedOrderValue");
            
            // Validation
            if (customerIdStr == null || customerIdStr.trim().isEmpty() ||
                discountType == null || discountType.trim().isEmpty() ||
                discountValueStr == null || discountValueStr.trim().isEmpty() ||
                reason == null || reason.trim().isEmpty()) {
                
                request.setAttribute("error", "Please fill in all required fields.");
                showRequestForm(request, response);
                return;
            }
            
            int customerId = Integer.parseInt(customerIdStr);
            double discountValue = Double.parseDouble(discountValueStr);
            Double estimatedOrderValue = estimatedOrderValueStr.isEmpty() ? null : Double.parseDouble(estimatedOrderValueStr);
            
            // Create request object
            SpecialDiscountRequest specialRequest = new SpecialDiscountRequest();
            specialRequest.setCustomerId(customerId);
            specialRequest.setRequestedBy(currentUser.getUserId());
            specialRequest.setDiscountType(discountType);
            specialRequest.setDiscountValue(discountValue);
            specialRequest.setReason(reason.trim());
            specialRequest.setEstimatedOrderValue(estimatedOrderValue);
            
            // Save to database
            boolean success = requestDAO.addRequest(specialRequest);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/sale/my-special-requests?success=Special discount request submitted successfully");
            } else {
                request.setAttribute("error", "Failed to submit request. Please try again.");
                showRequestForm(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("Error creating special request: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Invalid input data. Please check your entries.");
            showRequestForm(request, response);
        }
    }

    private void approveRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String requestIdStr = request.getParameter("requestId");
        if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/special-discount-requests?error=Invalid request ID");
            return;
        }
        
        try {
            int requestId = Integer.parseInt(requestIdStr);
            
            // Generate unique code for approved request
            String generatedCode = generateSpecialCode();
            
            // Set expiry date (7 days from now)
            Timestamp expiryDate = new Timestamp(System.currentTimeMillis() + (7 * 24 * 60 * 60 * 1000L));
            
            boolean success = requestDAO.approveRequest(requestId, currentUser.getUserId(), generatedCode, expiryDate);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manager/special-discount-requests?success=Request approved successfully. Code: " + generatedCode);
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/special-discount-requests?error=Failed to approve request");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/special-discount-requests?error=Invalid request ID format");
        }
    }

    private void rejectRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String requestIdStr = request.getParameter("requestId");
        String rejectionReason = request.getParameter("rejectionReason");
        
        if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/special-discount-requests?error=Invalid request ID");
            return;
        }
        
        if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/special-discount-requests?error=Rejection reason is required");
            return;
        }
        
        try {
            int requestId = Integer.parseInt(requestIdStr);
            
            boolean success = requestDAO.rejectRequest(requestId, currentUser.getUserId(), rejectionReason.trim());
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manager/special-discount-requests?success=Request rejected successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/special-discount-requests?error=Failed to reject request");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/special-discount-requests?error=Invalid request ID format");
        }
    }

    private String generateSpecialCode() {
        // Generate special discount code: SPECIAL-XXXXX
        Random random = new Random();
        int randomNum = 10000 + random.nextInt(90000); // 5-digit random number
        return "SPECIAL-" + randomNum;
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}