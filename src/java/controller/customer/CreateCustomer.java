/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.customer;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import dao.CustomerDAO;
import utils.AuthorizationService;

/**
 *
 * @author nguyen
 */
@WebServlet(name="CreateCustomer", urlPatterns={"/sale/createCustomer"})
public class CreateCustomer extends HttpServlet {
   
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
            out.println("<title>Servlet CreateCustomer</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateCustomer at " + request.getContextPath () + "</h1>");
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
        request.getRequestDispatcher("/sale/customer-add.jsp").forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Get parameters from request
        String customerName = request.getParameter("customerName");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        
        // Validate input
        boolean isValid = true;
        String errorMessage = "";
        
        if (customerName == null || customerName.trim().isEmpty()) {
            isValid = false;
            errorMessage += "Customer name is required.<br>";
        }
        
        if (phone == null || phone.trim().isEmpty()) {
            isValid = false;
            errorMessage += "Phone number is required.<br>";
        }
        
        if (email == null || email.trim().isEmpty()) {
            isValid = false;
            errorMessage += "Email is required.<br>";
        }
        
        if (!isValid) {
            request.setAttribute("error", errorMessage);
            request.setAttribute("customerName", customerName);
            request.setAttribute("address", address);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/sale/customer-add.jsp").forward(request, response);
            return;
        }

        // Trim all input values
        customerName = customerName.trim();
        phone = phone.trim();
        email = email.trim();
        address = address != null ? address.trim() : "";

        // Check for duplicate information
        CustomerDAO customerDAO = new CustomerDAO();
        if (customerDAO.isNameExists(customerName, null)) {
            request.setAttribute("error", "Customer name already exists in the system.");
            request.setAttribute("customerName", customerName);
            request.setAttribute("address", address);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/sale/customer-add.jsp").forward(request, response);
            return;
        }

        if (customerDAO.isPhoneExists(phone, null)) {
            request.setAttribute("error", "Phone number already exists in the system.");
            request.setAttribute("customerName", customerName);
            request.setAttribute("address", address);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/sale/customer-add.jsp").forward(request, response);
            return;
        }

        if (customerDAO.isEmailExists(email, null)) {
            request.setAttribute("error", "Email already exists in the system.");
            request.setAttribute("customerName", customerName);
            request.setAttribute("address", address);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/sale/customer-add.jsp").forward(request, response);
            return;
        }

        if (!address.isEmpty() && customerDAO.isAddressExists(address, null)) {
            request.setAttribute("error", "Address already exists in the system.");
            request.setAttribute("customerName", customerName);
            request.setAttribute("address", address);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/sale/customer-add.jsp").forward(request, response);
            return;
        }
        
        // Create new Customer object
        Customer customer = new Customer();
        customer.setCustomerName(customerName);
        customer.setAddress(address);
        customer.setPhone(phone);
        customer.setEmail(email);
        customer.setIsDelete(0); // Set isDelete to 0 for new customer
        
        // Add customer to database
        boolean success = customerDAO.addCustomer(customer);
        
        // Show message based on result
        if (success) {
            request.getSession().setAttribute("success", "New customer added successfully!");
            response.sendRedirect(request.getContextPath()+"/sale/listCustomer");
        } else {
            request.setAttribute("error", "Failed to add customer. Please try again.");
            // Keep the form data
            request.setAttribute("customerName", customerName);
            request.setAttribute("address", address);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            // Forward back to the same page
            request.getRequestDispatcher("/sale/customer-add.jsp").forward(request, response);
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
