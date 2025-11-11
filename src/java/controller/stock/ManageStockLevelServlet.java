/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.stock;

import dao.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import utils.AuthorizationService;

/**
 *
 * @author Nguyen Duc Thinh
 */
@WebServlet(name = "ManageStockLevelServlet", urlPatterns = {"/manager/stock-level"})
public class ManageStockLevelServlet extends HttpServlet {

    
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
            
            ProductDAO productDAO = new ProductDAO();
            List<Product> products;
            
            // If search parameter is provided, search by name
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                products = productDAO.searchByName(searchKeyword);
                request.setAttribute("searchKeyword", searchKeyword);
            } else {
                // Otherwise, get all products
                products = productDAO.getAll();
            }
            
            // Set products in request scope
            request.setAttribute("products", products);
            
            // Forward to product list JSP
            request.getRequestDispatcher("/manager/stock-level.jsp").forward(request, response);
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
        return "Product Listing Servlet";
    }

}
