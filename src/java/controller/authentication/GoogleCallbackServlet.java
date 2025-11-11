package controller.authentication;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.UserDAO2;
import model.User;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "GoogleCallbackServlet", urlPatterns = {"/google-callback"})
public class GoogleCallbackServlet extends HttpServlet {
    
    private static final String CLIENT_ID = "581314272217-kco17fruthlhvfrmc575a4c08tiv7jhq.apps.googleusercontent.com";
    // Client Secret từ Google Cloud Console
    private static final String CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET") != null 
            ? System.getenv("GOOGLE_CLIENT_SECRET") 
            : "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";
    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String USER_INFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";
    
    private UserDAO2 userDAO2;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        userDAO2 = new UserDAO2();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String code = request.getParameter("code");
        String error = request.getParameter("error");
        String errorDescription = request.getParameter("error_description");
        
        // Debug: Log tất cả parameters để kiểm tra
        System.out.println("[GoogleCallbackServlet] Received parameters:");
        System.out.println("  - code: " + code);
        System.out.println("  - error: " + error);
        System.out.println("  - error_description: " + errorDescription);
        System.out.println("  - Full query string: " + request.getQueryString());
        
        // Xử lý lỗi từ Google
        if (error != null) {
            String errorMsg = "Đăng nhập Google thất bại: " + error;
            if (errorDescription != null && !errorDescription.isEmpty()) {
                errorMsg += " - " + errorDescription;
            }
            
            // Xử lý các lỗi cụ thể
            if ("redirect_uri_mismatch".equals(error)) {
                String currentRedirectUri = buildRedirectUri(request);
                errorMsg += "\n\nVui lòng kiểm tra lại redirect URI trong Google Cloud Console.";
                errorMsg += "\n\nRedirect URI hiện tại của ứng dụng:\n" + currentRedirectUri;
                errorMsg += "\n\nRedirect URI từ request URL:\n" + request.getRequestURL().toString();
                errorMsg += "\n\nVui lòng thêm CHÍNH XÁC URI trên vào Google Cloud Console.";
                errorMsg += "\n(Lưu ý: Sau khi thêm, đợi 5-10 phút để Google cập nhật)";
            } else if ("access_denied".equals(error)) {
                errorMsg += "\n\nNgười dùng đã từ chối quyền truy cập.";
            }
            
            System.out.println("[GoogleCallbackServlet] Error: " + errorMsg);
            request.setAttribute("error", errorMsg);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        if (code == null || code.isEmpty()) {
            String errorMsg = "Không nhận được mã xác thực từ Google.";
            errorMsg += "\nCó thể do:\n";
            errorMsg += "- Redirect URI chưa được cấu hình đúng trong Google Cloud Console\n";
            errorMsg += "- Ứng dụng chưa được publish hoặc chưa thêm test user\n";
            errorMsg += "\nRedirect URI hiện tại: " + buildRedirectUri(request);
            
            System.out.println("[GoogleCallbackServlet] No code received");
            request.setAttribute("error", errorMsg);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Build redirect URI dynamically (must match the one in GoogleLoginServlet)
            String redirectUri = buildRedirectUri(request);
            
            // Debug: Log redirect URI để kiểm tra
            System.out.println("[GoogleCallbackServlet] Redirect URI: " + redirectUri);
            
            // Exchange code for access token
            String accessToken = exchangeCodeForToken(code, redirectUri);
            if (accessToken == null) {
                String errorMsg = "Không thể lấy access token từ Google.\n\n";
                errorMsg += "Có thể do:\n";
                errorMsg += "- Client Secret chưa được cấu hình đúng\n";
                errorMsg += "- Code đã hết hạn hoặc đã được sử dụng\n";
                errorMsg += "- Redirect URI không khớp với lúc gửi request\n\n";
                errorMsg += "Vui lòng kiểm tra:\n";
                errorMsg += "1. Client Secret trong GoogleCallbackServlet.java\n";
                errorMsg += "2. Log trong console để xem chi tiết lỗi";
                
                request.setAttribute("error", errorMsg);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            // Get user info from Google
            JsonObject userInfo = getUserInfoFromGoogle(accessToken);
            if (userInfo == null) {
                request.setAttribute("error", "Không thể lấy thông tin người dùng từ Google");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            String email = userInfo.get("email").getAsString();
            String firstName = userInfo.has("given_name") ? userInfo.get("given_name").getAsString() : "";
            String lastName = userInfo.has("family_name") ? userInfo.get("family_name").getAsString() : "";
            String pictureUrl = userInfo.has("picture") ? userInfo.get("picture").getAsString() : null;
            
            // Check if user exists by email
            User user = userDAO2.findUserByEmail(email);
            
            if (user == null) {
                // Không cho phép tạo user mới - chỉ cho phép email đã có trong database
                request.setAttribute("error", "Email này chưa được đăng ký trong hệ thống. "
                        + "Vui lòng liên hệ quản trị viên để được thêm vào hệ thống trước khi sử dụng Google Login.");
                System.out.println("[GoogleCallbackServlet] Access denied: Email not in database - " + email);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            if (user != null && "Active".equalsIgnoreCase(user.getStatus())) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // Redirect based on role
                redirectByRole(response, user.getRoleId());
            } else {
                request.setAttribute("error", "Tài khoản của bạn chưa được kích hoạt");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý đăng nhập Google: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Build redirect URI dynamically based on current request
     * Normalize serverName để đảm bảo consistency giữa các trình duyệt
     */
    private String buildRedirectUri(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        
        // Normalize serverName: Luôn dùng localhost thay vì 127.0.0.1 để consistency
        // Hoặc giữ nguyên nếu đã là domain/IP khác
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
        
        // Debug log - Chi tiết hơn để debug Chrome
        System.out.println("========================================");
        System.out.println("[GoogleCallbackServlet] DEBUG INFO:");
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
        
        return redirectUri;
    }
    
    private String exchangeCodeForToken(String code, String redirectUri) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();
        
        // Debug: Log thông tin (không log CLIENT_SECRET)
        System.out.println("[GoogleCallbackServlet] Exchanging code for token...");
        System.out.println("  - Redirect URI: " + redirectUri);
        System.out.println("  - Client ID: " + CLIENT_ID);
        System.out.println("  - Client Secret configured: " + (CLIENT_SECRET != null && !CLIENT_SECRET.isEmpty() && CLIENT_SECRET.length() > 10));
        
        String requestBody = "code=" + URLEncoder.encode(code, StandardCharsets.UTF_8)
                + "&client_id=" + URLEncoder.encode(CLIENT_ID, StandardCharsets.UTF_8)
                + "&client_secret=" + URLEncoder.encode(CLIENT_SECRET, StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8)
                + "&grant_type=authorization_code";
        
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(TOKEN_URL))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                .build();
        
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        
        System.out.println("[GoogleCallbackServlet] Token exchange response:");
        System.out.println("  - Status code: " + response.statusCode());
        System.out.println("  - Response body: " + response.body());
        
        if (response.statusCode() == 200) {
            try {
                JsonObject jsonResponse = gson.fromJson(response.body(), JsonObject.class);
                if (jsonResponse.has("access_token")) {
                    System.out.println("[GoogleCallbackServlet] Access token received successfully");
                    return jsonResponse.get("access_token").getAsString();
                } else {
                    System.out.println("[GoogleCallbackServlet] No access_token in response");
                    if (jsonResponse.has("error")) {
                        System.out.println("  - Error: " + jsonResponse.get("error").getAsString());
                        if (jsonResponse.has("error_description")) {
                            System.out.println("  - Error description: " + jsonResponse.get("error_description").getAsString());
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("[GoogleCallbackServlet] Error parsing response: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            // Try to parse error from response
            try {
                JsonObject errorResponse = gson.fromJson(response.body(), JsonObject.class);
                if (errorResponse.has("error")) {
                    String error = errorResponse.get("error").getAsString();
                    String errorDesc = errorResponse.has("error_description") 
                            ? errorResponse.get("error_description").getAsString() 
                            : "";
                    System.out.println("[GoogleCallbackServlet] Token exchange failed:");
                    System.out.println("  - Error: " + error);
                    System.out.println("  - Description: " + errorDesc);
                    
                    if ("invalid_client".equals(error)) {
                        System.out.println("  - HINT: Client Secret có thể chưa đúng hoặc chưa được cấu hình");
                    } else if ("invalid_grant".equals(error)) {
                        System.out.println("  - HINT: Code đã hết hạn hoặc redirect URI không khớp");
                    }
                }
            } catch (Exception e) {
                System.out.println("[GoogleCallbackServlet] Could not parse error response: " + e.getMessage());
            }
        }
        
        return null;
    }
    
    private JsonObject getUserInfoFromGoogle(String accessToken) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();
        
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(USER_INFO_URL))
                .header("Authorization", "Bearer " + accessToken)
                .GET()
                .build();
        
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() == 200) {
            return gson.fromJson(response.body(), JsonObject.class);
        }
        
        System.out.println("Get user info failed: " + response.body());
        return null;
    }
    
    private void redirectByRole(HttpServletResponse response, int roleId) throws IOException {
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
            response.sendRedirect("login?error=unsupported_role");
        }
    }
}

