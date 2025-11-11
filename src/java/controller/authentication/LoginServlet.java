package controller.authentication;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import dao.UserDAO2;
import utils.LoggerUtil;
import utils.AuditLogger;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private static final LoggerUtil.Logger logger = LoggerUtil.getLogger(LoginServlet.class);
    private UserDAO2 userDAO2;

    @Override
    public void init() throws ServletException {
        userDAO2 = new UserDAO2();
        logger.info("LoginServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember");

        // Support login with username or email
        User user = userDAO2.findUserByUsernameOrEmailAndPassword(username, password);
        if (user != null) {
            if ("Deactive".equalsIgnoreCase(user.getStatus())) {
                request.setAttribute("error", "Your account is not signed in to the system!");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            if (user.getRole() != null) {
                logger.info("User logged in - Role: {}, Username: {}", user.getRole().getRoleName(), user.getUsername());
            } else {
                logger.warn("User logged in but role is null - Username: {}", user.getUsername());
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Audit log
            String ipAddress = request.getRemoteAddr();
            AuditLogger.logLogin(user, ipAddress);

            if ("on".equals(rememberMe)) {
                Cookie cEmail = new Cookie("cEmail", username);
                Cookie cPassword = new Cookie("cPassword", password);

                cEmail.setMaxAge(60 * 60 * 24 * 30 * 6);   // 6 tháng
                cPassword.setMaxAge(60 * 60 * 24 * 30 * 6);

                cEmail.setPath(request.getContextPath());
                cPassword.setPath(request.getContextPath());

                response.addCookie(cEmail);
                response.addCookie(cPassword);
            } else {
                // Xóa cookie nếu có (khi không nhớ đăng nhập)
                Cookie cEmail = new Cookie("cEmail", "");
                Cookie cPassword = new Cookie("cPassword", "");
                cEmail.setMaxAge(0);
                cPassword.setMaxAge(0);

                cEmail.setPath(request.getContextPath());
                cPassword.setPath(request.getContextPath());

                response.addCookie(cEmail);
                response.addCookie(cPassword);
            }

            int roleId = user.getRoleId();
            if (roleId == 1) {
                response.sendRedirect("admin/admindashboard");
            } else if (roleId == 2) {
                response.sendRedirect("manager/manager-dashboard");
            } else if (roleId == 3) {
                response.sendRedirect("sale/sales-dashboard");
            } else if (roleId == 5) {
                response.sendRedirect("purchase/purchase-dashboard");
            } else if (roleId == 4) {
                response.sendRedirect("staff/warehouse-staff-dashboard");
            } else {
                request.setAttribute("error", "Vai trò không được hỗ trợ");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "LoginServlet for Warehouse Management System";
    }
}
