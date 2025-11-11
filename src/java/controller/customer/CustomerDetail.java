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
import dao.SalesOrderDAO;
import model.Customer;
import model.SalesOrder;
import java.util.List;
import utils.AuthorizationService;

/**
 *
 * @author nguyen
 */
@WebServlet(name = "CustomerDetail", urlPatterns = {"/sale/customerDetail"})
public class CustomerDetail extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet CustomerDetail</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CustomerDetail at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
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
                // Get customer's sales order history
                SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
                List<SalesOrder> orders = salesOrderDAO.getSalesOrdersByCustomerId(customerId);

                // Set customer information and orders to request
                request.setAttribute("customer", customer);
                request.setAttribute("orders", orders);

                // Forward to detail page
                request.getRequestDispatcher("/sale/customer-detail.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("error", "Customer not found.");
                response.sendRedirect("listCustomer");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid customer ID.");
            response.sendRedirect("listCustomer");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect("listCustomer");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Customer Detail Servlet";
    }// </editor-fold>

}
