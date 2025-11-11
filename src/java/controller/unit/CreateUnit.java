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
 * Servlet for handling unit creation
 */
@WebServlet(name = "CreateUnit", urlPatterns = {"/admin/create-unit"})
public class CreateUnit extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        // Forward to the unit creation form
        request.getRequestDispatcher("/admin/unit-add.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form parameters
            String unitName = request.getParameter("unitName");
            String unitCode = request.getParameter("unitCode");
            String description = request.getParameter("description");
            
            // Validate required fields
            if (unitName == null || unitName.trim().isEmpty() || 
                unitCode == null || unitCode.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Unit name and code are required");
                request.getRequestDispatcher("/admin/unit-add.jsp").forward(request, response);
                return;
            }
            
            UnitDAO unitDAO = new UnitDAO();
            
            // Check if name or code already exists
            if (!unitDAO.isUnitNameUnique(unitName, null)) {
                request.setAttribute("errorMessage", "Unit name already exists");
                request.getRequestDispatcher("/admin/unit-add.jsp").forward(request, response);
                return;
            }
            
            if (!unitDAO.isUnitCodeUnique(unitCode, null)) {
                request.setAttribute("errorMessage", "Unit code already exists");
                request.getRequestDispatcher("/admin/unit-add.jsp").forward(request, response);
                return;
            }
            
            // Create a new unit object
            Unit unit = new Unit();
            unit.setUnitName(unitName);
            unit.setUnitCode(unitCode);
            unit.setDescription(description);
            unit.setIsActive(true);
            unit.setCreatedAt(LocalDateTime.now());
            unit.setLastUpdated(LocalDateTime.now());
            
            // Create unit
            int unitId = unitDAO.create(unit);
            
            if (unitId > 0) {
                // Success - set message and redirect to unit list
                request.getSession().setAttribute("successMessage", "Unit created successfully");
                response.sendRedirect(request.getContextPath()+"/admin/list-unit");
            } else {
                // Error
                request.setAttribute("errorMessage", "Failed to create unit");
                request.getRequestDispatcher("/admin/unit-add.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/admin/unit-add.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Unit Creation Servlet";
    }
}
