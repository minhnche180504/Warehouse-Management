/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.SalesReport;

public class SaleReportDAO extends DBConnect {

    // Báo cáo tổng hợp theo ngày/tháng/năm
    public List<SalesReport> getSummaryReport(java.util.Date from, java.util.Date to, String reportType) {
        List<SalesReport> list = new ArrayList<>();
        String groupBySql = "FORMAT(so.[date], 'dd/MM/yyyy')";
        String selectGroup = "FORMAT(so.[date], 'dd/MM/yyyy')";

        if ("month".equals(reportType)) {
            groupBySql = "FORMAT(so.[date], 'MM/yyyy')";
            selectGroup = "FORMAT(so.[date], 'MM/yyyy')";
        } else if ("year".equals(reportType)) {
            groupBySql = "FORMAT(so.[date], 'yyyy')";
            selectGroup = "FORMAT(so.[date], 'yyyy')";
        } else {
            groupBySql = "FORMAT(so.[date], 'dd/MM/yyyy')";
            selectGroup = "FORMAT(so.[date], 'dd/MM/yyyy')";
        }

        String sql = "SELECT " + selectGroup + " as groupValue, COUNT(*) as totalOrders, SUM(so.total_amount) as totalRevenue " +
                     "FROM Sales_Order so " +
                     "WHERE so.[date] BETWEEN ? AND ? AND so.status = 'Completed' " +
                     "GROUP BY " + groupBySql + " ORDER BY MIN(so.[date]) ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(from.getTime()));
            ps.setDate(2, new java.sql.Date(to.getTime()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesReport r = new SalesReport(
                        rs.getString("groupValue"),
                        rs.getInt("totalOrders"),
                        rs.getDouble("totalRevenue")
                    );
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Báo cáo theo sản phẩm
    public List<SalesReport> getProductReport(java.util.Date from, java.util.Date to, String reportType) {
        List<SalesReport> list = new ArrayList<>();
        String sql = "SELECT p.name as groupValue, COUNT(DISTINCT so.so_id) as totalOrders, SUM(soi.quantity * soi.unit_price) as totalRevenue " +
                     "FROM Sales_Order so " +
                     "JOIN Sales_Order_Item soi ON so.so_id = soi.so_id " +
                     "JOIN Product p ON soi.product_id = p.product_id " +
                     "WHERE so.[date] BETWEEN ? AND ? AND so.status = 'Completed' " +
                     "GROUP BY p.name ORDER BY p.name ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(from.getTime()));
            ps.setDate(2, new java.sql.Date(to.getTime()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesReport r = new SalesReport(
                        rs.getString("groupValue"),
                        rs.getInt("totalOrders"),
                        rs.getDouble("totalRevenue")
                    );
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Báo cáo theo khách hàng
    public List<SalesReport> getCustomerReport(java.util.Date from, java.util.Date to, String reportType) {
        List<SalesReport> list = new ArrayList<>();
        String sql = "SELECT c.customer_name as groupValue, COUNT(so.so_id) as totalOrders, SUM(so.total_amount) as totalRevenue " +
                     "FROM Sales_Order so " +
                     "JOIN Customer c ON so.customer_id = c.customer_id " +
                     "WHERE so.[date] BETWEEN ? AND ? AND so.status = 'Completed' " +
                     "GROUP BY c.customer_name ORDER BY c.customer_name ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(from.getTime()));
            ps.setDate(2, new java.sql.Date(to.getTime()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesReport r = new SalesReport(
                        rs.getString("groupValue"),
                        rs.getInt("totalOrders"),
                        rs.getDouble("totalRevenue")
                    );
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Doanh số theo nhà cung cấp
    public List<SalesReport> getSupplierReport(java.util.Date from, java.util.Date to) {
        List<SalesReport> list = new ArrayList<>();
        String sql = "SELECT s.name as groupValue, COUNT(DISTINCT so.so_id) as totalOrders, SUM(soi.quantity * soi.unit_price) as totalRevenue " +
                     "FROM Sales_Order so " +
                     "JOIN Sales_Order_Item soi ON so.so_id = soi.so_id " +
                     "JOIN Product p ON soi.product_id = p.product_id " +
                     "JOIN Supplier s ON p.supplier_id = s.supplier_id " +
                     "WHERE so.[date] BETWEEN ? AND ? AND so.status = 'Completed' " +
                     "GROUP BY s.name ORDER BY s.name ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(from.getTime()));
            ps.setDate(2, new java.sql.Date(to.getTime()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesReport r = new SalesReport(
                        rs.getString("groupValue"),
                        rs.getInt("totalOrders"),
                        rs.getDouble("totalRevenue")
                    );
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tổng doanh thu, tổng số đơn, tổng số khách hàng
    public SalesReport getSummaryNumbers(java.util.Date from, java.util.Date to) {
        String sql = "SELECT COUNT(DISTINCT so.so_id) as totalOrders, SUM(so.total_amount) as totalRevenue, COUNT(DISTINCT so.customer_id) as totalCustomers " +
                     "FROM Sales_Order so " +
                     "WHERE so.[date] BETWEEN ? AND ? AND so.status = 'Completed'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(from.getTime()));
            ps.setDate(2, new java.sql.Date(to.getTime()));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SalesReport r = new SalesReport();
                    r.setTotalOrders(rs.getInt("totalOrders"));
                    r.setTotalRevenue(rs.getDouble("totalRevenue"));
                    r.setGroupByValue(String.valueOf(rs.getInt("totalCustomers"))); // reuse groupByValue cho tổng khách hàng
                    return r;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Top sản phẩm bán chạy (theo số lượng)
    public List<SalesReport> getTopProducts(java.util.Date from, java.util.Date to, int limit) {
        List<SalesReport> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " p.name as groupValue, SUM(soi.quantity) as totalOrders, SUM(soi.quantity * soi.unit_price) as totalRevenue " +
                     "FROM Sales_Order so " +
                     "JOIN Sales_Order_Item soi ON so.so_id = soi.so_id " +
                     "JOIN Product p ON soi.product_id = p.product_id " +
                     "WHERE so.[date] BETWEEN ? AND ? AND so.status = 'Completed' " +
                     "GROUP BY p.name ORDER BY totalOrders DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(from.getTime()));
            ps.setDate(2, new java.sql.Date(to.getTime()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesReport r = new SalesReport(
                        rs.getString("groupValue"),
                        rs.getInt("totalOrders"),
                        rs.getDouble("totalRevenue")
                    );
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Top khách hàng mua nhiều nhất (theo tổng doanh thu)
    public List<SalesReport> getTopCustomers(java.util.Date from, java.util.Date to, int limit) {
        List<SalesReport> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " c.customer_name as groupValue, COUNT(so.so_id) as totalOrders, SUM(so.total_amount) as totalRevenue " +
                     "FROM Sales_Order so " +
                     "JOIN Customer c ON so.customer_id = c.customer_id " +
                     "WHERE so.[date] BETWEEN ? AND ? AND so.status = 'Completed' " +
                     "GROUP BY c.customer_name ORDER BY totalRevenue DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(from.getTime()));
            ps.setDate(2, new java.sql.Date(to.getTime()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesReport r = new SalesReport(
                        rs.getString("groupValue"),
                        rs.getInt("totalOrders"),
                        rs.getDouble("totalRevenue")
                    );
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
