package controller.unit;

import dao.UnitDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.AuthorizationService;

/**
 * Servlet for handling unit deletion
 */
@WebServlet(name = "DeleteUnit", urlPatterns = {"/admin/delete-unit"})
public class DeleteUnit extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            // Get unit ID from request
            String unitIdStr = request.getParameter("id");
            if (unitIdStr == null || unitIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Unit ID is required");
                response.sendRedirect(request.getContextPath()+"/admin/list-unit");
                return;
            }
            
            int unitId = Integer.parseInt(unitIdStr);
            
            // Delete unit (soft delete - set is_active=false)
            UnitDAO unitDAO = new UnitDAO();
            boolean success = unitDAO.softDelete(unitId);
            
            if (success) {
                // Success - set message and redirect to unit list
                request.getSession().setAttribute("successMessage", "Unit successfully deactivated");
            } else {
                // Error
                request.getSession().setAttribute("errorMessage", "Failed to delete unit");
            }
            
            response.sendRedirect(request.getContextPath()+"/admin/list-unit");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid unit ID format");
            response.sendRedirect(request.getContextPath()+"/admin/list-unit");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath()+"/admin/list-unit");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests (if needed)
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Unit Deletion Servlet";
    }
}
