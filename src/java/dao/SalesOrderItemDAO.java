package dao;

import java.sql.*;
import java.util.*;
import java.math.BigDecimal;
import model.SalesOrderItem;

public class SalesOrderItemDAO extends DBConnect {

    /**
     * Tạo nhiều sales order items với batch processing
     */
    public boolean createSalesOrderItems(List<SalesOrderItem> items) {
        if (items == null || items.isEmpty()) {
            return false;
        }
        
        String sql = "INSERT INTO Sales_Order_Item (so_id, product_id, quantity, unit_price, selling_price) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            // Tắt auto-commit để sử dụng transaction
            connection.setAutoCommit(false);
            
            for (SalesOrderItem item : items) {
                ps.setInt(1, item.getSoId());
                ps.setInt(2, item.getProductId());
                ps.setInt(3, item.getQuantity());
                ps.setBigDecimal(4, item.getUnitPrice());
                ps.setBigDecimal(5, item.getSellingPrice());
                ps.addBatch();
            }
            
            int[] results = ps.executeBatch();
            
            // Kiểm tra kết quả
            boolean allSuccess = true;
            for (int result : results) {
                if (result <= 0 && result != Statement.SUCCESS_NO_INFO) {
                    allSuccess = false;
                    break;
                }
            }
            
            if (allSuccess) {
                connection.commit();
                return true;
            } else {
                connection.rollback();
                return false;
            }
            
        } catch (SQLException e) {
            System.err.println("Error creating sales order items: " + e.getMessage());
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.err.println("Error rolling back transaction: " + ex.getMessage());
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                System.err.println("Error resetting auto-commit: " + e.getMessage());
            }
        }
        return false;
    }

    /**
     * Lấy sales order items theo SO ID với thông tin sản phẩm
     */
    public List<SalesOrderItem> getSalesOrderItemsBySoId(int soId) {
        List<SalesOrderItem> items = new ArrayList<>();
        String sql = "SELECT soi.so_item_id, soi.so_id, soi.product_id, soi.quantity, " +
                     "soi.unit_price, soi.selling_price, " +
                     "p.code as product_code, p.name as product_name, p.description as product_description, " +
                     "u.unit_name " +
                     "FROM Sales_Order_Item soi " +
                     "LEFT JOIN Product p ON soi.product_id = p.product_id " +
                     "LEFT JOIN Unit u ON p.unit_id = u.unit_id " +
                     "WHERE soi.so_id = ? " +
                     "ORDER BY soi.so_item_id";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, soId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesOrderItem item = mapResultSetToSalesOrderItem(rs);
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting sales order items: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Cập nhật số lượng của một order item
     */
    public boolean updateOrderItemQuantity(int soItemId, int newQuantity) {
        String sql = "UPDATE Sales_Order_Item SET quantity = ? WHERE so_item_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, soItemId);
            
            int rows = ps.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating order item quantity: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa một order item
     */
    public boolean deleteOrderItem(int soItemId) {
        String sql = "DELETE FROM Sales_Order_Item WHERE so_item_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, soItemId);
            
            int rows = ps.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting order item: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa tất cả items của một sales order
     */
    public boolean deleteItemsBySoId(int soId) {
        String sql = "DELETE FROM Sales_Order_Item WHERE so_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, soId);
            ps.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            System.err.println("Error deleting order items: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thêm một order item mới
     */
    public boolean addOrderItem(SalesOrderItem item) {
        String sql = "INSERT INTO Sales_Order_Item (so_id, product_id, quantity, unit_price, selling_price) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, item.getSoId());
            ps.setInt(2, item.getProductId());
            ps.setInt(3, item.getQuantity());
            ps.setBigDecimal(4, item.getUnitPrice());
            ps.setBigDecimal(5, item.getSellingPrice());
            
            int rows = ps.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding order item: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Map ResultSet to SalesOrderItem object
     */
    private SalesOrderItem mapResultSetToSalesOrderItem(ResultSet rs) throws SQLException {
        SalesOrderItem item = new SalesOrderItem();
        item.setSoItemId(rs.getInt("so_item_id"));
        item.setSoId(rs.getInt("so_id"));
        item.setProductId(rs.getInt("product_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        
        // Xử lý selling_price, nếu null thì dùng unit_price
        BigDecimal sellingPrice = rs.getBigDecimal("selling_price");
        if (sellingPrice == null) {
            sellingPrice = rs.getBigDecimal("unit_price");
        }
        item.setSellingPrice(sellingPrice);
        
        // Set product information
        item.setProductCode(rs.getString("product_code"));
        item.setProductName(rs.getString("product_name"));
        
        // Calculate total price
        item.calculateTotalPrice();
        
        return item;
    }

    /**
     * Lấy tổng số lượng items trong một order
     */
    public int getOrderItemCount(int soId) {
        String sql = "SELECT COUNT(*) FROM Sales_Order_Item WHERE so_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, soId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting order item count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Kiểm tra order item có tồn tại không
     */
    public boolean orderItemExists(int soId, int productId) {
        String sql = "SELECT COUNT(*) FROM Sales_Order_Item WHERE so_id = ? AND product_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, soId);
            ps.setInt(2, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking order item existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}