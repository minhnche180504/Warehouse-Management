package controller.salesorder;

import dao.SalesOrderDAO;
import dao.SalesOrderItemDAO;
import model.SalesOrder;
import model.SalesOrderItem;
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

@WebServlet("/sale/view-sales-order-detail")
public class ViewSalesOrderDetailServlet extends HttpServlet {

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
            
            // ENHANCED DEBUG và validation
            System.out.println("DEBUG ViewSalesOrderDetail: Received id parameter = '" + soIdStr + "'");
            System.out.println("DEBUG ViewSalesOrderDetail: Request URL = " + request.getRequestURL());
            System.out.println("DEBUG ViewSalesOrderDetail: Query String = " + request.getQueryString());
            
            // Improved validation
            if (soIdStr == null) {
                System.err.println("ERROR: Sales order ID parameter is null");
                session.setAttribute("error", "Sales order ID is missing from request.");
                response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
                return;
            }
            
            if (soIdStr.trim().isEmpty()) {
                System.err.println("ERROR: Sales order ID parameter is empty: '" + soIdStr + "'");
                session.setAttribute("error", "Sales order ID cannot be empty.");
                response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
                return;
            }
            
            // Enhanced parsing with better error messages
            int soId;
            try {
                soId = Integer.parseInt(soIdStr.trim());
                if (soId <= 0) {
                    throw new NumberFormatException("Sales order ID must be positive: " + soId);
                }
                System.out.println("DEBUG ViewSalesOrderDetail: Parsed soId = " + soId);
            } catch (NumberFormatException e) {
                System.err.println("ERROR: Invalid sales order ID format: '" + soIdStr + "', error: " + e.getMessage());
                session.setAttribute("error", "Invalid sales order ID format: '" + soIdStr + "'. Must be a positive number.");
                response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
                return;
            }
            
            // ★ WAREHOUSE FILTERING: Lấy sales order với warehouse check
            SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
            SalesOrder salesOrder = salesOrderDAO.getSalesOrderById(soId, currentUser);
            
            if (salesOrder == null) {
                System.err.println("ERROR: Sales order not found or no permission for soId = " + soId + ", user = " + currentUser.getUsername());
                session.setAttribute("error", "Sales order not found or you don't have permission to access it. (ID: " + soId + ")");
                response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
                return;
            }
            
            System.out.println("DEBUG ViewSalesOrderDetail: Found sales order = " + salesOrder.getOrderNumber());
            
            // Lấy sales order items - SỬ DỤNG DAO GỐC CỦA BẠN
            SalesOrderItemDAO itemDAO = new SalesOrderItemDAO();
            List<SalesOrderItem> items = itemDAO.getSalesOrderItemsBySoId(soId);
            salesOrder.setItems(items);
            
            System.out.println("DEBUG ViewSalesOrderDetail: Loaded " + items.size() + " items");
            
            request.setAttribute("salesOrder", salesOrder);
            request.setAttribute("currentUser", currentUser);
            
            // Check messages từ session
            String success = (String) session.getAttribute("success");
            String error = (String) session.getAttribute("error");
            
            if (success != null) {
                System.out.println("DEBUG ViewSalesOrderDetail: Success message = " + success);
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            
            if (error != null) {
                System.out.println("DEBUG ViewSalesOrderDetail: Error message = " + error);
                request.setAttribute("error", error);
                session.removeAttribute("error");
            }
            
            System.out.println("DEBUG ViewSalesOrderDetail: Forwarding to JSP");
            request.getRequestDispatcher("/sale/sale-order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("ERROR: NumberFormatException in ViewSalesOrderDetail: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Invalid sales order ID format: " + e.getMessage());
            response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
        } catch (Exception e) {
            System.err.println("ERROR: Exception in ViewSalesOrderDetail: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Error loading sales order detail: " + e.getMessage());
            response.sendRedirect(request.getContextPath()+"/sale/view-sales-order-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}