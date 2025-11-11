package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.TransferOrderItem;
import model.Unit;

public class TransferOrderItemDAO extends DBConnect {
    
    public List<TransferOrderItem> getItemsByTransferOrderId(int transferId) {
        List<TransferOrderItem> items = new ArrayList<>();
        String sql = "SELECT toi.*, p.name AS product_name, p.code AS product_code, " +
                    "u.unit_id, u.unit_name, u.unit_code " +
                    "FROM Transfer_Order_Item toi " +
                    "JOIN Product p ON toi.product_id = p.product_id " +
                    "JOIN Unit u ON p.unit_id = u.unit_id " +
                    "WHERE toi.to_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transferId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TransferOrderItem item = mapTransferOrderItem(rs);
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
    
    public TransferOrderItem getItemById(int itemId) {
        String sql = "SELECT toi.*, p.name AS product_name, p.code AS product_code, " +
                    "u.unit_id, u.unit_name, u.unit_code " +
                    "FROM Transfer_Order_Item toi " +
                    "JOIN Product p ON toi.product_id = p.product_id " +
                    "JOIN Unit u ON p.unit_id = u.unit_id " +
                    "WHERE toi.to_item_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTransferOrderItem(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public int createItem(TransferOrderItem item) {
        String sql = "INSERT INTO Transfer_Order_Item (to_id, product_id, quantity) VALUES (?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, item.getToId());
            ps.setInt(2, item.getProductId());
            ps.setInt(3, item.getQuantity());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    public boolean updateItem(TransferOrderItem item) {
        String sql = "UPDATE Transfer_Order_Item SET product_id = ?, quantity = ? WHERE to_item_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, item.getProductId());
            ps.setInt(2, item.getQuantity());
            ps.setInt(3, item.getToItemId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteItem(int itemId) {
        String sql = "DELETE FROM Transfer_Order_Item WHERE to_item_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteAllItemsByTransferId(int transferId) {
        String sql = "DELETE FROM Transfer_Order_Item WHERE to_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transferId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private TransferOrderItem mapTransferOrderItem(ResultSet rs) throws SQLException {
        TransferOrderItem item = new TransferOrderItem();
        item.setToItemId(rs.getInt("to_item_id"));
        item.setToId(rs.getInt("to_id"));
        item.setProductId(rs.getInt("product_id"));
        item.setProductName(rs.getString("product_name"));
        item.setProductCode(rs.getString("product_code"));
        item.setQuantity(rs.getInt("quantity"));
        
        Unit unit = new Unit();
        unit.setUnitId(rs.getInt("unit_id"));
        unit.setUnitName(rs.getString("unit_name"));
        unit.setUnitCode(rs.getString("unit_code"));
        item.setUnit(unit);
        
        return item;
    }
}
