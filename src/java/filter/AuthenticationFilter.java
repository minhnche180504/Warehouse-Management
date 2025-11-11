//package filter;
//
//import java.io.IOException;
//import java.util.Arrays;
//import java.util.List;
//import jakarta.servlet.Filter;
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.FilterConfig;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.ServletRequest;
//import jakarta.servlet.ServletResponse;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
///**
// * Authentication Filter - Bảo vệ toàn bộ ứng dụng
// * Chỉ cho phép user đã login truy cập các resource được bảo vệ
// */
//@WebFilter("/*")
//public class AuthenticationFilter implements Filter {
//
//    // Danh sách các path không cần authentication
//    private static final List<String> WHITELIST_PATHS = Arrays.asList(
//        "/login", "/logout", "/", "/index.jsp", "/forgotpass"
//    );
//    
//    private static final List<String> WHITELIST_PREFIXES = Arrays.asList(
//        "/css/", "/js/", "/img/", "/uploads/"
//    );
//
//    @Override
//    public void init(FilterConfig filterConfig) throws ServletException {
//        System.out.println("AuthenticationFilter initialized");
//    }
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//        
//        HttpServletRequest httpRequest = (HttpServletRequest) request;
//        HttpServletResponse httpResponse = (HttpServletResponse) response;
//        
//        String path = getPath(httpRequest);
//        
//        // Check if path is in whitelist
//        if (isWhitelisted(path)) {
//            chain.doFilter(request, response);
//            return;
//        }
//        
//        // Check authentication
//        if (isAuthenticated(httpRequest)) {
//            chain.doFilter(request, response);
//        } else {
//            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
//        }
//    }
//
//    @Override
//    public void destroy() {
//        System.out.println("AuthenticationFilter destroyed");
//    }
//    
//    /**
//     * Lấy path từ request (loại bỏ context path)
//     */
//    private String getPath(HttpServletRequest request) {
//        String requestURI = request.getRequestURI();
//        String contextPath = request.getContextPath();
//        return requestURI.substring(contextPath.length());
//    }
//    
//    /**
//     * Kiểm tra path có trong whitelist không
//     */
//    private boolean isWhitelisted(String path) {
//        // Check exact paths
//        if (WHITELIST_PATHS.contains(path)) {
//            return true;
//        }
//        
//        // Check prefixes (static resources)
//        return WHITELIST_PREFIXES.stream().anyMatch(path::startsWith);
//    }
//    
//    /**
//     * Kiểm tra user đã login chưa
//     */
//    private boolean isAuthenticated(HttpServletRequest request) {
//        HttpSession session = request.getSession(false);
//        return session != null && session.getAttribute("user") != null;
//    }
//}