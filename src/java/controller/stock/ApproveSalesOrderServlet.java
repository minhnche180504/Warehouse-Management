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
import utils.AuthorizationService;

@WebServlet("/manager/approve-sales-order")
public class ApproveSalesOrderServlet extends HttpServlet {

    private SalesOrderDAO salesOrderDAO;

    @Override
    public void init() {
        salesOrderDAO = new SalesOrderDAO(); // Hoặc lấy từ context nếu dùng DI
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        int orderId = Integer.parseInt(request.getParameter("id"));

        boolean success = salesOrderDAO.updateOrderStatus(orderId, "Approve");

        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("message", "Order approved successfully.");
        } else {
            session.setAttribute("error", "Failed to approve order.");
        }

        response.sendRedirect(request.getContextPath()+"/manager/manage-sale-order");
    }
}
