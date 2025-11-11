/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.stock;

import dao.SalesOrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.SalesOrder;
import model.User;
import utils.AuthorizationService;

/**
 *
 * @author Nguyen Duc Thinh
 */
@WebServlet(name = "ManageSaleOrder", urlPatterns = {"/manager/manage-sale-order"})
public class ManageSaleOrder extends HttpServlet {

     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Lấy sales orders từ database
            SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
            List<SalesOrder> orders = salesOrderDAO.getAllSalesOrders();
            
            request.setAttribute("orders", orders);
            
            // Check messages từ session
            String success = (String) session.getAttribute("success");
            String error = (String) session.getAttribute("error");
            
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            
            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("error");
            }

            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/manager/manage-sale-order.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading sales orders: " + e.getMessage());
            request.getRequestDispatcher("/manager/manage-sale-order.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
