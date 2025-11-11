/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.InventoryReportDAO;
import dao.ProductAlertDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.InventoryReport;
import model.ProductAlert;
import model.User;
import utils.AuthorizationService;

/**
 *
 * @author Nguyen Duc Thinh
 */
@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/manager/manager-dashboard"})
public class ManagerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }

        // Lấy thông tin người dùng từ session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra quyền truy cập của người dùng
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String roleName = getRoleName(user.getRoleId());

        // Lấy cảnh báo tồn kho từ DAO
        List<ProductAlert> recentAlerts = null;
        ProductAlertDAO productAlertDAO = new ProductAlertDAO();

        // Chỉ quản lý kho và admin mới có quyền xem cảnh báo
        if ("Warehouse Manager".equals(roleName) || "Admin".equals(roleName)) {
            if (user.getWarehouseId() != null) {
                recentAlerts = productAlertDAO.getAlertsByWarehouse(user.getWarehouseId());
            } else {
                // Nếu không có warehouseId, bạn có thể lấy tất cả cảnh báo
                recentAlerts = productAlertDAO.getAllAlerts();
            }
        }

        // Lấy thông tin tồn kho từ DAO
        InventoryReportDAO inventoryReportDAO = new InventoryReportDAO();
        List<InventoryReport> recentInventory = inventoryReportDAO.getInventoryReportWithFilters(
                null, user.getWarehouseId(), null, null, 1, 10); // Adjust pagination as needed

        // Truyền danh sách cảnh báo và thông tin tồn kho vào request
        request.setAttribute("recentAlerts", recentAlerts);
        request.setAttribute("recentInventory", recentInventory);

        // Chuyển tiếp yêu cầu đến JSP
        request.getRequestDispatcher("/manager/ManagerDashboard.jsp").forward(request, response);
    }

    private String getRoleName(int roleId) {
        switch (roleId) {
            case 1: return "Admin";
            case 2: return "Warehouse Manager";
            case 3: return "Sales Staff";
            case 4: return "Warehouse Staff";
            case 5: return "Purchase Staff";
            default: return "Unknown";
        }
    }
}
