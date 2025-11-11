package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SalesDashboardDAO extends DBConnect {
    
    // Lấy thống kê tổng quan cho sales staff theo warehouse
    public Map<String, Object> getDashboardStatistics(int warehouseId) {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            // Tổng số đơn hàng
            String totalOrdersQuery = "SELECT COUNT(*) as total FROM Sales_Order WHERE warehouse_id = ?";
            PreparedStatement ps = connection.prepareStatement(totalOrdersQuery);
            ps.setInt(1, warehouseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("totalOrders", rs.getInt("total"));
            }
            
            // Đơn hàng hoàn thành
            String completedQuery = "SELECT COUNT(*) as completed FROM Sales_Order WHERE warehouse_id = ? AND status = 'Completed'";
            ps = connection.prepareStatement(completedQuery);
            ps.setInt(1, warehouseId);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("completedOrders", rs.getInt("completed"));
            }
            
            // Đơn hàng đang chờ (Order + Delivery)
            String pendingQuery = "SELECT COUNT(*) as pending FROM Sales_Order WHERE warehouse_id = ? AND status IN ('Order', 'Delivery')";
            ps = connection.prepareStatement(pendingQuery);
            ps.setInt(1, warehouseId);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("pendingOrders", rs.getInt("pending"));
            }
            
            // Tổng doanh thu từ đơn hàng hoàn thành
            String revenueQuery = "SELECT ISNULL(SUM(total_amount), 0) as revenue FROM Sales_Order WHERE warehouse_id = ? AND status = 'Completed'";
            ps = connection.prepareStatement(revenueQuery);
            ps.setInt(1, warehouseId);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("totalRevenue", rs.getLong("revenue"));
            }
            
            // Thống kê theo trạng thái
            Map<String, Integer> statusCounts = new HashMap<>();
            String statusQuery = "SELECT status, COUNT(*) as count FROM Sales_Order WHERE warehouse_id = ? GROUP BY status";
            ps = connection.prepareStatement(statusQuery);
            ps.setInt(1, warehouseId);
            rs = ps.executeQuery();
            while (rs.next()) {
                statusCounts.put(rs.getString("status"), rs.getInt("count"));
            }
            stats.put("statusCounts", statusCounts);
            
        } catch (SQLException e) {
            System.out.println("Error getting dashboard statistics: " + e.getMessage());
        }
        
        return stats;
    }
    
    // Lấy danh sách đơn hàng gần đây
    public List<Map<String, Object>> getRecentOrders(int warehouseId, int limit) {
        List<Map<String, Object>> orders = new ArrayList<>();
        
        try {
            String query = "SELECT TOP (?) so.so_id, so.order_number, so.date, so.status, so.total_amount, " +
                          "c.customer_name, c.email " +
                          "FROM Sales_Order so " +
                          "LEFT JOIN Customer c ON so.customer_id = c.customer_id " +
                          "WHERE so.warehouse_id = ? " +
                          "ORDER BY so.date DESC";
            
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, limit);
            ps.setInt(2, warehouseId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("soId", rs.getInt("so_id"));
                order.put("orderNumber", rs.getString("order_number"));
                order.put("orderDate", rs.getTimestamp("date"));
                order.put("status", rs.getString("status"));
                order.put("totalAmount", rs.getLong("total_amount"));
                order.put("customerName", rs.getString("customer_name"));
                order.put("customerEmail", rs.getString("email"));
                orders.add(order);
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting recent orders: " + e.getMessage());
        }
        
        return orders;
    }
    
    // Lấy thông tin kho của user
    public Map<String, Object> getWarehouseInfo(int warehouseId) {
        Map<String, Object> warehouseInfo = new HashMap<>();
        
        try {
            String query = "SELECT warehouse_name, region FROM Warehouse WHERE warehouse_id = ?";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, warehouseId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                warehouseInfo.put("warehouseName", rs.getString("warehouse_name"));
                warehouseInfo.put("region", rs.getString("region"));
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting warehouse info: " + e.getMessage());
        }
        
        return warehouseInfo;
    }
    
    // Lấy thống kê so sánh với tháng trước
    public Map<String, String> getGrowthStats(int warehouseId) {
        Map<String, String> growth = new HashMap<>();
        
        try {
            // So sánh đơn hàng tháng này vs tháng trước
            String ordersGrowthQuery = 
                "SELECT " +
                "(SELECT COUNT(*) FROM Sales_Order WHERE warehouse_id = ? AND MONTH(date) = MONTH(GETDATE()) AND YEAR(date) = YEAR(GETDATE())) as thisMonth, " +
                "(SELECT COUNT(*) FROM Sales_Order WHERE warehouse_id = ? AND MONTH(date) = MONTH(DATEADD(MONTH, -1, GETDATE())) AND YEAR(date) = YEAR(DATEADD(MONTH, -1, GETDATE()))) as lastMonth";
            
            PreparedStatement ps = connection.prepareStatement(ordersGrowthQuery);
            ps.setInt(1, warehouseId);
            ps.setInt(2, warehouseId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int thisMonth = rs.getInt("thisMonth");
                int lastMonth = rs.getInt("lastMonth");
                int diff = thisMonth - lastMonth;
                String sign = diff >= 0 ? "+" : "";
                growth.put("ordersGrowth", sign + diff + " from last month");
            }
            
            // So sánh doanh thu
            String revenueGrowthQuery = 
                "SELECT " +
                "(SELECT ISNULL(SUM(total_amount), 0) FROM Sales_Order WHERE warehouse_id = ? AND status = 'Completed' AND MONTH(date) = MONTH(GETDATE()) AND YEAR(date) = YEAR(GETDATE())) as thisMonth, " +
                "(SELECT ISNULL(SUM(total_amount), 0) FROM Sales_Order WHERE warehouse_id = ? AND status = 'Completed' AND MONTH(date) = MONTH(DATEADD(MONTH, -1, GETDATE())) AND YEAR(date) = YEAR(DATEADD(MONTH, -1, GETDATE()))) as lastMonth";
            
            ps = connection.prepareStatement(revenueGrowthQuery);
            ps.setInt(1, warehouseId);
            ps.setInt(2, warehouseId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                long thisMonth = rs.getLong("thisMonth");
                long lastMonth = rs.getLong("lastMonth");
                if (lastMonth > 0) {
                    double percent = ((double)(thisMonth - lastMonth) / lastMonth) * 100;
                    String sign = percent >= 0 ? "+" : "";
                    growth.put("revenueGrowth", String.format("%s%.1f%% from last month", sign, percent));
                } else {
                    growth.put("revenueGrowth", "No data for comparison");
                }
            }
            
            // Trạng thái đơn hàng đang chờ
            String pendingStatusQuery = "SELECT COUNT(*) as pending FROM Sales_Order WHERE warehouse_id = ? AND status IN ('Order', 'Delivery')";
            ps = connection.prepareStatement(pendingStatusQuery);
            ps.setInt(1, warehouseId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                int pending = rs.getInt("pending");
                if (pending == 0) {
                    growth.put("pendingStatus", "All orders processed");
                } else {
                    growth.put("pendingStatus", pending + " awaiting processing");
                }
            }
            
            // Hoàn thành tuần này
            String completedWeekQuery = "SELECT COUNT(*) as completed FROM Sales_Order WHERE warehouse_id = ? AND status = 'Completed' AND DATEPART(WEEK, date) = DATEPART(WEEK, GETDATE()) AND YEAR(date) = YEAR(GETDATE())";
            ps = connection.prepareStatement(completedWeekQuery);
            ps.setInt(1, warehouseId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                int completed = rs.getInt("completed");
                growth.put("completedGrowth", "+" + completed + " this week");
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting growth stats: " + e.getMessage());
        }
        
        return growth;
    }
}