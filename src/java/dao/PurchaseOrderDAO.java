package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.PurchaseOrder;

public class PurchaseOrderDAO extends DBConnect {

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
            Logger.getLogger(PurchaseOrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConnection() {
        return new DBConnect().connection;
    }

    public Integer insert(PurchaseOrder purchaseOrder) {
        String sql = "INSERT INTO Purchase_Order (supplier_id, user_id, warehouse_id, date, status, expected_delivery_date) " +
                "VALUES (?, ?, ?, GETDATE(), ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, purchaseOrder.getSupplierId());
            statement.setInt(2, purchaseOrder.getUserId());
            statement.setInt(3, purchaseOrder.getWarehouseId());
            statement.setString(4, purchaseOrder.getStatus());
            statement.setDate(5, purchaseOrder.getExpectedDeliveryDate());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating purchase order failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating purchase order failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting purchase order: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    public Boolean update(PurchaseOrder purchaseOrder) {
        String sql = "UPDATE Purchase_Order SET supplier_id=?, user_id=?, warehouse_id=?, status=?, expected_delivery_date=? WHERE po_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, purchaseOrder.getSupplierId());
            statement.setInt(2, purchaseOrder.getUserId());
            statement.setInt(3, purchaseOrder.getWarehouseId());
            statement.setString(4, purchaseOrder.getStatus());
            statement.setDate(5, purchaseOrder.getExpectedDeliveryDate());
            statement.setInt(6, purchaseOrder.getPoId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating purchase order: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public Boolean delete(Integer poId) {
        String sql = "DELETE FROM Purchase_Order WHERE po_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, poId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting purchase order: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public PurchaseOrder getById(Integer poId) {
        String sql = "SELECT po.po_id, po.supplier_id, po.user_id, po.warehouse_id, po.date, po.status, po.expected_delivery_date, " +
                "s.name as supplier_name, u.first_name + ' ' + u.last_name as user_name, w.warehouse_name " +
                "FROM Purchase_Order po " +
                "LEFT JOIN Supplier s ON po.supplier_id = s.supplier_id " +
                "LEFT JOIN [User] u ON po.user_id = u.user_id " +
                "LEFT JOIN Warehouse w ON po.warehouse_id = w.warehouse_id " +
                "WHERE po.po_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, poId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting purchase order by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<PurchaseOrder> getAll() {
        List<PurchaseOrder> purchaseOrders = new ArrayList<>();
        String sql = "SELECT po.po_id, po.supplier_id, po.user_id, po.warehouse_id, po.date, po.status, po.expected_delivery_date, " +
                "s.name as supplier_name, u.first_name + ' ' + u.last_name as user_name, w.warehouse_name " +
                "FROM Purchase_Order po " +
                "LEFT JOIN Supplier s ON po.supplier_id = s.supplier_id " +
                "LEFT JOIN [User] u ON po.user_id = u.user_id " +
                "LEFT JOIN Warehouse w ON po.warehouse_id = w.warehouse_id " +
                "ORDER BY po.po_id DESC";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                purchaseOrders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting all purchase orders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return purchaseOrders;
    }

    public List<PurchaseOrder> findPurchaseOrdersWithFilters(Integer supplierFilter, String statusFilter, 
                                                             String startDate, String endDate, Integer page, Integer pageSize) {
        List<PurchaseOrder> purchaseOrders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT po.po_id, po.supplier_id, po.user_id, po.warehouse_id, po.date, po.status, po.expected_delivery_date, " +
                "s.name as supplier_name, u.first_name + ' ' + u.last_name as user_name, w.warehouse_name " +
                "FROM Purchase_Order po " +
                "LEFT JOIN Supplier s ON po.supplier_id = s.supplier_id " +
                "LEFT JOIN [User] u ON po.user_id = u.user_id " +
                "LEFT JOIN Warehouse w ON po.warehouse_id = w.warehouse_id " +
                "WHERE 1=1");

        if (supplierFilter != null) {
            sql.append(" AND po.supplier_id = ?");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND po.status LIKE ?");
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND CAST(po.date AS DATE) >= ?");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND CAST(po.date AS DATE) <= ?");
        }

        sql.append(" ORDER BY po.po_id DESC");

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
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + statusFilter + "%");
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
                purchaseOrders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding purchase orders with filters: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return purchaseOrders;
    }

    public Integer getTotalFilteredPurchaseOrders(Integer supplierFilter, String statusFilter, 
                                                  String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Purchase_Order po WHERE 1=1");

        if (supplierFilter != null) {
            sql.append(" AND po.supplier_id = ?");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND po.status LIKE ?");
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
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + statusFilter + "%");
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
            System.out.println("Error getting total filtered purchase orders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public Boolean updateStatus(Integer poId, String status) {
        String sql = "UPDATE Purchase_Order SET status=? WHERE po_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, poId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating purchase order status: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public List<PurchaseOrder> getAllPendingPurchaseOrders() {
        List<PurchaseOrder> purchaseOrders = new ArrayList<>();
        String sql = "SELECT po.po_id, po.supplier_id, po.user_id, po.warehouse_id, po.date, po.status, po.expected_delivery_date, " +
                     "s.name as supplier_name, u.first_name + ' ' + u.last_name as user_name, w.warehouse_name " +
                     "FROM Purchase_Order po " +
                     "LEFT JOIN Supplier s ON po.supplier_id = s.supplier_id " +
                     "LEFT JOIN [User] u ON po.user_id = u.user_id " +
                     "LEFT JOIN Warehouse w ON po.warehouse_id = w.warehouse_id " +
                     "WHERE po.status = 'Approved' " +
                     "ORDER BY po.date DESC";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                purchaseOrders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting pending purchase orders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return purchaseOrders;
    }

    public List<PurchaseOrder> findPurchaseOrdersByUserWithFilters(Integer userId, Integer supplierFilter, String statusFilter, 
                                                             String startDate, String endDate, Integer page, Integer pageSize) {
        List<PurchaseOrder> purchaseOrders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT po.po_id, po.supplier_id, po.user_id, po.warehouse_id, po.date, po.status, po.expected_delivery_date, " +
                "s.name as supplier_name, u.first_name + ' ' + u.last_name as user_name, w.warehouse_name " +
                "FROM Purchase_Order po " +
                "LEFT JOIN Supplier s ON po.supplier_id = s.supplier_id " +
                "LEFT JOIN [User] u ON po.user_id = u.user_id " +
                "LEFT JOIN Warehouse w ON po.warehouse_id = w.warehouse_id " +
                "WHERE po.user_id = ?");

        if (supplierFilter != null) {
            sql.append(" AND po.supplier_id = ?");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND po.status LIKE ?");
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND CAST(po.date AS DATE) >= ?");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND CAST(po.date AS DATE) <= ?");
        }

        sql.append(" ORDER BY po.po_id DESC");

        if (page != null && pageSize != null) {
            sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;
            statement.setInt(paramIndex++, userId);
            
            if (supplierFilter != null) {
                statement.setInt(paramIndex++, supplierFilter);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + statusFilter + "%");
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
                purchaseOrders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding purchase orders by user with filters: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return purchaseOrders;
    }

    public Integer getTotalFilteredPurchaseOrdersByUser(Integer userId, Integer supplierFilter, String statusFilter, 
                                                  String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Purchase_Order po WHERE po.user_id = ?");

        if (supplierFilter != null) {
            sql.append(" AND po.supplier_id = ?");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND po.status LIKE ?");
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
            statement.setInt(paramIndex++, userId);
            
            if (supplierFilter != null) {
                statement.setInt(paramIndex++, supplierFilter);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + statusFilter + "%");
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
            System.out.println("Error getting total filtered purchase orders by user: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public PurchaseOrder getFromResultSet(ResultSet rs) throws SQLException {
        PurchaseOrder purchaseOrder = new PurchaseOrder();
        purchaseOrder.setPoId(rs.getInt("po_id"));
        purchaseOrder.setSupplierId(rs.getInt("supplier_id"));
        purchaseOrder.setSupplierName(rs.getString("supplier_name"));
        purchaseOrder.setUserId(rs.getInt("user_id"));
        purchaseOrder.setUserName(rs.getString("user_name"));
        purchaseOrder.setWarehouseId(rs.getInt("warehouse_id"));
        purchaseOrder.setWarehouseName(rs.getString("warehouse_name"));
        purchaseOrder.setDate(rs.getDate("date"));
        purchaseOrder.setStatus(rs.getString("status"));
        purchaseOrder.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
        return purchaseOrder;
    }

    // Returns the number of distinct products bought in the last week
    public int getDistinctProductsBoughtSince(java.sql.Date sinceDate) {
        String sql = "SELECT COUNT(DISTINCT poi.product_id) " +
                     "FROM Purchase_Order_Item poi " +
                     "JOIN Purchase_Order po ON poi.po_id = po.po_id " +
                     "WHERE po.date >= ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setDate(1, sinceDate);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting distinct products bought since date: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    // Returns the number of distinct suppliers with purchase orders in the last month
    public int getActiveSuppliersSince(java.sql.Date sinceDate) {
        String sql = "SELECT COUNT(DISTINCT supplier_id) FROM Purchase_Order WHERE date >= ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setDate(1, sinceDate);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting active suppliers since date: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    // Returns all pending purchase orders for a specific user
    public List<PurchaseOrder> getPendingPurchaseOrdersByUser(int userId) {
        List<PurchaseOrder> purchaseOrders = new ArrayList<>();
        String sql = "SELECT po.po_id, po.supplier_id, po.user_id, po.warehouse_id, po.date, po.status, po.expected_delivery_date, " +
                     "s.name as supplier_name, u.first_name + ' ' + u.last_name as user_name, w.warehouse_name " +
                     "FROM Purchase_Order po " +
                     "LEFT JOIN Supplier s ON po.supplier_id = s.supplier_id " +
                     "LEFT JOIN [User] u ON po.user_id = u.user_id " +
                     "LEFT JOIN Warehouse w ON po.warehouse_id = w.warehouse_id " +
                     "WHERE po.status = 'Pending' AND po.user_id = ? " +
                     "ORDER BY po.date DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                purchaseOrders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting pending purchase orders by user: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return purchaseOrders;
    }

    public List<PurchaseOrder> getPurchaseOrdersForWarehouse(int warehouseId) {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = "SELECT TOP 5 po.po_id, s.name as supplier_name, po.date, po.status " +
                     "FROM Purchase_Order po JOIN Supplier s ON po.supplier_id = s.supplier_id " +
                     "WHERE po.status IN ('Pending', 'Approved') AND po.warehouse_id = ? " +
                     "ORDER BY po.date DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                PurchaseOrder po = new PurchaseOrder();
                po.setPoId(resultSet.getInt("po_id"));
                po.setSupplierName(resultSet.getString("supplier_name"));
                po.setDate(resultSet.getDate("date"));
                po.setStatus(resultSet.getString("status"));
                list.add(po);
            }
        } catch (SQLException e) {
            System.out.println("getPurchaseOrdersForWarehouse: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }
}