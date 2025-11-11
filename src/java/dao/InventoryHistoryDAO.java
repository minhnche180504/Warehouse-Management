package dao;

import model.InventoryHistory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class InventoryHistoryDAO extends DBConnect {
    
    private PreparedStatement statement;
    private ResultSet resultSet;
    
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
            System.err.println("Error closing resources: " + ex.getMessage());
        }
    }
    
    public Connection getConnection() {
        return new DBConnect().connection;
    }
    
    /**
     * Get inventory history for a specific product with pagination
     */
    public List<InventoryHistory> getProductInventoryHistory(
            Integer productId, 
            String transactionType,
            Integer page, 
            Integer pageSize) {
        
        List<InventoryHistory> history = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        
        sql.append("WITH InventoryTransactions AS (")
           // Purchase Order Items (incoming)
           .append("SELECT p.product_id, p.code as product_code, p.name as product_name, ")
           .append("'IN' as transaction_type, poi.quantity as quantity_change, ")
           .append("po.date as transaction_date, 'Purchase Order' as reason, ")
           .append("'PURCHASE_ORDER' as reference_type, po.po_id as reference_id, ")
           .append("'PO-' + CAST(po.po_id AS VARCHAR) as reference_number, ")
           .append("CONCAT(u.first_name, ' ', u.last_name) as user_name, u.user_id, ")
           .append("w.warehouse_name, w.warehouse_id, unit.unit_code, poi.unit_price ")
           .append("FROM Purchase_Order_Item poi ")
           .append("JOIN Purchase_Order po ON poi.po_id = po.po_id ")
           .append("JOIN Product p ON poi.product_id = p.product_id ")
           .append("LEFT JOIN [User] u ON po.user_id = u.user_id ")
           .append("LEFT JOIN Inventory i ON p.product_id = i.product_id ")
           .append("LEFT JOIN Warehouse w ON i.warehouse_id = w.warehouse_id ")
           .append("LEFT JOIN Unit unit ON p.unit_id = unit.unit_id ")
           .append("WHERE po.status = 'Completed' ")
           .append("UNION ALL ")
           // Sales Order Items (outgoing, only Order and Delivery)
           .append("SELECT p.product_id, p.code as product_code, p.name as product_name, ")
           .append("'OUT' as transaction_type, -soi.quantity as quantity_change, ")
           .append("so.date as transaction_date, 'Sales Order' as reason, ")
           .append("'SALES_ORDER' as reference_type, so.so_id as reference_id, ")
           .append("'SO-' + CAST(so.so_id AS VARCHAR) as reference_number, ")
           .append("CONCAT(u.first_name, ' ', u.last_name) as user_name, u.user_id, ")
           .append("w.warehouse_name, w.warehouse_id, unit.unit_code, soi.unit_price ")
           .append("FROM Sales_Order_Item soi ")
           .append("JOIN Sales_Order so ON soi.so_id = so.so_id ")
           .append("JOIN Product p ON soi.product_id = p.product_id ")
           .append("LEFT JOIN [User] u ON so.user_id = u.user_id ")
           .append("LEFT JOIN Inventory i ON p.product_id = i.product_id ")
           .append("LEFT JOIN Warehouse w ON i.warehouse_id = w.warehouse_id ")
           .append("LEFT JOIN Unit unit ON p.unit_id = unit.unit_id ")
           .append("WHERE so.status IN ('Order', 'Delivery') ")
           .append("UNION ALL ")
           // Stock Adjustments
           .append("SELECT p.product_id, p.code as product_code, p.name as product_name, ")
           .append("CASE WHEN sa.quantity_change > 0 THEN 'IN' ELSE 'OUT' END as transaction_type, ")
           .append("sa.quantity_change, sa.date as transaction_date, ")
           .append("sar.description as reason, 'ADJUSTMENT' as reference_type, ")
           .append("sa.adjustment_id as reference_id, ")
           .append("'ADJ-' + CAST(sa.adjustment_id AS VARCHAR) as reference_number, ")
           .append("CONCAT(u.first_name, ' ', u.last_name) as user_name, u.user_id, ")
           .append("w.warehouse_name, w.warehouse_id, unit.unit_code, p.price as unit_price ")
           .append("FROM Stock_Adjustment sa ")
           .append("JOIN Product p ON sa.product_id = p.product_id ")
           .append("LEFT JOIN Stock_Adjustment_Reason sar ON sa.reason_id = sar.reason_id ")
           .append("LEFT JOIN [User] u ON sa.user_id = u.user_id ")
           .append("LEFT JOIN Inventory i ON p.product_id = i.product_id ")
           .append("LEFT JOIN Warehouse w ON i.warehouse_id = w.warehouse_id ")
           .append("LEFT JOIN Unit unit ON p.unit_id = unit.unit_id ")
           // Returning Sales Orders (IN, not yet in inventory)
           .append("UNION ALL ")
           .append("SELECT p.product_id, p.code as product_code, p.name as product_name, ")
           .append("'IN' as transaction_type, soi.quantity as quantity_change, ")
           .append("so.date as transaction_date, 'Sales Order Returning' as reason, 'SALES_ORDER_RETURNING' as reference_type, so.so_id as reference_id, ")
           .append("'SO-RETURNING-' + CAST(so.so_id AS VARCHAR) as reference_number, ")
           .append("CONCAT(u.first_name, ' ', u.last_name) as user_name, u.user_id, ")
           .append("w.warehouse_name, w.warehouse_id, unit.unit_code, soi.unit_price ")
           .append("FROM Sales_Order_Item soi ")
           .append("JOIN Sales_Order so ON soi.so_id = so.so_id ")
           .append("JOIN Product p ON soi.product_id = p.product_id ")
           .append("LEFT JOIN [User] u ON so.user_id = u.user_id ")
           .append("LEFT JOIN Inventory i ON p.product_id = i.product_id ")
           .append("LEFT JOIN Warehouse w ON i.warehouse_id = w.warehouse_id ")
           .append("LEFT JOIN Unit unit ON p.unit_id = unit.unit_id ")
           .append("WHERE so.status = 'Returning' ")
           // --- Transfer Orders: OUT (source warehouse) ---
           .append("UNION ALL ")
           .append("SELECT toi.product_id, p.code as product_code, p.name as product_name, ")
           .append("'OUT' as transaction_type, -toi.quantity as quantity_change, ")
           .append("to_.transfer_date as transaction_date, 'Warehouse Transfer Out' as reason, 'TRANSFER_ORDER' as reference_type, to_.to_id as reference_id, ")
           .append("'TO-' + CAST(to_.to_id AS VARCHAR) as reference_number, ")
           .append("CONCAT(u.first_name, ' ', u.last_name) as user_name, u.user_id, ")
           .append("wsrc.warehouse_name, wsrc.warehouse_id, unit.unit_code, p.price as unit_price ")
           .append("FROM Transfer_Order_Item toi ")
           .append("JOIN Transfer_Order to_ ON toi.to_id = to_.to_id ")
           .append("JOIN Product p ON toi.product_id = p.product_id ")
           .append("LEFT JOIN [User] u ON to_.created_by = u.user_id ")
           .append("JOIN Warehouse wsrc ON to_.source_warehouse_id = wsrc.warehouse_id ")
           .append("LEFT JOIN Unit unit ON p.unit_id = unit.unit_id ")
           .append("WHERE to_.status IN ('Delivery', 'Completed') ")
           // --- Transfer Orders: IN (destination warehouse) ---
           .append("UNION ALL ")
           .append("SELECT toi.product_id, p.code as product_code, p.name as product_name, ")
           .append("'IN' as transaction_type, toi.quantity as quantity_change, ")
           .append("to_.transfer_date as transaction_date, 'Warehouse Transfer In' as reason, 'TRANSFER_ORDER' as reference_type, to_.to_id as reference_id, ")
           .append("'TO-' + CAST(to_.to_id AS VARCHAR) as reference_number, ")
           .append("CONCAT(u.first_name, ' ', u.last_name) as user_name, u.user_id, ")
           .append("wdst.warehouse_name, wdst.warehouse_id, unit.unit_code, p.price as unit_price ")
           .append("FROM Transfer_Order_Item toi ")
           .append("JOIN Transfer_Order to_ ON toi.to_id = to_.to_id ")
           .append("JOIN Product p ON toi.product_id = p.product_id ")
           .append("LEFT JOIN [User] u ON to_.created_by = u.user_id ")
           .append("JOIN Warehouse wdst ON to_.destination_warehouse_id = wdst.warehouse_id ")
           .append("LEFT JOIN Unit unit ON p.unit_id = unit.unit_id ")
           .append("WHERE to_.status IN ('Delivery', 'Completed') ");
        
        // Add filters
        if (productId != null) {
            sql.append("AND product_id = ? ");
        }
        if (transactionType != null && !transactionType.trim().isEmpty()) {
            sql.append("AND transaction_type = ? ");
        }
        
        sql.append("ORDER BY transaction_date DESC ");
        
        // Add pagination
        if (page != null && pageSize != null) {
            sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            // Set filter parameters
            if (productId != null) {
                statement.setInt(paramIndex++, productId);
            }
            if (transactionType != null && !transactionType.trim().isEmpty()) {
                statement.setString(paramIndex++, transactionType);
            }
            
            // Set pagination parameters
            if (page != null && pageSize != null) {
                statement.setInt(paramIndex++, (page - 1) * pageSize);
                statement.setInt(paramIndex++, pageSize);
            }
            
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                history.add(getFromResultSet(resultSet));
            }
            
        } catch (SQLException ex) {
            System.err.println("Error getting inventory history: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return history;
    }
    
    /**
     * Get total count for pagination
     */
    public Integer getTotalHistoryCount(Integer productId, String transactionType) {
        StringBuilder sql = new StringBuilder();
        
        sql.append("WITH InventoryTransactions AS (")
           .append("SELECT p.product_id, 'IN' as transaction_type ")
           .append("FROM Purchase_Order_Item poi ")
           .append("JOIN Purchase_Order po ON poi.po_id = po.po_id ")
           .append("JOIN Product p ON poi.product_id = p.product_id ")
           .append("WHERE po.status = 'Completed' ")
           
           .append("UNION ALL ")
           
           .append("SELECT p.product_id, 'OUT' as transaction_type ")
           .append("FROM Sales_Order_Item soi ")
           .append("JOIN Sales_Order so ON soi.so_id = so.so_id ")
           .append("JOIN Product p ON soi.product_id = p.product_id ")
           .append("WHERE so.status = 'Completed' ")
           
           .append("UNION ALL ")
           
           .append("SELECT p.product_id, ")
           .append("CASE WHEN sa.quantity_change > 0 THEN 'IN' ELSE 'OUT' END as transaction_type ")
           .append("FROM Stock_Adjustment sa ")
           .append("JOIN Product p ON sa.product_id = p.product_id ")
           
           .append(") ")
           .append("SELECT COUNT(*) FROM InventoryTransactions ")
           .append("WHERE 1=1 ");
        
        // Add same filters as main query
        if (productId != null) {
            sql.append("AND product_id = ? ");
        }
        if (transactionType != null && !transactionType.trim().isEmpty()) {
            sql.append("AND transaction_type = ? ");
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            // Set filter parameters
            if (productId != null) {
                statement.setInt(paramIndex++, productId);
            }
            if (transactionType != null && !transactionType.trim().isEmpty()) {
                statement.setString(paramIndex++, transactionType);
            }
            
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            
        } catch (SQLException ex) {
            System.err.println("Error getting total history count: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return 0;
    }
    
    /**
     * Get inventory history for a specific product filtered by warehouse with pagination
     */
    public List<InventoryHistory> getProductInventoryHistoryByWarehouse(
            Integer productId, 
            Integer warehouseId,
            String transactionType,
            Integer page, 
            Integer pageSize) {
        
        List<InventoryHistory> history = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        
        sql.append("WITH InventoryTransactions AS (")
           // Purchase Order Items (incoming)
           .append("SELECT p.product_id, p.code as product_code, p.name as product_name, ")
           .append("'IN' as transaction_type, poi.quantity as quantity_change, ")
           .append("po.date as transaction_date, 'Purchase Order' as reason, ")
           .append("'PURCHASE_ORDER' as reference_type, po.po_id as reference_id, ")
           .append("'PO-' + CAST(po.po_id AS VARCHAR) as reference_number, ")
           .append("CONCAT(u.first_name, ' ', u.last_name) as user_name, u.user_id, ")
           .append("w.warehouse_name, w.warehouse_id, unit.unit_code, poi.unit_price ")
           .append("FROM Purchase_Order_Item poi ")
           .append("JOIN Purchase_Order po ON poi.po_id = po.po_id ")
           .append("JOIN Product p ON poi.product_id = p.product_id ")
           .append("LEFT JOIN [User] u ON po.user_id = u.user_id ")
           .append("JOIN Warehouse w ON po.warehouse_id = w.warehouse_id ")
           .append("LEFT JOIN Unit unit ON p.unit_id = unit.unit_id ")
           .append("WHERE po.status = 'Completed' ")
           
           .append("UNION ALL ")
           
           // Sales Order Items (outgoing)
           .append("SELECT p.product_id, p.code as product_code, p.name as product_name, ")
           .append("'OUT' as transaction_type, -soi.quantity as quantity_change, ")
           .append("so.date as transaction_date, 'Sales Order' as reason, ")
           .append("'SALES_ORDER' as reference_type, so.so_id as reference_id, ")
           .append("'SO-' + CAST(so.so_id AS VARCHAR) as reference_number, ")
           .append("CONCAT(u.first_name, ' ', u.last_name) as user_name, u.user_id, ")
           .append("w.warehouse_name, w.warehouse_id, unit.unit_code, soi.unit_price ")
           .append("FROM Sales_Order_Item soi ")
           .append("JOIN Sales_Order so ON soi.so_id = so.so_id ")
           .append("JOIN Product p ON soi.product_id = p.product_id ")
           .append("LEFT JOIN [User] u ON so.user_id = u.user_id ")
           .append("JOIN Warehouse w ON so.warehouse_id = w.warehouse_id ")
           .append("LEFT JOIN Unit unit ON p.unit_id = unit.unit_id ")
           .append("WHERE so.status = 'Completed' ")
           
           .append("UNION ALL ")
           
           // Stock Adjustments
           .append("SELECT p.product_id, p.code as product_code, p.name as product_name, ")
           .append("CASE WHEN sa.quantity_change > 0 THEN 'IN' ELSE 'OUT' END as transaction_type, ")
           .append("sa.quantity_change, sa.date as transaction_date, ")
           .append("sar.description as reason, 'ADJUSTMENT' as reference_type, ")
           .append("sa.adjustment_id as reference_id, ")
           .append("'ADJ-' + CAST(sa.adjustment_id AS VARCHAR) as reference_number, ")
           .append("CONCAT(u.first_name, ' ', u.last_name) as user_name, u.user_id, ")
           .append("w.warehouse_name, w.warehouse_id, unit.unit_code, p.price as unit_price ")
           .append("FROM Stock_Adjustment sa ")
           .append("JOIN Product p ON sa.product_id = p.product_id ")
           .append("LEFT JOIN Stock_Adjustment_Reason sar ON sa.reason_id = sar.reason_id ")
           .append("LEFT JOIN [User] u ON sa.user_id = u.user_id ")
           .append("JOIN Warehouse w ON sa.warehouse_id = w.warehouse_id ")
           .append("LEFT JOIN Unit unit ON p.unit_id = unit.unit_id ")
           
           .append(") ")
           .append("SELECT * FROM InventoryTransactions ")
           .append("WHERE 1=1 ");
        
        // Add filters
        if (productId != null) {
            sql.append("AND product_id = ? ");
        }
        if (warehouseId != null) {
            sql.append("AND warehouse_id = ? ");
        }
        if (transactionType != null && !transactionType.trim().isEmpty()) {
            sql.append("AND transaction_type = ? ");
        }
        
        sql.append("ORDER BY transaction_date DESC ");
        
        // Add pagination
        if (page != null && pageSize != null) {
            sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            // Set filter parameters
            if (productId != null) {
                statement.setInt(paramIndex++, productId);
            }
            if (warehouseId != null) {
                statement.setInt(paramIndex++, warehouseId);
            }
            if (transactionType != null && !transactionType.trim().isEmpty()) {
                statement.setString(paramIndex++, transactionType);
            }
            
            // Set pagination parameters
            if (page != null && pageSize != null) {
                statement.setInt(paramIndex++, (page - 1) * pageSize);
                statement.setInt(paramIndex++, pageSize);
            }
            
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                history.add(getFromResultSet(resultSet));
            }
            
        } catch (SQLException ex) {
            System.err.println("Error getting inventory history by warehouse: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return history;
    }
    
    /**
     * Get total count for pagination filtered by warehouse
     */
    public Integer getTotalHistoryCountByWarehouse(Integer productId, Integer warehouseId, String transactionType) {
        StringBuilder sql = new StringBuilder();
        
        sql.append("WITH InventoryTransactions AS (")
           .append("SELECT p.product_id, 'IN' as transaction_type, w.warehouse_id ")
           .append("FROM Purchase_Order_Item poi ")
           .append("JOIN Purchase_Order po ON poi.po_id = po.po_id ")
           .append("JOIN Product p ON poi.product_id = p.product_id ")
           .append("JOIN Warehouse w ON po.warehouse_id = w.warehouse_id ")
           .append("WHERE po.status = 'Completed' ")
           
           .append("UNION ALL ")
           
           .append("SELECT p.product_id, 'OUT' as transaction_type, w.warehouse_id ")
           .append("FROM Sales_Order_Item soi ")
           .append("JOIN Sales_Order so ON soi.so_id = so.so_id ")
           .append("JOIN Product p ON soi.product_id = p.product_id ")
           .append("JOIN Warehouse w ON so.warehouse_id = w.warehouse_id ")
           .append("WHERE so.status = 'Completed' ")
           
           .append("UNION ALL ")
           
           .append("SELECT p.product_id, ")
           .append("CASE WHEN sa.quantity_change > 0 THEN 'IN' ELSE 'OUT' END as transaction_type, ")
           .append("w.warehouse_id ")
           .append("FROM Stock_Adjustment sa ")
           .append("JOIN Product p ON sa.product_id = p.product_id ")
           .append("JOIN Warehouse w ON sa.warehouse_id = w.warehouse_id ")
           
           .append(") ")
           .append("SELECT COUNT(*) FROM InventoryTransactions ")
           .append("WHERE 1=1 ");
        
        // Add same filters as main query
        if (productId != null) {
            sql.append("AND product_id = ? ");
        }
        if (warehouseId != null) {
            sql.append("AND warehouse_id = ? ");
        }
        if (transactionType != null && !transactionType.trim().isEmpty()) {
            sql.append("AND transaction_type = ? ");
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            // Set filter parameters
            if (productId != null) {
                statement.setInt(paramIndex++, productId);
            }
            if (warehouseId != null) {
                statement.setInt(paramIndex++, warehouseId);
            }
            if (transactionType != null && !transactionType.trim().isEmpty()) {
                statement.setString(paramIndex++, transactionType);
            }
            
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            
        } catch (SQLException ex) {
            System.err.println("Error getting total history count by warehouse: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return 0;
    }
    
    /**
     * Map ResultSet to InventoryHistory object
     */
    public InventoryHistory getFromResultSet(ResultSet rs) throws SQLException {
        InventoryHistory history = new InventoryHistory();
        
        history.setProductId(rs.getInt("product_id"));
        history.setProductCode(rs.getString("product_code"));
        history.setProductName(rs.getString("product_name"));
        history.setTransactionType(rs.getString("transaction_type"));
        history.setQuantityChange(rs.getInt("quantity_change"));
        history.setTransactionDate(rs.getDate("transaction_date"));
        history.setReason(rs.getString("reason"));
        history.setReferenceType(rs.getString("reference_type"));
        history.setReferenceId(rs.getInt("reference_id"));
        history.setReferenceNumber(rs.getString("reference_number"));
        history.setUserName(rs.getString("user_name"));
        history.setUserId(rs.getInt("user_id"));
        history.setWarehouseName(rs.getString("warehouse_name"));
        history.setWarehouseId(rs.getInt("warehouse_id"));
        history.setUnitCode(rs.getString("unit_code"));
        
        BigDecimal unitPrice = rs.getBigDecimal("unit_price");
        history.setUnitPrice(unitPrice != null ? unitPrice : BigDecimal.ZERO);
        
        // Set display fields
        String type = history.getTransactionType();
        if ("IN".equals(type)) {
            history.setTransactionTypeDisplay("Stock In");
            history.setQuantityChangeDisplay("+" + history.getQuantityChange());
        } else if ("OUT".equals(type)) {
            history.setTransactionTypeDisplay("Stock Out");
            history.setQuantityChangeDisplay(String.valueOf(history.getQuantityChange()));
        } else {
            history.setTransactionTypeDisplay("Adjustment");
            int change = history.getQuantityChange();
            history.setQuantityChangeDisplay(change > 0 ? "+" + change : String.valueOf(change));
        }
        
        return history;
    }
} 