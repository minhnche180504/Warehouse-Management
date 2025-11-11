package controller.unit;

import dao.UnitDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Unit;
import utils.AuthorizationService;

/**
 * Servlet for handling unit restoration (reactivation)
 */
@WebServlet(name = "RestoreUnit", urlPatterns = {""})
public class RestoreUnit extends HttpServlet {

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
            
            // Get unit from database
            UnitDAO unitDAO = new UnitDAO();
            Unit unit = unitDAO.getById(unitId);
            
            if (unit == null) {
                request.getSession().setAttribute("errorMessage", "Unit not found");
                response.sendRedirect(request.getContextPath()+"/admin/list-unit");
                return;
            }
            
            // Reactivate the unit
            unit.setIsActive(true);
            unit.setLastUpdated(LocalDateTime.now());
            
            boolean success = unitDAO.update(unit);
            
            if (success) {
                // Success - set message and redirect to unit list
                request.getSession().setAttribute("successMessage", "Unit successfully reactivated");
            } else {
                // Error
                request.getSession().setAttribute("errorMessage", "Failed to reactivate unit");
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
        return "Unit Restoration Servlet";
    }
}
