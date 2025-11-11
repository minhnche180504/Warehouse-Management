package controller.authentication;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "GoogleLoginServlet", urlPatterns = {"/google-login"})
public class GoogleLoginServlet extends HttpServlet {
    
    private static final String CLIENT_ID = "581314272217-kco17fruthlhvfrmc575a4c08tiv7jhq.apps.googleusercontent.com";
    private static final String SCOPE = "openid email profile";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Build redirect URI dynamically based on current request
        String scheme = request.getScheme(); // http or https
        String serverName = request.getServerName(); // localhost or domain
        int serverPort = request.getServerPort(); // 9999 or other
        String contextPath = request.getContextPath(); // /Warehouse or empty
        
        // Normalize serverName: Luôn dùng localhost thay vì 127.0.0.1 để consistency
        // Đảm bảo Chrome và Cốc Cốc đều dùng cùng một redirect URI
        String normalizedServerName = serverName;
        if ("127.0.0.1".equals(serverName) || "::1".equals(serverName)) {
            // Nếu là IP, chuyển về localhost để phù hợp với Google Cloud Console
            normalizedServerName = "localhost";
        }
        
        String redirectUri = scheme + "://" + normalizedServerName;
        if ((scheme.equals("http") && serverPort != 80) || (scheme.equals("https") && serverPort != 443)) {
            redirectUri += ":" + serverPort;
        }
        redirectUri += contextPath + "/google-callback";
        
        // Debug: Log redirect URI để kiểm tra - Chi tiết hơn để debug Chrome
        System.out.println("========================================");
        System.out.println("[GoogleLoginServlet] DEBUG INFO:");
        System.out.println("  - Request Method: " + request.getMethod());
        System.out.println("  - Request Scheme: " + scheme);
        System.out.println("  - Original serverName: " + serverName);
        System.out.println("  - Normalized serverName: " + normalizedServerName);
        System.out.println("  - Server Port: " + serverPort);
        System.out.println("  - Context Path: " + contextPath);
        System.out.println("  - Redirect URI: " + redirectUri);
        System.out.println("  - Full request URL: " + request.getRequestURL().toString());
        System.out.println("  - Request URI: " + request.getRequestURI());
        System.out.println("  - Query String: " + request.getQueryString());
        System.out.println("  - User-Agent: " + request.getHeader("User-Agent"));
        System.out.println("========================================");
        
        // Build Google OAuth URL
        String authUrl = "https://accounts.google.com/o/oauth2/v2/auth?"
                + "client_id=" + CLIENT_ID
                + "&redirect_uri=" + java.net.URLEncoder.encode(redirectUri, "UTF-8")
                + "&response_type=code"
                + "&scope=" + java.net.URLEncoder.encode(SCOPE, "UTF-8")
                + "&access_type=offline"
                + "&prompt=consent";
        
        // Redirect to Google OAuth
        response.sendRedirect(authUrl);
    }
}

