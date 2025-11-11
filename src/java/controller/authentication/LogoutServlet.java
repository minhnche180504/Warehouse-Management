package controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import utils.LoggerUtil;
import utils.AuditLogger;
import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {
    
    private static final LoggerUtil.Logger logger = LoggerUtil.getLogger(LogoutServlet.class);
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            User user = (User) session.getAttribute("user");
            
            if (user != null) {
                // Audit log
                String ipAddress = request.getRemoteAddr();
                AuditLogger.logLogout(user, ipAddress);
                logger.info("User logged out: {} (ID: {})", user.getUsername(), user.getUserId());
            }
            
            // Invalidate session
            session.invalidate();
            logger.debug("Session invalidated");
        }
        
        // Redirect to login
        response.sendRedirect(request.getContextPath() + "/login");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
