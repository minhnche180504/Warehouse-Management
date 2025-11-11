/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.customerQuote;

import dao.CustomerQuoteDAO;
import dao.UserDAO2;
import dao.CustomerDAO;
import model.CustomerQuote;
import model.CustomerQuoteItem;
import model.User;
import model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import utils.AuthorizationService;

/**
 *
 * @author nguyen
 */
@WebServlet(name="CustomerQuoteDetail", urlPatterns={"/sale/customerQuoteDetail"})
public class CustomerQuoteDetail extends HttpServlet {

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
            out.println("<title>Servlet CustomerQuoteDetail</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CustomerQuoteDetail at " + request.getContextPath () + "</h1>");
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
        String idStr = request.getParameter("id");
        if (idStr == null) {
            request.setAttribute("errorMessage", "Không tìm thấy báo giá!");
            request.getRequestDispatcher("/sale/customerQuote-viewDetail.jsp").forward(request, response);
            return;
        }
        try {
            int id = Integer.parseInt(idStr);
            CustomerQuote quote = new CustomerQuoteDAO().getCustomerQuoteById(id);
            List<CustomerQuoteItem> items = new CustomerQuoteDAO().getItemsByQuoteId(id);
            if (quote == null) {
                request.setAttribute("errorMessage", "Không tìm thấy báo giá!");
            } else {
                request.setAttribute("quote", quote);
                request.setAttribute("items", items);
                UserDAO2 userDAO = new UserDAO2();
                User creator = userDAO.getUserById(quote.getUserId());
                if (creator != null) {
                    request.setAttribute("creator", creator);
                    request.setAttribute("creatorName", creator.getFullName());
                } else {
                    request.setAttribute("creatorName", "Không xác định");
                }
                
                CustomerDAO customerDAO = new CustomerDAO();
                Customer customer = customerDAO.getCustomerById(quote.getCustomerId());
                if (customer != null) {
                    request.setAttribute("customer", customer);
                }
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi khi lấy dữ liệu báo giá!");
        }
        request.getRequestDispatcher("/sale/customerQuote-viewDetail.jsp").forward(request, response);
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
        processRequest(request, response);
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
