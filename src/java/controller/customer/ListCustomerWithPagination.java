package controller.customer;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.CustomerDAO;
import utils.AuthorizationService;
import utils.LoggerUtil;
import utils.PaginationUtil;
import java.util.List;
import model.Customer;

/**
 * Example of ListCustomer with pagination support
 * This shows how to implement pagination in list pages
 */
@WebServlet(name="ListCustomerWithPagination", urlPatterns={"/sale/listCustomerPaginated"})
public class ListCustomerWithPagination extends HttpServlet {
    
    private static final LoggerUtil.Logger logger = LoggerUtil.getLogger(ListCustomerWithPagination.class);
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Get pagination parameters
            int page = PaginationUtil.normalizePage(
                request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1
            );
            int pageSize = PaginationUtil.normalizePageSize(
                request.getParameter("pageSize") != null ? Integer.parseInt(request.getParameter("pageSize")) : PaginationUtil.getDefaultPageSize()
            );
            
            // Get search term
            String searchTerm = request.getParameter("search");
            
            CustomerDAO customerDAO = new CustomerDAO();
            
            // Get total count (for pagination)
            int totalRecords;
            List<Customer> customers;
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                // If searching, get search results with pagination
                customers = customerDAO.searchCustomers(searchTerm.trim(), page, pageSize);
                totalRecords = customerDAO.getSearchCount(searchTerm.trim());
                request.setAttribute("searchTerm", searchTerm.trim());
            } else {
                // Get all customers with pagination
                customers = customerDAO.getAllCustomers(page, pageSize);
                totalRecords = customerDAO.getTotalCount();
            }
            
            // Calculate pagination info
            PaginationUtil.PaginationInfo paginationInfo = 
                new PaginationUtil.PaginationInfo(page, pageSize, totalRecords);
            
            // Set attributes
            request.setAttribute("customers", customers);
            request.setAttribute("paginationInfo", paginationInfo);
            
            // Check for success message
            String successMessage = (String) request.getSession().getAttribute("success");
            if (successMessage != null) {
                request.setAttribute("success", successMessage);
                request.getSession().removeAttribute("success");
            }
            
            logger.info("Displaying customers - Page: {}, Total: {}", page, totalRecords);
            request.getRequestDispatcher("/sale/customer-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error loading customer data", e);
            request.setAttribute("error", "Error loading customer data: " + e.getMessage());
            request.getRequestDispatcher("/sale/customer-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Customer List with Pagination";
    }
}

