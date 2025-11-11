package controller.customerQuote;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.CustomerDAO;
import dao.CustomerQuoteDAO;
import dao.WarehouseDAO;
import model.Customer;
import model.CustomerQuote;
import model.CustomerQuoteItem;
import model.User;
import model.WarehouseDisplay;
import utils.AuthorizationService;
import utils.WarehouseAuthUtil;

@WebServlet(name = "QuotationToSalesOrder", urlPatterns = {"/sale/quotation-to-sales-order"})
public class QuotationToSalesOrder extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Authorization check
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String quotationIdStr = request.getParameter("quotationId");
        if (quotationIdStr == null || quotationIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Invalid quotation ID");
            response.sendRedirect(request.getContextPath() + "/sale/listCustomerQuote");
            return;
        }
        
        try {
            int quotationId = Integer.parseInt(quotationIdStr);
            
            // Debug log
            System.out.println("QuotationToSalesOrder: Processing quotation ID = " + quotationId);
            
            // Get quotation information
            CustomerQuoteDAO quoteDAO = new CustomerQuoteDAO();
            CustomerQuote quote = quoteDAO.getCustomerQuoteById(quotationId);
            
            if (quote == null) {
                System.out.println("QuotationToSalesOrder: Quotation not found for ID = " + quotationId);
                request.getSession().setAttribute("error", "Quotation not found");
                response.sendRedirect(request.getContextPath() + "/sale/listCustomerQuote");
                return;
            }
            
            System.out.println("QuotationToSalesOrder: Found quotation - Customer: " + quote.getCustomerName() + 
                             ", Total: " + quote.getTotalAmount());
            
            // Check if quotation is expired
            if (quote.getValidUntil() != null && quote.getValidUntil().before(new java.util.Date())) {
                request.getSession().setAttribute("error", "Cannot create order from expired quotation");
                response.sendRedirect(request.getContextPath() + "/sale/listCustomerQuote");
                return;
            }
            
            // Get quotation items
            List<CustomerQuoteItem> quoteItems = quoteDAO.getItemsByQuoteId(quotationId);
            
            if (quoteItems == null || quoteItems.isEmpty()) {
                System.out.println("QuotationToSalesOrder: No items found for quotation ID = " + quotationId);
                request.getSession().setAttribute("error", "Quotation has no items");
                response.sendRedirect(request.getContextPath() + "/sale/listCustomerQuote");
                return;
            }
            
            System.out.println("QuotationToSalesOrder: Found " + quoteItems.size() + " items");
            
            // Get customer information
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerById(quote.getCustomerId());
            
            if (customer == null) {
                System.out.println("QuotationToSalesOrder: Customer not found for ID = " + quote.getCustomerId());
                request.getSession().setAttribute("error", "Customer not found");
                response.sendRedirect(request.getContextPath() + "/sale/listCustomerQuote");
                return;
            }
            
            // Get all customers and warehouses for the form
            List<Customer> customers = customerDAO.getAllCustomers();
            
            WarehouseDAO warehouseDAO = new WarehouseDAO();
            List<WarehouseDisplay> allWarehouses = warehouseDAO.getAllWarehouses();
            List<WarehouseDisplay> allowedWarehouses = WarehouseAuthUtil.filterAllowedWarehouses(currentUser, allWarehouses);
            
            // Set attributes for JSP
            request.setAttribute("customers", customers);
            request.setAttribute("warehouses", allowedWarehouses);
            request.setAttribute("currentUser", currentUser);
            
            // Set quotation information
            request.setAttribute("quotation", quote);
            request.setAttribute("quotationItems", quoteItems);
            request.setAttribute("selectedCustomer", customer);
            request.setAttribute("isFromQuotation", true);
            
            // Debug: Print quotation items
            System.out.println("QuotationToSalesOrder: Quotation items:");
            for (CustomerQuoteItem item : quoteItems) {
                System.out.println("  - Product ID: " + item.getProductId() + 
                                 ", Name: " + item.getProductName() + 
                                 ", Qty: " + item.getQuantity() + 
                                 ", Unit Price: " + item.getUnitPrice() + 
                                 ", Total: " + item.getTotalPrice());
            }
            
            // Add success message
            request.setAttribute("quotationLoadMessage", 
                "Quotation Q-" + String.format("%03d", quotationId) + " loaded successfully. " +
                "Customer: " + quote.getCustomerName() + ". " +
                "Products will be auto-selected when you choose a warehouse.");
            
            System.out.println("QuotationToSalesOrder: Forwarding to sales order form");
            
            // Forward to sales order creation page
            request.getRequestDispatcher("/sale/sale-order-add.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("QuotationToSalesOrder: Invalid quotation ID format: " + quotationIdStr);
            request.getSession().setAttribute("error", "Invalid quotation ID format");
            response.sendRedirect(request.getContextPath() + "/sale/listCustomerQuote");
        } catch (Exception e) {
            System.out.println("QuotationToSalesOrder: Error processing quotation: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error processing quotation: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/sale/listCustomerQuote");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST to GET
        doGet(request, response);
    }
}