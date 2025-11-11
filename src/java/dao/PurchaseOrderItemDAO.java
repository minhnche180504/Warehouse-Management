package dao;

import model.PurchaseOrderItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PurchaseOrderItemDAO extends DBConnect {

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
            Logger.getLogger(PurchaseOrderItemDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConnection() {
        return new DBConnect().connection;
    }

    public Integer insert(PurchaseOrderItem item) {
        String sql = "INSERT INTO Purchase_Order_Item (po_id, product_id, quantity, unit_price) " +
                "VALUES (?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, item.getPoId());
            statement.setInt(2, item.getProductId());
            statement.setInt(3, item.getQuantity());
            statement.setBigDecimal(4, item.getUnitPrice());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating purchase order item failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating purchase order item failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting purchase order item: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    public Boolean update(PurchaseOrderItem item) {
        String sql = "UPDATE Purchase_Order_Item SET po_id=?, product_id=?, quantity=?, unit_price=? " +
                "WHERE po_item_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, item.getPoId());
            statement.setInt(2, item.getProductId());
            statement.setInt(3, item.getQuantity());
            statement.setBigDecimal(4, item.getUnitPrice());
            statement.setInt(5, item.getPoItemId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating purchase order item: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public Boolean delete(Integer poItemId) {
        String sql = "DELETE FROM Purchase_Order_Item WHERE po_item_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, poItemId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting purchase order item: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public Boolean deleteByPurchaseOrderId(Integer poId) {
        String sql = "DELETE FROM Purchase_Order_Item WHERE po_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, poId);

            int affectedRows = statement.executeUpdate();
            return affectedRows >= 0; // Even 0 affected rows is OK (empty order)
        } catch (SQLException ex) {
            System.out.println("Error deleting purchase order items by PO ID: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public PurchaseOrderItem getById(Integer poItemId) {
        String sql = "SELECT poi.*, p.code as product_code, p.name as product_name " +
                "FROM Purchase_Order_Item poi " +
                "LEFT JOIN Product p ON poi.product_id = p.product_id " +
                "WHERE poi.po_item_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, poItemId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting purchase order item by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<PurchaseOrderItem> getByPurchaseOrderId(Integer poId) {
        List<PurchaseOrderItem> items = new ArrayList<>();
        String sql = "SELECT poi.*, p.code as product_code, p.name as product_name " +
                "FROM Purchase_Order_Item poi " +
                "LEFT JOIN Product p ON poi.product_id = p.product_id " +
                "WHERE poi.po_id=? " +
                "ORDER BY poi.po_item_id";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, poId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                items.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting purchase order items by PO ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return items;
    }

    public List<PurchaseOrderItem> getAllWithDetails() {
        List<PurchaseOrderItem> items = new ArrayList<>();
        String sql = "SELECT poi.*, p.code as product_code, p.name as product_name " +
                "FROM Purchase_Order_Item poi " +
                "LEFT JOIN Product p ON poi.product_id = p.product_id " +
                "ORDER BY poi.po_id DESC, poi.po_item_id";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                items.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting all purchase order items with details: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return items;
    }

    public List<PurchaseOrderItem> getPurchaseOrderItemsWithFilters(Integer supplierFilter, Integer productFilter, 
                                                                     String startDate, String endDate, Integer page, Integer pageSize) {
        List<PurchaseOrderItem> items = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT poi.*, p.code as product_code, p.name as product_name, " +
                "po.date as po_date, s.name as supplier_name " +
                "FROM Purchase_Order_Item poi " +
                "LEFT JOIN Product p ON poi.product_id = p.product_id " +
                "LEFT JOIN Purchase_Order po ON poi.po_id = po.po_id " +
                "LEFT JOIN Supplier s ON po.supplier_id = s.supplier_id " +
                "WHERE 1=1");

        if (supplierFilter != null) {
            sql.append(" AND po.supplier_id = ?");
        }
        if (productFilter != null) {
            sql.append(" AND poi.product_id = ?");
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND CAST(po.date AS DATE) >= ?");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND CAST(po.date AS DATE) <= ?");
        }

        sql.append(" ORDER BY po.date DESC, poi.po_id DESC, poi.po_item_id");

        if (page != null && pageSize != null) {
            sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (supplierFilter != null) {
                statement.setInt(paramIndex++, supplierFilter);
            }
            if (productFilter != null) {
                statement.setInt(paramIndex++, productFilter);
            }
            if (startDate != null && !startDate.trim().isEmpty()) {
                statement.setString(paramIndex++, startDate);
            }
            if (endDate != null && !endDate.trim().isEmpty()) {
                statement.setString(paramIndex++, endDate);
            }

            if (page != null && pageSize != null) {
                statement.setInt(paramIndex++, (page - 1) * pageSize);
                statement.setInt(paramIndex, pageSize);
            }

            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                items.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding purchase order items with filters: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return items;
    }

    public Integer getTotalFilteredPurchaseOrderItems(Integer supplierFilter, Integer productFilter, 
                                                      String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Purchase_Order_Item poi " +
                "LEFT JOIN Purchase_Order po ON poi.po_id = po.po_id " +
                "WHERE 1=1");

        if (supplierFilter != null) {
            sql.append(" AND po.supplier_id = ?");
        }
        if (productFilter != null) {
            sql.append(" AND poi.product_id = ?");
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND CAST(po.date AS DATE) >= ?");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND CAST(po.date AS DATE) <= ?");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (supplierFilter != null) {
                statement.setInt(paramIndex++, supplierFilter);
            }
            if (productFilter != null) {
                statement.setInt(paramIndex++, productFilter);
            }
            if (startDate != null && !startDate.trim().isEmpty()) {
                statement.setString(paramIndex++, startDate);
            }
            if (endDate != null && !endDate.trim().isEmpty()) {
                statement.setString(paramIndex, endDate);
            }

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting total filtered purchase order items: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public PurchaseOrderItem getFromResultSet(ResultSet rs) throws SQLException {
        PurchaseOrderItem item = new PurchaseOrderItem();
        item.setPoItemId(rs.getInt("po_item_id"));
        item.setPoId(rs.getInt("po_id"));
        item.setProductId(rs.getInt("product_id"));
        item.setProductCode(rs.getString("product_code"));
        item.setProductName(rs.getString("product_name"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        return item;
    }
} 