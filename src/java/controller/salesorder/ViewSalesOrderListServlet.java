// ============================================================================
// ViewSalesOrderListServlet.java - Fixed với warehouse filtering
// ============================================================================
package controller.salesorder;

import dao.SalesOrderDAO;
import model.SalesOrder;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import utils.AuthorizationService;

@WebServlet("/sale/view-sales-order-list")
public class ViewSalesOrderListServlet extends HttpServlet {

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
            // ★ WAREHOUSE FILTERING: Lấy sales orders theo quyền warehouse
            SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
            List<SalesOrder> orders = salesOrderDAO.getAllSalesOrders(currentUser);
            
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
            request.getRequestDispatcher("/sale/sale-order-list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading sales orders: " + e.getMessage());
            request.getRequestDispatcher("/sale/sale-order-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

