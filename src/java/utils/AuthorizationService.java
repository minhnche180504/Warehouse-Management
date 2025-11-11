package utils;

import dao.AuthorizeDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;
import model.User;

public class AuthorizationService {

    private static final AuthorizationService instance = new AuthorizationService();
    private final Map<String, String> authorizeMap = new HashMap<>();
    private final AuthorizeDAO authorizeDAO = new AuthorizeDAO();

    private AuthorizationService() {
        loadAuthorizeMap();
    }

    public static AuthorizationService getInstance() {
        return instance;
    }

    private void loadAuthorizeMap() {
        try {
            Map<String, String> tempMap = authorizeDAO.loadAuthorizeMap();
            if (tempMap != null) {
                authorizeMap.putAll(tempMap);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Map<String, String> getAuthorizeMap() {
        return authorizeMap;
    }

    public void setAuthorize(String path, String roles) {
        try {
            authorizeDAO.setAuthorize(path, roles);
            authorizeMap.put(path, roles);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean authorize(HttpServletRequest request, HttpServletResponse response) {
        String path = request.getServletPath();

        if (!authorizeMap.containsKey(path)) {
            return true; // Nếu không có cấu hình quyền thì cho truy cập
        }

        String requiredRoles = authorizeMap.get(path).toLowerCase();

        if ("guest".equalsIgnoreCase(requiredRoles) || "all user".equalsIgnoreCase(requiredRoles)) {
            return true;
        }

        // Kiểm tra đăng nhập
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            try {
                response.sendRedirect(request.getContextPath() + "/login");
                return false;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (user.getRole() == null || user.getRole().getRoleName() == null) {
            redirectTo404(request, response);
            return false;
        }

        String userRole = user.getRole().getRoleName().toLowerCase();

        String[] allowedRoles = requiredRoles.split(",");
        boolean hasPermission = false;

        for (String role : allowedRoles) {
            if (userRole.equals(role.trim().toLowerCase())) {
                hasPermission = true;
                break;
            }
        }

        if (!hasPermission) {
            redirectTo404(request, response);
            return false;
        }

        return true;
    }

    private void redirectTo404(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.getRequestDispatcher("/404.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
