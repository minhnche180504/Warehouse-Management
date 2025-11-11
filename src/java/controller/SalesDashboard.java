package controller;

import dao.SalesDashboardDAO;
import model.User;
import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.AuthorizationService;

/**
 * Sales Dashboard Controller
 * @author Nguyen Duc Thinh
 */
@WebServlet(urlPatterns = {"/sale/sales-dashboard"})
public class SalesDashboard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền truy cập
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        
        // Lấy user từ session
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");
        
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Reload user từ database để đảm bảo có thông tin warehouse mới nhất
        dao.UserDAO2 userDAO = new dao.UserDAO2();
        User user = userDAO.getUserById(sessionUser.getUserId());
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Kiểm tra xem user có được phân công vào kho nào không
        if (user.getWarehouseId() == null) {
            request.setAttribute("errorMessage", "Bạn chưa được phân công vào kho nào. Vui lòng liên hệ quản trị viên để được phân công kho làm việc.");
            request.getRequestDispatcher("/sale/SalesDashboard.jsp").forward(request, response);
            return;
        }
        
        try {
            // Lấy thông tin kho của user
            SalesDashboardDAO dao = new SalesDashboardDAO();
            Map<String, Object> warehouseInfo = dao.getWarehouseInfo(user.getWarehouseId());
            
            // Đặt thông tin vào request để hiển thị trên JSP
            request.setAttribute("warehouseInfo", warehouseInfo);
            request.setAttribute("userWarehouseId", user.getWarehouseId());
            
            // Forward đến JSP
            request.getRequestDispatcher("/sale/SalesDashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error in SalesDashboard: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dashboard. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/sale/SalesDashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Sales Dashboard Controller - Shows dashboard data for sales staff warehouse";
    }
}