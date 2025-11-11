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
import dao.CustomerDAO;
import model.Customer;
import utils.AuthorizationService;

/**
 *
 * @author nguyen
 */
@WebServlet(name="UpdateCustomer", urlPatterns={"/sale/updateCustomer"})
public class UpdateCustomer extends HttpServlet {
   
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
            out.println("<title>Servlet UpdateCustomer</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateCustomer at " + request.getContextPath () + "</h1>");
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
        try {
            // Get customer ID from request
            int customerId = Integer.parseInt(request.getParameter("id"));
            
            // Get customer information
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerById(customerId);
            
            if (customer != null) {
                // Set customer information to request
                request.setAttribute("customer", customer);
                // Forward to update page
                request.getRequestDispatcher("/sale/customer-edit.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("error", "Customer not found.");
                response.sendRedirect(request.getContextPath()+"/sale/listCustomer");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid customer ID.");
            response.sendRedirect(request.getContextPath()+"/sale/listCustomer");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath()+"/sale/listCustomer");
        }
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
        try {
            // Get customer information from form
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String customerName = request.getParameter("customerName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");

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
                request.setAttribute("customer", new Customer(customerId, customerName, address, phone, email, 0));
                request.getRequestDispatcher("/sale/customer-edit.jsp").forward(request, response);
                return;
            }

            // Check for duplicate information
            CustomerDAO customerDAO = new CustomerDAO();
            if (customerDAO.isNameExists(customerName, customerId)) {
                request.setAttribute("error", "Customer name already exists in the system.");
                request.setAttribute("customer", new Customer(customerId, customerName, address, phone, email, 0));
                request.getRequestDispatcher("/sale/customer-edit.jsp").forward(request, response);
                return;
            }

            if (customerDAO.isPhoneExists(phone, customerId)) {
                request.setAttribute("error", "Phone number already exists in the system.");
                request.setAttribute("customer", new Customer(customerId, customerName, address, phone, email, 0));
                request.getRequestDispatcher("/sale/customer-edit.jsp").forward(request, response);
                return;
            }
            
            if (customerDAO.isEmailExists(email, customerId)) {
                request.setAttribute("error", "Email already exists in the system.");
                request.setAttribute("customer", new Customer(customerId, customerName, address, phone, email, 0));
                request.getRequestDispatcher("/sale/customer-edit.jsp").forward(request, response);
                return;
            }

            if (!address.isEmpty() && customerDAO.isAddressExists(address, customerId)) {
                request.setAttribute("error", "Address already exists in the system.");
                request.setAttribute("customer", new Customer(customerId, customerName, address, phone, email, 0));
                request.getRequestDispatcher("/sale/customer-edit.jsp").forward(request, response);
                return;
            }

            // Create customer object
            Customer customer = new Customer();
            customer.setCustomerId(customerId);
            customer.setCustomerName(customerName);
            customer.setPhone(phone);
            customer.setEmail(email);
            customer.setAddress(address);
            customer.setIsDelete(0);

            // Update customer
            boolean success = customerDAO.updateCustomer(customer);
            
            if (success) {
                request.getSession().setAttribute("success", "Customer information updated successfully!");
                response.sendRedirect(request.getContextPath()+"/sale/listCustomer");
            } else {
                request.setAttribute("error", "Failed to update customer information. Please try again.");
                request.setAttribute("customer", customer);
                request.getRequestDispatcher("/sale/customer-edit.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid customer ID.");
            response.sendRedirect(request.getContextPath()+"/sale/listCustomer");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath()+"/sale/listCustomer");
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
