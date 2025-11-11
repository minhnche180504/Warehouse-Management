package controller.salesorder;

import dao.SalesOrderDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import utils.AuthorizationService;

@WebServlet("/sale/return-sales-order")
public class ReturnSalesOrderServlet extends HttpServlet {

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
            String soIdStr = request.getParameter("id");
            if (soIdStr == null || soIdStr.trim().isEmpty()) {
                session.setAttribute("error", "Sales order ID is required.");
                response.sendRedirect("sales-order-list");
                return;
            }
            
            int soId = Integer.parseInt(soIdStr);
            
            SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
            boolean updated = salesOrderDAO.updateSalesOrderToReturning(soId);
            
            if (updated) {
                session.setAttribute("success", "Sales order has been marked for return successfully.");
            } else {
                session.setAttribute("error", "Failed to update sales order status. Order may not be in delivery status.");
            }
            
            response.sendRedirect("view-sales-order-detail?id=" + soId);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid sales order ID format.");
            response.sendRedirect("sales-order-list");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred while updating the sales order.");
            response.sendRedirect("sales-order-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
