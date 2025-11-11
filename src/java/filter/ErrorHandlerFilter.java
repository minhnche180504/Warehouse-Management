package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import exception.BusinessException;
import exception.DatabaseException;
import exception.ValidationException;
import utils.LoggerUtil;
import java.io.IOException;

/**
 * Global error handler filter
 * Catches exceptions and handles them appropriately
 */
@WebFilter(filterName = "ErrorHandlerFilter", urlPatterns = {"/*"})
public class ErrorHandlerFilter implements Filter {
    
    private static final LoggerUtil.Logger logger = LoggerUtil.getLogger(ErrorHandlerFilter.class);
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("ErrorHandlerFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        try {
            chain.doFilter(request, response);
        } catch (ValidationException e) {
            handleValidationException(httpRequest, httpResponse, e);
        } catch (DatabaseException e) {
            handleDatabaseException(httpRequest, httpResponse, e);
        } catch (BusinessException e) {
            handleBusinessException(httpRequest, httpResponse, e);
        } catch (Exception e) {
            handleGenericException(httpRequest, httpResponse, e);
        }
    }
    
    private void handleValidationException(HttpServletRequest request, HttpServletResponse response, 
                                         ValidationException e) throws ServletException, IOException {
        logger.warn("Validation error: {}", e.getMessage());
        request.setAttribute("error", e.getMessage());
        request.setAttribute("fieldName", e.getFieldName());
        
        // Try to forward to original page or show error page
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    private void handleDatabaseException(HttpServletRequest request, HttpServletResponse response,
                                       DatabaseException e) throws ServletException, IOException {
        logger.error("Database error: {}", e.getMessage(), e);
        request.setAttribute("error", "Database error occurred. Please try again later.");
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
    
    private void handleBusinessException(HttpServletRequest request, HttpServletResponse response,
                                       BusinessException e) throws ServletException, IOException {
        logger.error("Business error: {}", e.getMessage(), e);
        request.setAttribute("error", e.getMessage());
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
    
    private void handleGenericException(HttpServletRequest request, HttpServletResponse response,
                                      Exception e) throws ServletException, IOException {
        logger.error("Unexpected error: {}", e.getMessage(), e);
        request.setAttribute("error", "An unexpected error occurred. Please contact administrator.");
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
    
    @Override
    public void destroy() {
        logger.info("ErrorHandlerFilter destroyed");
    }
}

