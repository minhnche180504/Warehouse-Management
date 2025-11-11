package controller;

import dao.SalesDashboardDAO;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/sale/api/dashboard-data"})
public class SalesDashboardAPI extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Lấy user từ session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null || user.getWarehouseId() == null) {
                out.print("{\"error\": \"User not found or not assigned to warehouse\"}");
                return;
            }
            
            int warehouseId = user.getWarehouseId();
            SalesDashboardDAO dao = new SalesDashboardDAO();
            
            // Lấy các thống kê
            Map<String, Object> statistics = dao.getDashboardStatistics(warehouseId);
            Map<String, String> growthStats = dao.getGrowthStats(warehouseId);
            List<Map<String, Object>> recentOrders = dao.getRecentOrders(warehouseId, 5);
            Map<String, Object> warehouseInfo = dao.getWarehouseInfo(warehouseId);
            
            // Tạo JSON response
            StringBuilder json = new StringBuilder();
            json.append("{");
            
            // Statistics
            json.append("\"statistics\": {");
            json.append("\"totalOrders\": ").append(statistics.getOrDefault("totalOrders", 0)).append(",");
            json.append("\"completedOrders\": ").append(statistics.getOrDefault("completedOrders", 0)).append(",");
            json.append("\"pendingOrders\": ").append(statistics.getOrDefault("pendingOrders", 0)).append(",");
            json.append("\"totalRevenue\": ").append(statistics.getOrDefault("totalRevenue", 0)).append(",");
            json.append("\"ordersGrowth\": \"").append(escapeJson(growthStats.getOrDefault("ordersGrowth", "+0 from last month"))).append("\",");
            json.append("\"completedGrowth\": \"").append(escapeJson(growthStats.getOrDefault("completedGrowth", "+0 this week"))).append("\",");
            json.append("\"pendingStatus\": \"").append(escapeJson(growthStats.getOrDefault("pendingStatus", "No pending orders"))).append("\",");
            json.append("\"revenueGrowth\": \"").append(escapeJson(growthStats.getOrDefault("revenueGrowth", "+0% from last month"))).append("\"");
            json.append("},");
            
            // Recent Orders
            json.append("\"recentOrders\": [");
            for (int i = 0; i < recentOrders.size(); i++) {
                Map<String, Object> order = recentOrders.get(i);
                json.append("{");
                json.append("\"soId\": ").append(order.getOrDefault("soId", 0)).append(",");
                json.append("\"orderNumber\": \"").append(escapeJson(String.valueOf(order.getOrDefault("orderNumber", "")))).append("\",");
                json.append("\"customerName\": \"").append(escapeJson(String.valueOf(order.getOrDefault("customerName", "Unknown")))).append("\",");
                json.append("\"customerEmail\": ");
                Object email = order.get("customerEmail");
                if (email == null) {
                    json.append("null");
                } else {
                    json.append("\"").append(escapeJson(String.valueOf(email))).append("\"");
                }
                json.append(",");
                
                // Format date
                Object orderDate = order.get("orderDate");
                if (orderDate != null) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                    LocalDateTime dateTime;
                    if (orderDate instanceof Date) {
                        dateTime = ((Date) orderDate).toInstant()
                                .atZone(ZoneId.systemDefault())
                                .toLocalDateTime();
                    } else if (orderDate instanceof java.sql.Timestamp) {
                        dateTime = ((java.sql.Timestamp) orderDate).toLocalDateTime();
                    } else {
                        dateTime = LocalDateTime.now();
                    }
                    json.append("\"orderDate\": \"").append(dateTime.format(formatter)).append("\",");
                } else {
                    json.append("\"orderDate\": null,");
                }
                
                json.append("\"status\": \"").append(escapeJson(String.valueOf(order.getOrDefault("status", "")))).append("\",");
                json.append("\"totalAmount\": ").append(order.getOrDefault("totalAmount", 0));
                json.append("}");
                
                if (i < recentOrders.size() - 1) {
                    json.append(",");
                }
            }
            json.append("],");
            
            // Status Counts
            Object statusCountsObj = statistics.get("statusCounts");
            Map<String, Integer> statusCounts = new HashMap<>();
            if (statusCountsObj instanceof Map) {
                @SuppressWarnings("unchecked")
                Map<String, Object> rawMap = (Map<String, Object>) statusCountsObj;
                for (Map.Entry<String, Object> entry : rawMap.entrySet()) {
                    Object value = entry.getValue();
                    if (value instanceof Number) {
                        statusCounts.put(entry.getKey(), ((Number) value).intValue());
                    }
                }
            }
            
            json.append("\"statusCounts\": {");
            json.append("\"Order\": ").append(statusCounts.getOrDefault("Order", 0)).append(",");
            json.append("\"Delivery\": ").append(statusCounts.getOrDefault("Delivery", 0)).append(",");
            json.append("\"Completed\": ").append(statusCounts.getOrDefault("Completed", 0)).append(",");
            json.append("\"Cancelled\": ").append(statusCounts.getOrDefault("Cancelled", 0));
            json.append("},");
            
            // Warehouse Info
            json.append("\"warehouseInfo\": {");
            json.append("\"warehouseName\": \"").append(escapeJson(String.valueOf(warehouseInfo.getOrDefault("warehouseName", "Unknown Warehouse")))).append("\",");
            json.append("\"region\": \"").append(escapeJson(String.valueOf(warehouseInfo.getOrDefault("region", "Unknown Region")))).append("\"");
            json.append("}");
            
            json.append("}");
            
            out.print(json.toString());
            
        } catch (Exception e) {
            System.out.println("Error in SalesDashboardAPI: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"error\": \"Internal server error: " + escapeJson(e.getMessage()) + "\"}");
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                 .replace("\"", "\\\"")
                 .replace("\b", "\\b")
                 .replace("\f", "\\f")
                 .replace("\n", "\\n")
                 .replace("\r", "\\r")
                 .replace("\t", "\\t");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Sales Dashboard API";
    }
}