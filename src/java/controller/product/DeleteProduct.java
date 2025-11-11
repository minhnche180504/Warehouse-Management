package controller.product;

import dao.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.AuthorizationService;

/**
 * Servlet for handling product deletion
 */
@WebServlet(name = "DeleteProduct", urlPatterns = {"/admin/delete-product"})
public class DeleteProduct extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {            // Get product ID from request
            String productIdStr = request.getParameter("id");
            
            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath()+"/admin/list-product");
                return;
            }
            
            int productId;
            try {
                productId = Integer.parseInt(productIdStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath()+"/admin/list-product");
                return;
            }
            
            // Delete product
            ProductDAO productDAO = new ProductDAO();
            boolean success = productDAO.delete(productId);            // Redirect to product list with appropriate message
            if (success) {
                response.sendRedirect(request.getContextPath()+"/admin/list-product?msg=deleted");
            } else {
                response.sendRedirect(request.getContextPath()+"/admin/list-product?error=delete_failed");
            }
        } catch (Exception e) {            System.err.println("Error deleting product: " + e.getMessage());
            response.sendRedirect(request.getContextPath()+"/admin/list-product.jsp?error=exception");
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
        return "Product Deletion Servlet";
    }
}