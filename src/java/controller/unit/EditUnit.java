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
 * Servlet for handling unit editing
 */
@WebServlet(name = "EditUnit", urlPatterns = {"/admin/edit-unit"})
public class EditUnit extends HttpServlet {

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
                request.getRequestDispatcher("/admin/list-unit").forward(request, response);
                return;
            }
            
            int unitId = Integer.parseInt(unitIdStr);
            
            // Get unit from database
            UnitDAO unitDAO = new UnitDAO();
            Unit unit = unitDAO.getById(unitId);
            
            if (unit == null) {
                request.setAttribute("errorMessage", "Unit not found");
                request.getRequestDispatcher("/admin/list-unit").forward(request, response);
                return;
            }
            
            // Set unit in request and forward to edit page
            request.setAttribute("unit", unit);
            request.getRequestDispatcher("/admin/unit-edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid unit ID format");
            request.getRequestDispatcher("/admin/list-unit").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/admin/list-unit").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form parameters
            String unitIdStr = request.getParameter("unitId");
            String unitName = request.getParameter("unitName");
            String unitCode = request.getParameter("unitCode");
            String description = request.getParameter("description");
            String isActiveStr = request.getParameter("isActive");
            
            // Validate required fields
            if (unitIdStr == null || unitIdStr.trim().isEmpty() ||
                unitName == null || unitName.trim().isEmpty() || 
                unitCode == null || unitCode.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Unit ID, name, and code are required");
                request.getRequestDispatcher("/admin/unit-edit.jsp").forward(request, response);
                return;
            }
            
            int unitId = Integer.parseInt(unitIdStr);
            boolean isActive = "on".equals(isActiveStr) || "true".equals(isActiveStr);
            
            UnitDAO unitDAO = new UnitDAO();
            
            // Get current unit from database
            Unit existingUnit = unitDAO.getById(unitId);
            if (existingUnit == null) {
                request.setAttribute("errorMessage", "Unit not found");
                request.getRequestDispatcher("/admin/list-unit").forward(request, response);
                return;
            }
            
            // Check if name or code already exists (excluding current unit)
            if (!unitDAO.isUnitNameUnique(unitName, unitId)) {
                request.setAttribute("errorMessage", "Unit name already exists");
                request.setAttribute("unit", existingUnit);
                request.getRequestDispatcher("/admin/unit-edit.jsp").forward(request, response);
                return;
            }
            
            if (!unitDAO.isUnitCodeUnique(unitCode, unitId)) {
                request.setAttribute("errorMessage", "Unit code already exists");
                request.setAttribute("unit", existingUnit);
                request.getRequestDispatcher("/admin/unit-edit.jsp").forward(request, response);
                return;
            }
            
            // Update unit object
            existingUnit.setUnitName(unitName);
            existingUnit.setUnitCode(unitCode);
            existingUnit.setDescription(description);
            existingUnit.setIsActive(isActive);
            existingUnit.setLastUpdated(LocalDateTime.now());
            
            // Update unit
            boolean success = unitDAO.update(existingUnit);
            
            if (success) {
                // Success - set message and redirect to unit list
                request.getSession().setAttribute("successMessage", "Unit updated successfully");
                response.sendRedirect(request.getContextPath()+"/admin/list-unit");
            } else {
                // Error
                request.setAttribute("errorMessage", "Failed to update unit");
                request.setAttribute("unit", existingUnit);
                request.getRequestDispatcher("/admin/unit-edit.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid unit ID format");
            request.getRequestDispatcher("/admin/unit-edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/admin/unit-edit.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Unit Editing Servlet";
    }
}
