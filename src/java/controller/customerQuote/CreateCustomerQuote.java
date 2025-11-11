/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.customerQuote;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.CustomerDAO;
import dao.ProductDAO;
import dao.CustomerQuoteDAO;
import model.Customer;
import model.Product;
import model.CustomerQuote;
import model.CustomerQuoteItem;
import java.util.*;
import utils.AuthorizationService;
import model.User;

/**
 *
 * @author nguyen
 */
@WebServlet(name="CreateCustomerQuote", urlPatterns={"/sale/createCustomerQuote"})
public class CreateCustomerQuote extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CreateCustomerQuote</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateCustomerQuote at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        List<Customer> customers = new CustomerDAO().getAllCustomers();
        List<Product> products = new ProductDAO().getAll();
        request.setAttribute("customers", customers);
        request.setAttribute("products", products);
        request.getRequestDispatcher("/sale/customerQuote-add.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String customerIdStr = request.getParameter("customerId");
        String validUntilStr = request.getParameter("validUntil");
        String notes = request.getParameter("notes");
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String[] unitPrices = request.getParameterValues("unitPrice");

        if (customerIdStr == null || productIds == null || productIds.length == 0) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            doGet(request, response);
            return;
        }

         CustomerQuote quote = new CustomerQuote();
        quote.setCustomerId(Integer.parseInt(customerIdStr));
        quote.setValidUntil(java.sql.Date.valueOf(validUntilStr));
        quote.setNotes(notes);
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser != null) {
            quote.setUserId(currentUser.getUserId());
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<CustomerQuoteItem> items = new ArrayList<>();
        double totalAmount = 0.0;

        for (int i = 0; i < productIds.length; i++) {
            int productId = Integer.parseInt(productIds[i]);
            int quantity = Integer.parseInt(quantities[i]);
            double unitPrice = Double.parseDouble(unitPrices[i]);
            double itemTotal = quantity * unitPrice * 1.1;

            CustomerQuoteItem item = new CustomerQuoteItem();
            item.setProductId(productId);
            item.setQuantity(quantity);
            item.setUnitPrice(unitPrice);
            item.setTotalPrice(itemTotal);
            items.add(item);
            totalAmount += itemTotal;
        }
        quote.setTotalAmount(totalAmount);

        boolean success = new CustomerQuoteDAO().addCustomerQuote(quote, items);

        if (success) {
            response.sendRedirect(request.getContextPath()+"/sale/listCustomerQuote?success=Quotation created successfully!");
        } else {
            request.setAttribute("error", "Failed to save quotation!");
            doGet(request, response);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
