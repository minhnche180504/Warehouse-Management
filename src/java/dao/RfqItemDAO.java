package dao;

import model.RfqItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RfqItemDAO extends DBConnect {

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
            Logger.getLogger(RfqItemDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConnection() {
        return new DBConnect().connection;
    }

    /**
     * Insert a new RFQ Item
     */
    public int insert(RfqItem rfqItem) {
        String sql = "INSERT INTO RFQ_Item (rfq_id, product_id, quantity) VALUES (?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, rfqItem.getRfqId());
            statement.setInt(2, rfqItem.getProductId());
            statement.setInt(3, rfqItem.getQuantity());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating RFQ Item failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating RFQ Item failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting RFQ Item: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    /**
     * Get all RFQ Items by RFQ ID with product information
     */
    public List<RfqItem> getByRfqId(int rfqId) {
        List<RfqItem> rfqItems = new ArrayList<>();
        String sql = "SELECT ri.*, p.code as product_code, p.name as product_name, " +
                     "u.unit_name, u.unit_code " +
                     "FROM RFQ_Item ri " +
                     "LEFT JOIN Product p ON ri.product_id = p.product_id " +
                     "LEFT JOIN Unit u ON p.unit_id = u.unit_id " +
                     "WHERE ri.rfq_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, rfqId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                rfqItems.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting RFQ Items by RFQ ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return rfqItems;
    }

    /**
     * Update RFQ Item quantity
     */
    public boolean updateQuantity(int rfqItemId, int quantity) {
        String sql = "UPDATE RFQ_Item SET quantity = ? WHERE rfq_item_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quantity);
            statement.setInt(2, rfqItemId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating RFQ Item quantity: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Delete RFQ Item by ID
     */
    public boolean delete(int rfqItemId) {
        String sql = "DELETE FROM RFQ_Item WHERE rfq_item_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, rfqItemId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting RFQ Item: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Delete all RFQ Items by RFQ ID
     */
    public boolean deleteByRfqId(int rfqId) {
        String sql = "DELETE FROM RFQ_Item WHERE rfq_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, rfqId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting RFQ Items by RFQ ID: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Check if product already exists in RFQ
     */
    public boolean isProductExistsInRfq(int rfqId, int productId) {
        String sql = "SELECT COUNT(*) FROM RFQ_Item WHERE rfq_id = ? AND product_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, rfqId);
            statement.setInt(2, productId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking product existence in RFQ: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Map ResultSet to RfqItem object
     */
    public RfqItem getFromResultSet(ResultSet rs) throws SQLException {
        RfqItem rfqItem = new RfqItem();
        rfqItem.setRfqItemId(rs.getInt("rfq_item_id"));
        rfqItem.setRfqId(rs.getInt("rfq_id"));
        rfqItem.setProductId(rs.getInt("product_id"));
        rfqItem.setQuantity(rs.getInt("quantity"));
        
        // Set display fields
        rfqItem.setProductCode(rs.getString("product_code"));
        rfqItem.setProductName(rs.getString("product_name"));
        rfqItem.setUnitName(rs.getString("unit_name"));
        rfqItem.setUnitCode(rs.getString("unit_code"));
        
        return rfqItem;
    }
} 