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
import java.util.List;
import model.Customer;
import utils.AuthorizationService;

/**
 *
 * @author nguyen
 */
@WebServlet(name="ListCustomer", urlPatterns={"/sale/listCustomer"})
public class ListCustomer extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
        // doGet chỉ dùng để lấy và hiển thị dữ liệu (theo chuẩn RESTful)
        response.setContentType("text/html;charset=UTF-8");
        try {
            // Check for success message in session
            String successMessage = (String) request.getSession().getAttribute("success");
            if (successMessage != null) {
                request.setAttribute("success", successMessage);
                request.getSession().removeAttribute("success"); // Remove from session after displaying
            }

            CustomerDAO customerDAO = new CustomerDAO();
            List<Customer> customers;
            // Lấy tham số tìm kiếm (nếu có)
            String searchTerm = request.getParameter("search");
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                customers = customerDAO.searchCustomers(searchTerm.trim());
                request.setAttribute("searchTerm", searchTerm.trim());
            } else {
                customers = customerDAO.getAllCustomers();
            }
            request.setAttribute("customers", customers);
            request.getRequestDispatcher("/sale/customer-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading customer data: " + e.getMessage());
            request.getRequestDispatcher("/sale/customer-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // doPost dùng để xử lý các thao tác làm thay đổi dữ liệu (thêm, sửa, xóa)
        // Ví dụ: thêm, sửa, xóa khách hàng (tùy vào tham số action hoặc url mapping)
        // Hiện tại, nếu chỉ có tìm kiếm thì có thể forward về doGet hoặc xử lý riêng nếu cần
        doGet(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
