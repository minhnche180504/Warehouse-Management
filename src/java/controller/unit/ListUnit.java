package controller.unit;

import dao.UnitDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Unit;
import utils.AuthorizationService;

/**
 * Servlet for handling unit listing
 */
@WebServlet(name = "ListUnit", urlPatterns = {"/admin/list-unit"})
public class ListUnit extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            // Get search parameter
            String searchKeyword = request.getParameter("search");
            
            UnitDAO unitDAO = new UnitDAO();
            List<Unit> units;
            
            // Get all units (active by default)
            boolean showInactive = "true".equals(request.getParameter("showInactive"));
            if (showInactive) {
                units = unitDAO.getAll();
                request.setAttribute("showInactive", true);
            } else {
                units = unitDAO.getAllActive();
            }
            
            // Set units in request scope
            request.setAttribute("units", units);
            
            // Forward to unit list JSP
            request.getRequestDispatcher("/admin/unit-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // For form submissions (if any), just redirect to doGet
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Unit Listing Servlet";
    }
}
