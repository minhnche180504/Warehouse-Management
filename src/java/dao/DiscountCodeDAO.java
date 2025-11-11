package dao;

import model.DiscountCode;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DiscountCodeDAO extends DBConnect {
    
    public DiscountCodeDAO() {
        super();
    }
    
    // Get all discount codes
    public List<DiscountCode> getAllDiscountCodes() {
        List<DiscountCode> codes = new ArrayList<>();
        String sql = "SELECT * FROM Discount_Code ORDER BY created_at DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                codes.add(mapResultSetToDiscountCode(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all discount codes: " + e.getMessage());
            e.printStackTrace();
        }
        
        return codes;
    }
    
    // Get active discount codes
    public List<DiscountCode> getActiveDiscountCodes() {
        List<DiscountCode> codes = new ArrayList<>();
        String sql = "SELECT * FROM Discount_Code WHERE is_active = 1 AND start_date <= GETDATE() AND end_date >= GETDATE() ORDER BY created_at DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                codes.add(mapResultSetToDiscountCode(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting active discount codes: " + e.getMessage());
            e.printStackTrace();
        }
        
        return codes;
    }
    
    // Get discount code by code
    public DiscountCode getDiscountCodeByCode(String code) {
        String sql = "SELECT * FROM Discount_Code WHERE code = ? AND is_active = 1";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, code);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDiscountCode(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting discount code by code: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Get discount code by ID
    public DiscountCode getDiscountCodeById(int id) {
        String sql = "SELECT * FROM Discount_Code WHERE discount_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDiscountCode(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting discount code by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Add discount code
    public boolean addDiscountCode(DiscountCode discountCode) {
        String sql = "INSERT INTO Discount_Code (code, name, description, discount_type, discount_value, " +
                    "min_order_amount, max_discount_amount, start_date, end_date, usage_limit, created_by) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, discountCode.getCode());
            ps.setString(2, discountCode.getName());
            ps.setString(3, discountCode.getDescription());
            ps.setString(4, discountCode.getDiscountType());
            ps.setDouble(5, discountCode.getDiscountValue());
            ps.setDouble(6, discountCode.getMinOrderAmount());
            
            if (discountCode.getMaxDiscountAmount() != null) {
                ps.setDouble(7, discountCode.getMaxDiscountAmount());
            } else {
                ps.setNull(7, Types.DECIMAL);
            }
            
            ps.setTimestamp(8, discountCode.getStartDate());
            ps.setTimestamp(9, discountCode.getEndDate());
            
            if (discountCode.getUsageLimit() != null) {
                ps.setInt(10, discountCode.getUsageLimit());
            } else {
                ps.setNull(10, Types.INTEGER);
            }
            
            ps.setInt(11, discountCode.getCreatedBy());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error adding discount code: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Update discount code
    public boolean updateDiscountCode(DiscountCode discountCode) {
        String sql = "UPDATE Discount_Code SET name = ?, description = ?, discount_type = ?, " +
                    "discount_value = ?, min_order_amount = ?, max_discount_amount = ?, " +
                    "start_date = ?, end_date = ?, usage_limit = ?, is_active = ?, updated_at = GETDATE() " +
                    "WHERE discount_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, discountCode.getName());
            ps.setString(2, discountCode.getDescription());
            ps.setString(3, discountCode.getDiscountType());
            ps.setDouble(4, discountCode.getDiscountValue());
            ps.setDouble(5, discountCode.getMinOrderAmount());
            
            if (discountCode.getMaxDiscountAmount() != null) {
                ps.setDouble(6, discountCode.getMaxDiscountAmount());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }
            
            ps.setTimestamp(7, discountCode.getStartDate());
            ps.setTimestamp(8, discountCode.getEndDate());
            
            if (discountCode.getUsageLimit() != null) {
                ps.setInt(9, discountCode.getUsageLimit());
            } else {
                ps.setNull(9, Types.INTEGER);
            }
            
            ps.setBoolean(10, discountCode.isActive());
            ps.setInt(11, discountCode.getDiscountId());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error updating discount code: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete (deactivate) discount code
    public boolean deleteDiscountCode(int id) {
        String sql = "UPDATE Discount_Code SET is_active = 0 WHERE discount_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error deleting discount code: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Increment used count
    public boolean incrementUsedCount(int discountId) {
        String sql = "UPDATE Discount_Code SET used_count = used_count + 1 WHERE discount_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, discountId);
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error incrementing used count: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Check if code exists
    public boolean codeExists(String code) {
        String sql = "SELECT COUNT(*) FROM Discount_Code WHERE code = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, code);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error checking if code exists: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Map ResultSet to DiscountCode object
    private DiscountCode mapResultSetToDiscountCode(ResultSet rs) throws SQLException {
        DiscountCode code = new DiscountCode();
        code.setDiscountId(rs.getInt("discount_id"));
        code.setCode(rs.getString("code"));
        code.setName(rs.getString("name"));
        code.setDescription(rs.getString("description"));
        code.setDiscountType(rs.getString("discount_type"));
        code.setDiscountValue(rs.getDouble("discount_value"));
        code.setMinOrderAmount(rs.getDouble("min_order_amount"));
        
        Double maxDiscount = rs.getObject("max_discount_amount", Double.class);
        code.setMaxDiscountAmount(maxDiscount);
        
        code.setStartDate(rs.getTimestamp("start_date"));
        code.setEndDate(rs.getTimestamp("end_date"));
        
        Integer usageLimit = rs.getObject("usage_limit", Integer.class);
        code.setUsageLimit(usageLimit);
        
        code.setUsedCount(rs.getInt("used_count"));
        code.setActive(rs.getBoolean("is_active"));
        code.setCreatedBy(rs.getInt("created_by"));
        code.setCreatedAt(rs.getTimestamp("created_at"));
        code.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return code;
    }
}