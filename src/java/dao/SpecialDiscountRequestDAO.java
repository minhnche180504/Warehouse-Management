package dao;

import model.SpecialDiscountRequest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SpecialDiscountRequestDAO extends DBConnect {
    
    public SpecialDiscountRequestDAO() {
        super();
    }
    
    // Get all special discount requests
    public List<SpecialDiscountRequest> getAllRequests() {
        List<SpecialDiscountRequest> requests = new ArrayList<>();
        String sql = "SELECT sdr.*, c.customer_name, " +
                    "u1.first_name + ' ' + u1.last_name as requested_by_name, " +
                    "u2.first_name + ' ' + u2.last_name as approved_by_name " +
                    "FROM Special_Discount_Request sdr " +
                    "INNER JOIN Customer c ON sdr.customer_id = c.customer_id " +
                    "INNER JOIN [User] u1 ON sdr.requested_by = u1.user_id " +
                    "LEFT JOIN [User] u2 ON sdr.approved_by = u2.user_id " +
                    "ORDER BY sdr.created_at DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                requests.add(mapResultSetToSpecialDiscountRequest(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all special discount requests: " + e.getMessage());
            e.printStackTrace();
        }
        
        return requests;
    }
    
    // Get pending requests
    public List<SpecialDiscountRequest> getPendingRequests() {
        List<SpecialDiscountRequest> requests = new ArrayList<>();
        String sql = "SELECT sdr.*, c.customer_name, " +
                    "u1.first_name + ' ' + u1.last_name as requested_by_name, " +
                    "u2.first_name + ' ' + u2.last_name as approved_by_name " +
                    "FROM Special_Discount_Request sdr " +
                    "INNER JOIN Customer c ON sdr.customer_id = c.customer_id " +
                    "INNER JOIN [User] u1 ON sdr.requested_by = u1.user_id " +
                    "LEFT JOIN [User] u2 ON sdr.approved_by = u2.user_id " +
                    "WHERE sdr.status = 'Pending' " +
                    "ORDER BY sdr.created_at DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                requests.add(mapResultSetToSpecialDiscountRequest(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting pending special discount requests: " + e.getMessage());
            e.printStackTrace();
        }
        
        return requests;
    }
    
    // Get requests by user
    public List<SpecialDiscountRequest> getRequestsByUser(int userId) {
        List<SpecialDiscountRequest> requests = new ArrayList<>();
        String sql = "SELECT sdr.*, c.customer_name, " +
                    "u1.first_name + ' ' + u1.last_name as requested_by_name, " +
                    "u2.first_name + ' ' + u2.last_name as approved_by_name " +
                    "FROM Special_Discount_Request sdr " +
                    "INNER JOIN Customer c ON sdr.customer_id = c.customer_id " +
                    "INNER JOIN [User] u1 ON sdr.requested_by = u1.user_id " +
                    "LEFT JOIN [User] u2 ON sdr.approved_by = u2.user_id " +
                    "WHERE sdr.requested_by = ? " +
                    "ORDER BY sdr.created_at DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapResultSetToSpecialDiscountRequest(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting requests by user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return requests;
    }
    
    // Get request by ID
    public SpecialDiscountRequest getRequestById(int requestId) {
        String sql = "SELECT sdr.*, c.customer_name, " +
                    "u1.first_name + ' ' + u1.last_name as requested_by_name, " +
                    "u2.first_name + ' ' + u2.last_name as approved_by_name " +
                    "FROM Special_Discount_Request sdr " +
                    "INNER JOIN Customer c ON sdr.customer_id = c.customer_id " +
                    "INNER JOIN [User] u1 ON sdr.requested_by = u1.user_id " +
                    "LEFT JOIN [User] u2 ON sdr.approved_by = u2.user_id " +
                    "WHERE sdr.request_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSpecialDiscountRequest(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting request by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Add special discount request
    public boolean addRequest(SpecialDiscountRequest request) {
        String sql = "INSERT INTO Special_Discount_Request (customer_id, requested_by, discount_type, " +
                    "discount_value, reason, estimated_order_value) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, request.getCustomerId());
            ps.setInt(2, request.getRequestedBy());
            ps.setString(3, request.getDiscountType());
            ps.setDouble(4, request.getDiscountValue());
            ps.setString(5, request.getReason());
            
            if (request.getEstimatedOrderValue() != null) {
                ps.setDouble(6, request.getEstimatedOrderValue());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error adding special discount request: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Approve request
    public boolean approveRequest(int requestId, int approvedBy, String generatedCode, Timestamp expiryDate) {
        String sql = "UPDATE Special_Discount_Request SET status = 'Approved', approved_by = ?, " +
                    "approved_at = GETDATE(), generated_code = ?, expiry_date = ? WHERE request_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, approvedBy);
            ps.setString(2, generatedCode);
            ps.setTimestamp(3, expiryDate);
            ps.setInt(4, requestId);
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error approving special discount request: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Reject request
    public boolean rejectRequest(int requestId, int rejectedBy, String rejectionReason) {
        String sql = "UPDATE Special_Discount_Request SET status = 'Rejected', approved_by = ?, " +
                    "approved_at = GETDATE(), rejection_reason = ? WHERE request_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, rejectedBy);
            ps.setString(2, rejectionReason);
            ps.setInt(3, requestId);
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error rejecting special discount request: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Get request by generated code
    public SpecialDiscountRequest getRequestByCode(String code) {
        String sql = "SELECT sdr.*, c.customer_name, " +
                    "u1.first_name + ' ' + u1.last_name as requested_by_name, " +
                    "u2.first_name + ' ' + u2.last_name as approved_by_name " +
                    "FROM Special_Discount_Request sdr " +
                    "INNER JOIN Customer c ON sdr.customer_id = c.customer_id " +
                    "INNER JOIN [User] u1 ON sdr.requested_by = u1.user_id " +
                    "LEFT JOIN [User] u2 ON sdr.approved_by = u2.user_id " +
                    "WHERE sdr.generated_code = ? AND sdr.status = 'Approved' AND sdr.expiry_date > GETDATE()";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, code);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSpecialDiscountRequest(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting request by code: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Map ResultSet to SpecialDiscountRequest object
    private SpecialDiscountRequest mapResultSetToSpecialDiscountRequest(ResultSet rs) throws SQLException {
        SpecialDiscountRequest request = new SpecialDiscountRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setCustomerId(rs.getInt("customer_id"));
        request.setRequestedBy(rs.getInt("requested_by"));
        request.setDiscountType(rs.getString("discount_type"));
        request.setDiscountValue(rs.getDouble("discount_value"));
        request.setReason(rs.getString("reason"));
        
        Double estimatedValue = rs.getObject("estimated_order_value", Double.class);
        request.setEstimatedOrderValue(estimatedValue);
        
        request.setStatus(rs.getString("status"));
        
        Integer approvedBy = rs.getObject("approved_by", Integer.class);
        request.setApprovedBy(approvedBy);
        
        request.setApprovedAt(rs.getTimestamp("approved_at"));
        request.setRejectionReason(rs.getString("rejection_reason"));
        request.setGeneratedCode(rs.getString("generated_code"));
        request.setExpiryDate(rs.getTimestamp("expiry_date"));
        request.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Set display names
        request.setCustomerName(rs.getString("customer_name"));
        request.setRequestedByName(rs.getString("requested_by_name"));
        request.setApprovedByName(rs.getString("approved_by_name"));
        
        return request;
    }
}