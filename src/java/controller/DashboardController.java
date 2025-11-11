package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.AuthorizationService;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
    
    UserDAO userDAO = new UserDAO();
    int userCount = userDAO.getAllUsers().size();
    request.setAttribute("userCount", userCount);
    
    // Pass current user for permission checking
    HttpSession session = request.getSession(false);
    if (session != null) {
        User currentUser = (User) session.getAttribute("user");
        request.setAttribute("currentUser", currentUser);
    }
    
    request.getRequestDispatcher("view/user-dashboard.jsp").forward(request, response);
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
    
}