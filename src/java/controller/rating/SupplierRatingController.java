package controller.rating;

import dao.SupplierRatingDAO;
import dao.SupplierDAO;
import dao.UserDAO;
import model.SupplierRating;
import model.Supplier;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import utils.AuthorizationService;

@WebServlet(name = "SupplierRatingController", urlPatterns = {"/purchase/supplier-rating"})
public class SupplierRatingController extends HttpServlet {

    private SupplierRatingDAO ratingDAO = new SupplierRatingDAO();
    private SupplierDAO supplierDAO = new SupplierDAO();
    private UserDAO userDAO = new UserDAO();

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
            case "add":
                handleShowAddForm(request, response);
                break;
            case "edit":
                handleShowEditForm(request, response);
                break;
            case "view":
                handleViewRating(request, response);
                break;
            case "supplier-ratings":
                handleViewSupplierRatings(request, response);
                break;
            case "my-ratings":
                handleViewMyRatings(request, response);
                break;
            case "delete":
                handleDelete(request, response);
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
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
            return;
        }
        
        switch (action) {
            case "create":
                handleCreate(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
                break;
        }
    }

    private void handleListWithFilters(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get filter parameters
        String supplierIdStr = request.getParameter("supplierId");
        String userIdStr = request.getParameter("userId");
        String minScoreStr = request.getParameter("minScore");
        String maxScoreStr = request.getParameter("maxScore");

        Integer supplierId = null;
        Integer userId = null;
        Integer minScore = null;
        Integer maxScore = null;

        try {
            if (supplierIdStr != null && !supplierIdStr.trim().isEmpty()) {
                supplierId = Integer.parseInt(supplierIdStr);
            }
            if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                userId = Integer.parseInt(userIdStr);
            }
            if (minScoreStr != null && !minScoreStr.trim().isEmpty()) {
                minScore = Integer.parseInt(minScoreStr);
            }
            if (maxScoreStr != null && !maxScoreStr.trim().isEmpty()) {
                maxScore = Integer.parseInt(maxScoreStr);
            }
        } catch (NumberFormatException e) {
            // Ignore invalid numbers
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

        List<SupplierRating> ratings = ratingDAO.findRatingsWithFilters(
                supplierId, userId, minScore, maxScore, page, pageSize);

        Integer totalRatings = ratingDAO.getTotalFilteredRatings(
                supplierId, userId, minScore, maxScore);
        Integer totalPages = (int) Math.ceil((double) totalRatings / pageSize);

        // Get suppliers and users for dropdown filters
        List<Supplier> suppliers = supplierDAO.getAll();
        List<User> users = userDAO.getAllUsers();

        // Set attributes for JSP
        request.setAttribute("ratings", ratings);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRatings", totalRatings);

        // Set filter values for maintaining state
        request.setAttribute("supplierIdFilter", supplierId);
        request.setAttribute("userIdFilter", userId);
        request.setAttribute("minScoreFilter", minScore);
        request.setAttribute("maxScoreFilter", maxScore);

        request.getRequestDispatcher("/purchase/supplier-rating-list.jsp").forward(request, response);
    }

    private void handleShowAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String supplierIdStr = request.getParameter("supplierId");
        
        if (supplierIdStr == null || supplierIdStr.trim().isEmpty()) {
            setToastMessage(request, "Supplier ID is required!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
            return;
        }

        try {
            Integer supplierId = Integer.parseInt(supplierIdStr);
            Supplier supplier = supplierDAO.getById(supplierId);
            
            if (supplier == null) {
                setToastMessage(request, "Supplier not found!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
                return;
            }

            // Check if user is logged in
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // Check if user has already rated this supplier
            Boolean hasRated = ratingDAO.hasUserRatedSupplier(currentUser.getUserId(), supplierId);
            if (hasRated) {
                setToastMessage(request, "You have already rated this supplier!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=supplier-ratings&supplierId=" + supplierId);
                return;
            }

            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("/purchase/supplier-rating-add.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid supplier ID!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
        }
    }

    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
            return;
        }

        try {
            Integer ratingId = Integer.parseInt(idStr);
            SupplierRating rating = ratingDAO.getById(ratingId);
            
            if (rating == null) {
                setToastMessage(request, "Rating not found!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
                return;
            }

            // Check if user is logged in and owns this rating
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            if (!rating.getUserId().equals(currentUser.getUserId())) {
                setToastMessage(request, "You can only edit your own ratings!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=my-ratings");
                return;
            }

            Supplier supplier = supplierDAO.getById(rating.getSupplierId());
            request.setAttribute("rating", rating);
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("/purchase/rating-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid rating ID!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
        }
    }

    private void handleViewRating(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
            return;
        }

        try {
            Integer ratingId = Integer.parseInt(idStr);
            SupplierRating rating = ratingDAO.getById(ratingId);
            
            if (rating == null) {
                setToastMessage(request, "Rating not found!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
                return;
            }

            Supplier supplier = supplierDAO.getById(rating.getSupplierId());
            User user = userDAO.getUserById(rating.getUserId());
            
            request.setAttribute("rating", rating);
            request.setAttribute("supplier", supplier);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/purchase/rating-view.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid rating ID!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
        }
    }

    private void handleViewSupplierRatings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String supplierIdStr = request.getParameter("supplierId");
        if (supplierIdStr == null || supplierIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
            return;
        }

        try {
            Integer supplierId = Integer.parseInt(supplierIdStr);
            Supplier supplier = supplierDAO.getById(supplierId);
            
            if (supplier == null) {
                setToastMessage(request, "Supplier not found!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
                return;
            }

            List<SupplierRating> ratings = ratingDAO.getBySupplier(supplierId);
            Double averageRating = ratingDAO.getAverageRatingForSupplier(supplierId);
            
            request.setAttribute("supplier", supplier);
            request.setAttribute("ratings", ratings);
            request.setAttribute("averageRating", averageRating);
            request.getRequestDispatcher("/purchase/supplier-ratings-view.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid supplier ID!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
        }
    }

    private void handleViewMyRatings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<SupplierRating> ratings = ratingDAO.getByUser(currentUser.getUserId());
        List<Supplier> suppliers = supplierDAO.getAll();
        
        request.setAttribute("ratings", ratings);
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("/purchase/my-supplier-ratings.jsp").forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get form parameters
        String supplierIdStr = request.getParameter("supplierId");
        String deliveryScoreStr = request.getParameter("deliveryScore");
        String qualityScoreStr = request.getParameter("qualityScore");
        String serviceScoreStr = request.getParameter("serviceScore");
        String priceScoreStr = request.getParameter("priceScore");
        String comment = request.getParameter("comment");

        try {
            Integer supplierId = Integer.parseInt(supplierIdStr);
            Integer deliveryScore = Integer.parseInt(deliveryScoreStr);
            Integer qualityScore = Integer.parseInt(qualityScoreStr);
            Integer serviceScore = Integer.parseInt(serviceScoreStr);
            Integer priceScore = Integer.parseInt(priceScoreStr);

            // Validate scores
            String validationError = validateRatingScores(deliveryScore, qualityScore, serviceScore, priceScore);
            if (validationError != null) {
                Supplier supplier = supplierDAO.getById(supplierId);
                request.setAttribute("supplier", supplier);
                request.setAttribute("errorMessage", validationError);
                preserveFormData(request, deliveryScore, qualityScore, serviceScore, priceScore, comment);
                request.getRequestDispatcher("/purchase/rating-add.jsp").forward(request, response);
                return;
            }

            // Check if user has already rated this supplier
            Boolean hasRated = ratingDAO.hasUserRatedSupplier(currentUser.getUserId(), supplierId);
            if (hasRated) {
                setToastMessage(request, "You have already rated this supplier!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=supplier-ratings&supplierId=" + supplierId);
                return;
            }

            // Create rating object
            SupplierRating rating = SupplierRating.builder()
                    .supplierId(supplierId)
                    .userId(currentUser.getUserId())
                    .deliveryScore(deliveryScore)
                    .qualityScore(qualityScore)
                    .serviceScore(serviceScore)
                    .priceScore(priceScore)
                    .comment(comment != null ? comment.trim() : null)
                    .build();

            Integer ratingId = ratingDAO.insert(rating);
            if (ratingId > 0) {
                setToastMessage(request, "Rating created successfully!", "success");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=supplier-ratings&supplierId=" + supplierId);
            } else {
                Supplier supplier = supplierDAO.getById(supplierId);
                request.setAttribute("supplier", supplier);
                request.setAttribute("errorMessage", "Failed to create rating. Please try again.");
                preserveFormData(request, deliveryScore, qualityScore, serviceScore, priceScore, comment);
                request.getRequestDispatcher("/purchase/rating-add.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid input data!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=list");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get form parameters
        String ratingIdStr = request.getParameter("ratingId");
        String deliveryScoreStr = request.getParameter("deliveryScore");
        String qualityScoreStr = request.getParameter("qualityScore");
        String serviceScoreStr = request.getParameter("serviceScore");
        String priceScoreStr = request.getParameter("priceScore");
        String comment = request.getParameter("comment");

        try {
            Integer ratingId = Integer.parseInt(ratingIdStr);
            Integer deliveryScore = Integer.parseInt(deliveryScoreStr);
            Integer qualityScore = Integer.parseInt(qualityScoreStr);
            Integer serviceScore = Integer.parseInt(serviceScoreStr);
            Integer priceScore = Integer.parseInt(priceScoreStr);

            // Get existing rating
            SupplierRating existingRating = ratingDAO.getById(ratingId);
            if (existingRating == null) {
                setToastMessage(request, "Rating not found!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=my-ratings");
                return;
            }

            // Check ownership
            if (!existingRating.getUserId().equals(currentUser.getUserId())) {
                setToastMessage(request, "You can only edit your own ratings!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=my-ratings");
                return;
            }

            // Validate scores
            String validationError = validateRatingScores(deliveryScore, qualityScore, serviceScore, priceScore);
            if (validationError != null) {
                Supplier supplier = supplierDAO.getById(existingRating.getSupplierId());
                request.setAttribute("rating", existingRating);
                request.setAttribute("supplier", supplier);
                request.setAttribute("errorMessage", validationError);
                preserveFormData(request, deliveryScore, qualityScore, serviceScore, priceScore, comment);
                request.getRequestDispatcher("/purchase/rating-edit.jsp").forward(request, response);
                return;
            }

            // Update rating object
            existingRating.setDeliveryScore(deliveryScore);
            existingRating.setQualityScore(qualityScore);
            existingRating.setServiceScore(serviceScore);
            existingRating.setPriceScore(priceScore);
            existingRating.setComment(comment != null ? comment.trim() : null);

            Boolean success = ratingDAO.update(existingRating);
            if (success) {
                setToastMessage(request, "Rating updated successfully!", "success");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=my-ratings");
            } else {
                Supplier supplier = supplierDAO.getById(existingRating.getSupplierId());
                request.setAttribute("rating", existingRating);
                request.setAttribute("supplier", supplier);
                request.setAttribute("errorMessage", "Failed to update rating. Please try again.");
                preserveFormData(request, deliveryScore, qualityScore, serviceScore, priceScore, comment);
                request.getRequestDispatcher("/purchase/rating-edit.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid input data!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=my-ratings");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            setToastMessage(request, "Rating ID is required!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=my-ratings");
            return;
        }

        try {
            Integer ratingId = Integer.parseInt(idStr);
            SupplierRating rating = ratingDAO.getById(ratingId);
            
            if (rating == null) {
                setToastMessage(request, "Rating not found!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=my-ratings");
                return;
            }

            // Check ownership
            if (!rating.getUserId().equals(currentUser.getUserId())) {
                setToastMessage(request, "You can only delete your own ratings!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=my-ratings");
                return;
            }

            Boolean success = ratingDAO.delete(ratingId);
            if (success) {
                setToastMessage(request, "Rating deleted successfully!", "success");
            } else {
                setToastMessage(request, "Failed to delete rating!", "error");
            }
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=my-ratings");
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid rating ID!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/supplier-rating?action=my-ratings");
        }
    }

    private String validateRatingScores(Integer deliveryScore, Integer qualityScore, 
                                      Integer serviceScore, Integer priceScore) {
        if (deliveryScore == null || deliveryScore < 1 || deliveryScore > 5) {
            return "Delivery score must be between 1 and 5!";
        }
        if (qualityScore == null || qualityScore < 1 || qualityScore > 5) {
            return "Quality score must be between 1 and 5!";
        }
        if (serviceScore == null || serviceScore < 1 || serviceScore > 5) {
            return "Service score must be between 1 and 5!";
        }
        if (priceScore == null || priceScore < 1 || priceScore > 5) {
            return "Price score must be between 1 and 5!";
        }
        return null;
    }

    private void preserveFormData(HttpServletRequest request, Integer deliveryScore, 
                                Integer qualityScore, Integer serviceScore, 
                                Integer priceScore, String comment) {
        request.setAttribute("deliveryScore", deliveryScore);
        request.setAttribute("qualityScore", qualityScore);
        request.setAttribute("serviceScore", serviceScore);
        request.setAttribute("priceScore", priceScore);
        request.setAttribute("comment", comment);
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", message);
        session.setAttribute("toastType", type);
    }

    @Override
    public String getServletInfo() {
        return "SupplierRatingController handles all supplier rating operations";
    }
} 