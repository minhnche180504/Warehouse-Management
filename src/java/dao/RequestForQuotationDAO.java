package dao;

import model.RequestForQuotation;
import model.RfqItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RequestForQuotationDAO extends DBConnect {

    protected ResultSet resultSet;
    protected PreparedStatement statement;

    public void closeResources() {
        try {
            if (resultSet != null && !resultSet.isClosed()) {
                resultSet.close();
            }
            if (statement != null && !statement.isClosed()) {
                statement.close();
            }
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForQuotationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConnection() {
        return new DBConnect().connection;
    }

    /**
     * Save a new Request for Quotation (alias for insert)
     */
    public int save(RequestForQuotation rfq) {
        return insert(rfq);
    }

    /**
     * Insert a new Request for Quotation
     */
    public int insert(RequestForQuotation rfq) {
        String sql = "INSERT INTO Request_For_Quotation (created_by, request_date, status, notes, description, supplier_id, warehouse_id, expected_delivery_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, rfq.getCreatedBy());
            // Set request_date to now if not provided
            java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
            statement.setTimestamp(2, rfq.getRequestDate() != null ? new java.sql.Timestamp(rfq.getRequestDate().getTime()) : now);
            statement.setString(3, rfq.getStatus() != null ? rfq.getStatus() : "Pending");
            statement.setString(4, rfq.getNotes());
            statement.setString(5, rfq.getDescription());
            statement.setInt(6, rfq.getSupplierId());
            statement.setInt(7, rfq.getWarehouseId());
            statement.setDate(8, rfq.getExpectedDeliveryDate());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating RFQ failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating RFQ failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting RFQ: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    /**
     * Get RFQ by ID with supplier and warehouse information
     */
    public RequestForQuotation getById(int rfqId) {
        String sql = "SELECT rfq.*, s.name as supplier_name, s.email as supplier_email, s.phone as supplier_phone, " +
                     "u.first_name + ' ' + u.last_name as created_by_name, " +
                     "w.warehouse_name, w.address as warehouse_address " +
                     "FROM Request_For_Quotation rfq " +
                     "LEFT JOIN Supplier s ON rfq.supplier_id = s.supplier_id " +
                     "LEFT JOIN [User] u ON rfq.created_by = u.user_id " +
                     "LEFT JOIN Warehouse w ON rfq.warehouse_id = w.warehouse_id " +
                     "WHERE rfq.rfq_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, rfqId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting RFQ by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Get all RFQs with pagination
     */
    public List<RequestForQuotation> getAllWithPagination(int page, int pageSize) {
        List<RequestForQuotation> rfqList = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT rfq.*, s.name as supplier_name, s.email as supplier_email, s.phone as supplier_phone, " +
                     "u.first_name + ' ' + u.last_name as created_by_name, " +
                     "w.warehouse_name, w.address as warehouse_address " +
                     "FROM Request_For_Quotation rfq " +
                     "LEFT JOIN Supplier s ON rfq.supplier_id = s.supplier_id " +
                     "LEFT JOIN [User] u ON rfq.created_by = u.user_id " +
                     "LEFT JOIN Warehouse w ON rfq.warehouse_id = w.warehouse_id " +
                     "ORDER BY rfq.request_date DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, offset);
            statement.setInt(2, pageSize);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                rfqList.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting all RFQs: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return rfqList;
    }

    /**
     * Get total count for pagination
     */
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM Request_For_Quotation";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting total count: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Get all RFQs by user with pagination
     */
    public List<RequestForQuotation> getAllByUserWithPagination(int userId, int page, int pageSize) {
        List<RequestForQuotation> rfqList = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT rfq.*, s.name as supplier_name, s.email as supplier_email, s.phone as supplier_phone, " +
                     "u.first_name + ' ' + u.last_name as created_by_name, " +
                     "w.warehouse_name, w.address as warehouse_address " +
                     "FROM Request_For_Quotation rfq " +
                     "LEFT JOIN Supplier s ON rfq.supplier_id = s.supplier_id " +
                     "LEFT JOIN [User] u ON rfq.created_by = u.user_id " +
                     "LEFT JOIN Warehouse w ON rfq.warehouse_id = w.warehouse_id " +
                     "WHERE rfq.created_by = ? " +
                     "ORDER BY rfq.request_date DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, offset);
            statement.setInt(3, pageSize);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                rfqList.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting RFQs by user: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return rfqList;
    }

    /**
     * Get total count by user for pagination
     */
    public int getTotalCountByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM Request_For_Quotation WHERE created_by = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting total count by user: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Update RFQ status
     */
    public boolean updateStatus(int rfqId, String status) {
        String sql = "UPDATE Request_For_Quotation SET status = ? WHERE rfq_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, rfqId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating RFQ status: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Delete RFQ by ID
     */
    public boolean delete(int rfqId) {
        // First delete related RFQ items
        RfqItemDAO rfqItemDAO = new RfqItemDAO();
        rfqItemDAO.deleteByRfqId(rfqId);

        String sql = "DELETE FROM Request_For_Quotation WHERE rfq_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, rfqId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting RFQ: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Map ResultSet to RequestForQuotation object
     */
    public RequestForQuotation getFromResultSet(ResultSet rs) throws SQLException {
        RequestForQuotation rfq = new RequestForQuotation();
        rfq.setRfqId(rs.getInt("rfq_id"));
        rfq.setCreatedBy(rs.getInt("created_by"));
        rfq.setRequestDate(rs.getDate("request_date"));
        rfq.setStatus(rs.getString("status"));
        rfq.setNotes(rs.getString("notes"));
        rfq.setDescription(rs.getString("description"));
        rfq.setSupplierId(rs.getInt("supplier_id"));
        rfq.setWarehouseId(rs.getInt("warehouse_id"));
        rfq.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
        
        // Set display fields
        rfq.setSupplierName(rs.getString("supplier_name"));
        rfq.setSupplierEmail(rs.getString("supplier_email"));
        rfq.setSupplierPhone(rs.getString("supplier_phone"));
        rfq.setCreatedByName(rs.getString("created_by_name"));
        rfq.setWarehouseName(rs.getString("warehouse_name"));
        
        return rfq;
    }
}