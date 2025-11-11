package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.InventoryTransfer;
import model.InventoryTransferDisplay;
import model.InventoryTransferItem;
import model.Unit;
import model.Warehouse;

public class InventoryTransferDAO extends DBConnect {

    public List<InventoryTransfer> getAllInventoryTransfers() {
        List<InventoryTransfer> transfers = new ArrayList<>();
        String sql = "SELECT it.*, "
                + "sw.warehouse_name AS source_warehouse_name, "
                + "dw.warehouse_name AS destination_warehouse_name, "
                + "u.first_name + ' ' + u.last_name AS creator_name "
                + "FROM Inventory_Transfer it "
                + "JOIN Warehouse sw ON it.source_warehouse_id = sw.warehouse_id "
                + "JOIN Warehouse dw ON it.destination_warehouse_id = dw.warehouse_id "
                + "JOIN [User] u ON it.created_by = u.user_id "
                + "ORDER BY it.date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                InventoryTransfer transfer = mapInventoryTransfer(rs);
                transfers.add(transfer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transfers;
    }

    public List<InventoryTransfer> getInventoryTransfersByStatus(String status) {
        List<InventoryTransfer> transfers = new ArrayList<>();
        String sql = "SELECT it.*, "
                + "sw.warehouse_name AS source_warehouse_name, "
                + "dw.warehouse_name AS destination_warehouse_name, "
                + "u.first_name + ' ' + u.last_name AS creator_name "
                + "FROM Inventory_Transfer it "
                + "JOIN Warehouse sw ON it.source_warehouse_id = sw.warehouse_id "
                + "JOIN Warehouse dw ON it.destination_warehouse_id = dw.warehouse_id "
                + "JOIN [User] u ON it.created_by = u.user_id "
                + "WHERE it.status = ? "
                + "ORDER BY it.date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryTransfer transfer = mapInventoryTransfer(rs);
                    transfers.add(transfer);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transfers;
    }

    public InventoryTransfer getInventoryTransferById(int transferId) {
        String sql = "SELECT it.*, "
                + "sw.warehouse_name AS source_warehouse_name, "
                + "dw.warehouse_name AS destination_warehouse_name, "
                + "u.first_name + ' ' + u.last_name AS creator_name "
                + "FROM Inventory_Transfer it "
                + "JOIN Warehouse sw ON it.source_warehouse_id = sw.warehouse_id "
                + "JOIN Warehouse dw ON it.destination_warehouse_id = dw.warehouse_id "
                + "JOIN [User] u ON it.created_by = u.user_id "
                + "WHERE it.it_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transferId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    InventoryTransfer transfer = mapInventoryTransfer(rs);
                    // Load items for this transfer
                    transfer.setItems(getInventoryTransferItems(transferId));
                    return transfer;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<InventoryTransferItem> getInventoryTransferItems(int transferId) {
        List<InventoryTransferItem> items = new ArrayList<>();
        String sql = "SELECT iti.*, p.name AS product_name, p.code AS product_code, "
                + "u.unit_id, u.unit_name, u.unit_code "
                + "FROM Inventory_Transfer_Item iti "
                + "JOIN Product p ON iti.product_id = p.product_id "
                + "JOIN Unit u ON p.unit_id = u.unit_id "
                + "WHERE iti.it_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transferId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryTransferItem item = new InventoryTransferItem();
                    item.setItemId(rs.getInt("it_item_id"));
                    item.setTransferId(rs.getInt("it_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setProductCode(rs.getString("product_code"));
                    item.setQuantity(rs.getInt("quantity"));

                    Unit unit = new Unit();
                    unit.setUnitId(rs.getInt("unit_id"));
                    unit.setUnitName(rs.getString("unit_name"));
                    unit.setUnitCode(rs.getString("unit_code"));
                    item.setUnit(unit);

                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public int createInventoryTransfer(InventoryTransfer transfer) {
        String sql = "INSERT INTO Inventory_Transfer "
                + "(source_warehouse_id, destination_warehouse_id, date, status, description, created_by, import_request_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, transfer.getSourceWarehouseId());
            ps.setInt(2, transfer.getDestinationWarehouseId());
            
            LocalDateTime date = transfer.getDate() != null 
                    ? transfer.getDate() : LocalDateTime.now();
            ps.setTimestamp(3, Timestamp.valueOf(date));
            
            ps.setString(4, transfer.getStatus() != null ? transfer.getStatus() : "draft");
            ps.setString(5, transfer.getDescription());
            ps.setInt(6, transfer.getCreatedBy());
            if (transfer.getImportRequestId() != null) {
                ps.setInt(7, transfer.getImportRequestId());
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                return -1;
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    return -1;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public boolean updateInventoryTransfer(InventoryTransfer transfer) {
        String sql = "UPDATE Inventory_Transfer SET "
                + "source_warehouse_id = ?, destination_warehouse_id = ?, "
                + "status = ?, description = ?, import_request_id = ? "
                + "WHERE it_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transfer.getSourceWarehouseId());
            ps.setInt(2, transfer.getDestinationWarehouseId());
            ps.setString(3, transfer.getStatus());
            ps.setString(4, transfer.getDescription());
            if (transfer.getImportRequestId() != null) {
                ps.setInt(5, transfer.getImportRequestId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            ps.setInt(6, transfer.getTransferId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addInventoryTransferItem(InventoryTransferItem item) {
        String sql = "INSERT INTO Inventory_Transfer_Item (it_id, product_id, quantity) VALUES (?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, item.getTransferId());
            ps.setInt(2, item.getProductId());
            ps.setInt(3, item.getQuantity());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateInventoryTransferItem(InventoryTransferItem item) {
        String sql = "UPDATE Inventory_Transfer_Item SET product_id = ?, quantity = ? WHERE it_item_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, item.getProductId());
            ps.setInt(2, item.getQuantity());
            ps.setInt(3, item.getItemId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteInventoryTransferItem(int itemId) {
        String sql = "DELETE FROM Inventory_Transfer_Item WHERE it_item_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteInventoryTransfer(int transferId) {
        Connection conn = connection;
        boolean autoCommit = true;

        try {
            autoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            // First delete all items
            String deleteItemsSql = "DELETE FROM Inventory_Transfer_Item WHERE it_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteItemsSql)) {
                ps.setInt(1, transferId);
                ps.executeUpdate();
            }

            // Then delete the transfer
            String deleteTransferSql = "DELETE FROM Inventory_Transfer WHERE it_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteTransferSql)) {
                ps.setInt(1, transferId);
                int rowsAffected = ps.executeUpdate();
                
                if (rowsAffected > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }

        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                conn.setAutoCommit(autoCommit);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    public boolean deleteAllInventoryTransferItems(int transferId) {
        String sql = "DELETE FROM Inventory_Transfer_Item WHERE it_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transferId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createInventoryTransferWithItems(InventoryTransfer transfer, List<InventoryTransferItem> items) {
        Connection conn = connection;
        boolean autoCommit = true;

        try {
            autoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            // Create inventory transfer first
            int transferId = createInventoryTransfer(transfer);
            if (transferId <= 0) {
                conn.rollback();
                return false;
            }

            // Create transfer items
            String itemSql = "INSERT INTO Inventory_Transfer_Item (it_id, product_id, quantity) VALUES (?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(itemSql)) {
                for (InventoryTransferItem item : items) {
                    ps.setInt(1, transferId);
                    ps.setInt(2, item.getProductId());
                    ps.setInt(3, item.getQuantity());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                conn.setAutoCommit(autoCommit);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    public List<InventoryTransferDisplay> getPendingInventoryTransfersForWarehouse(int warehouseId) {
    List<InventoryTransferDisplay> list = new ArrayList<>();
    String sql = "SELECT TOP 10 it.it_id AS transferId, sw.warehouse_name AS sourceWarehouseName, dw.warehouse_name AS destinationWarehouseName, " +
                 "it.date, it.status " +
                 "FROM Inventory_Transfer it " +
                 "JOIN Warehouse sw ON it.source_warehouse_id = sw.warehouse_id " +
                 "JOIN Warehouse dw ON it.destination_warehouse_id = dw.warehouse_id " +
                 "WHERE it.status IN ('Pending', 'Processing') AND (it.source_warehouse_id = ? OR it.destination_warehouse_id = ?) " +
                 "ORDER BY it.date DESC";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, warehouseId);
        ps.setInt(2, warehouseId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                InventoryTransferDisplay itd = new InventoryTransferDisplay();
                itd.setTransferId(rs.getInt("transferId"));
                itd.setSourceWarehouseName(rs.getString("sourceWarehouseName"));
                itd.setDestinationWarehouseName(rs.getString("destinationWarehouseName"));
                itd.setDate(rs.getTimestamp("date").toLocalDateTime());
                itd.setStatus(rs.getString("status"));
                list.add(itd);
            }
        }
    } catch (Exception e) {
        System.out.println("getPendingInventoryTransfersForWarehouse: " + e.getMessage());
    }
    return list;
}

    private InventoryTransfer mapInventoryTransfer(ResultSet rs) throws SQLException {
        InventoryTransfer transfer = new InventoryTransfer();
        transfer.setTransferId(rs.getInt("it_id"));
        transfer.setSourceWarehouseId(rs.getInt("source_warehouse_id"));
        transfer.setSourceWarehouseName(rs.getString("source_warehouse_name"));
        transfer.setDestinationWarehouseId(rs.getInt("destination_warehouse_id"));
        transfer.setDestinationWarehouseName(rs.getString("destination_warehouse_name"));
        
        Timestamp date = rs.getTimestamp("date");
        if (date != null) {
            transfer.setDate(date.toLocalDateTime());
        }
        
        transfer.setStatus(rs.getString("status"));
        transfer.setDescription(rs.getString("description"));
        transfer.setCreatedBy(rs.getInt("created_by"));
        transfer.setCreatorName(rs.getString("creator_name"));
        
        // Handle import_request_id (may be null)
        int importRequestId = rs.getInt("import_request_id");
        if (!rs.wasNull()) {
            transfer.setImportRequestId(importRequestId);
        }

        return transfer;
    }
}