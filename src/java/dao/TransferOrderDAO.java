package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.TransferOrder;
import model.TransferOrderItem;
import model.Unit;

public class TransferOrderDAO extends DBConnect {

    public List<TransferOrder> getAllTransferOrders() {
        List<TransferOrder> transferOrders = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "sw.warehouse_name AS source_warehouse_name, "
                + "dw.warehouse_name AS destination_warehouse_name, "
                + "u1.first_name + ' ' + u1.last_name AS creator_name, "
                + "u2.first_name + ' ' + u2.last_name AS approver_name "
                + "FROM Transfer_Order t "
                + "JOIN Warehouse sw ON t.source_warehouse_id = sw.warehouse_id "
                + "LEFT JOIN Warehouse dw ON t.destination_warehouse_id = dw.warehouse_id "
                + "JOIN [User] u1 ON t.created_by = u1.user_id "
                + "LEFT JOIN [User] u2 ON t.approved_by = u2.user_id "
                + "ORDER BY t.created_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TransferOrder order = mapTransferOrder(rs);
                transferOrders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transferOrders;
    }

    public List<TransferOrder> getTransferOrdersByType(String transferType) {
        List<TransferOrder> transferOrders = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "sw.warehouse_name AS source_warehouse_name, "
                + "dw.warehouse_name AS destination_warehouse_name, "
                + "u1.first_name + ' ' + u1.last_name AS creator_name, "
                + "u2.first_name + ' ' + u2.last_name AS approver_name "
                + "FROM Transfer_Order t "
                + "JOIN Warehouse sw ON t.source_warehouse_id = sw.warehouse_id "
                + "LEFT JOIN Warehouse dw ON t.destination_warehouse_id = dw.warehouse_id "
                + "JOIN [User] u1 ON t.created_by = u1.user_id "
                + "LEFT JOIN [User] u2 ON t.approved_by = u2.user_id "
                + "WHERE t.transfer_type = ? "
                + "ORDER BY t.created_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, transferType);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TransferOrder order = mapTransferOrder(rs);
                    transferOrders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transferOrders;
    }

    public List<TransferOrder> getTransferOrdersByStatus(String status) {
        List<TransferOrder> transferOrders = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "sw.warehouse_name AS source_warehouse_name, "
                + "dw.warehouse_name AS destination_warehouse_name, "
                + "u1.first_name + ' ' + u1.last_name AS creator_name, "
                + "u2.first_name + ' ' + u2.last_name AS approver_name "
                + "FROM Transfer_Order t "
                + "JOIN Warehouse sw ON t.source_warehouse_id = sw.warehouse_id "
                + "LEFT JOIN Warehouse dw ON t.destination_warehouse_id = dw.warehouse_id "
                + "JOIN [User] u1 ON t.created_by = u1.user_id "
                + "LEFT JOIN [User] u2 ON t.approved_by = u2.user_id "
                + "WHERE t.status = ? "
                + "ORDER BY t.created_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TransferOrder order = mapTransferOrder(rs);
                    transferOrders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transferOrders;
    }

    public TransferOrder getTransferOrderById(int transferId) {
        String sql = "SELECT t.*, "
                + "sw.warehouse_name AS source_warehouse_name, "
                + "dw.warehouse_name AS destination_warehouse_name, "
                + "u1.first_name + ' ' + u1.last_name AS creator_name, "
                + "u2.first_name + ' ' + u2.last_name AS approver_name "
                + "FROM Transfer_Order t "
                + "JOIN Warehouse sw ON t.source_warehouse_id = sw.warehouse_id "
                + "LEFT JOIN Warehouse dw ON t.destination_warehouse_id = dw.warehouse_id "
                + "JOIN [User] u1 ON t.created_by = u1.user_id "
                + "LEFT JOIN [User] u2 ON t.approved_by = u2.user_id "
                + "WHERE t.to_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transferId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TransferOrder order = mapTransferOrder(rs);
                    order.setItems(getTransferOrderItems(transferId));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<TransferOrderItem> getTransferOrderItems(int transferId) {
        List<TransferOrderItem> items = new ArrayList<>();
        String sql = "SELECT ti.*, p.name AS product_name, p.code AS product_code, p.price AS unit_price, "
                + "u.unit_id, u.unit_name, u.unit_code "
                + "FROM Transfer_Order_Item ti "
                + "JOIN Product p ON ti.product_id = p.product_id "
                + "JOIN Unit u ON p.unit_id = u.unit_id "
                + "WHERE ti.to_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transferId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TransferOrderItem item = new TransferOrderItem();
                    item.setToItemId(rs.getInt("to_item_id"));
                    item.setToId(rs.getInt("to_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setProductCode(rs.getString("product_code"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));

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

    public int createTransferOrder(TransferOrder order) {
        String sql = "INSERT INTO Transfer_Order "
                + "(source_warehouse_id, destination_warehouse_id, document_ref_id, document_ref_type, transfer_type, "
                + "status, description, created_by, transfer_date, created_date) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, order.getSourceWarehouseId());

            if (order.getDestinationWarehouseId() != null) {
                ps.setInt(2, order.getDestinationWarehouseId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            if (order.getDocumentRefId() != null) {
                ps.setInt(3, order.getDocumentRefId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            if (order.getDocumentRefType() != null) {
                ps.setString(4, order.getDocumentRefType());
            } else {
                ps.setNull(4, Types.VARCHAR);
            }

            ps.setString(5, order.getTransferType());
            ps.setString(6, order.getStatus() != null ? order.getStatus() : "draft");
            ps.setString(7, order.getDescription());
            ps.setInt(8, order.getCreatedBy());

            LocalDateTime transferDate = order.getTransferDate() != null
                    ? order.getTransferDate() : LocalDateTime.now();
            ps.setTimestamp(9, Timestamp.valueOf(transferDate));

            LocalDateTime createdDate = order.getCreatedDate() != null
                    ? order.getCreatedDate() : LocalDateTime.now();
            ps.setTimestamp(10, Timestamp.valueOf(createdDate));

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int orderId = generatedKeys.getInt(1);
                        return orderId;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean addTransferOrderItem(TransferOrderItem item) {
        String sql = "INSERT INTO Transfer_Order_Item (to_id, product_id, quantity) VALUES (?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, item.getToId());
            ps.setInt(2, item.getProductId());
            ps.setInt(3, item.getQuantity());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTransferOrder(TransferOrder order) {
        String sql = "UPDATE Transfer_Order SET "
                + "source_warehouse_id = ?, destination_warehouse_id = ?, document_ref_id = ?, document_ref_type = ?, "
                + "transfer_type = ?, status = ?, description = ?, approved_by = ?, "
                + "transfer_date = ? WHERE to_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, order.getSourceWarehouseId());

            if (order.getDestinationWarehouseId() != null) {
                ps.setInt(2, order.getDestinationWarehouseId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            if (order.getDocumentRefId() != null) {
                ps.setInt(3, order.getDocumentRefId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            if (order.getDocumentRefType() != null) {
                ps.setString(4, order.getDocumentRefType());
            } else {
                ps.setNull(4, Types.VARCHAR);
            }

            ps.setString(5, order.getTransferType());
            ps.setString(6, order.getStatus());
            ps.setString(7, order.getDescription());

            if (order.getApprovedBy() != null) {
                ps.setInt(8, order.getApprovedBy());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            ps.setTimestamp(9, Timestamp.valueOf(order.getTransferDate()));
            ps.setInt(10, order.getTransferId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTransferOrderStatus(int transferId, String newStatus, Integer approvedBy) {
        String sql = "UPDATE Transfer_Order SET status = ?, approved_by = ? WHERE to_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);

            if (approvedBy != null) {
                ps.setInt(2, approvedBy);
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setInt(3, transferId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTransferOrderStatus(TransferOrder order) {
        return updateTransferOrderStatus(order.getTransferId(), order.getStatus(), order.getApprovedBy());
    }

    public boolean completeTransferOrderWithSalesOrderUpdate(int transferId, Integer approvedBy, String referenceDocumentId) {
        try {
            connection.setAutoCommit(false);
            
            // Update transfer order status to Complete
            String updateTransferSql = "UPDATE Transfer_Order SET status = 'Complete', approved_by = ? WHERE to_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(updateTransferSql)) {
                if (approvedBy != null) {
                    ps.setInt(1, approvedBy);
                } else {
                    ps.setNull(1, Types.INTEGER);
                }
                ps.setInt(2, transferId);
                
                int rowsUpdated = ps.executeUpdate();
                if (rowsUpdated == 0) {
                    connection.rollback();
                    return false;
                }
            }
            
            // Update referenced sales order status based on reference document type
            if (referenceDocumentId != null) {
                if (referenceDocumentId.startsWith("RSO-")) {
                    // Update returning sales order status to "returned"
                    String soIdStr = referenceDocumentId.substring(4); // Remove "RSO-" prefix
                    try {
                        int soId = Integer.parseInt(soIdStr);
                        String updateSalesOrderSql = "UPDATE Sales_Order SET status = 'returned' WHERE so_id = ? AND status = 'returning'";
                        try (PreparedStatement ps = connection.prepareStatement(updateSalesOrderSql)) {
                            ps.setInt(1, soId);
                            ps.executeUpdate();
                        }
                    } catch (NumberFormatException e) {
                        // Invalid SO ID, continue without updating
                    }
                } else if (referenceDocumentId.startsWith("SO-")) {
                    // Update regular sales order status to "Delivery" when transfer order is completed
                    String soIdStr = referenceDocumentId.substring(3); // Remove "SO-" prefix
                    try {
                        int soId = Integer.parseInt(soIdStr);
                        String updateSalesOrderSql = "UPDATE Sales_Order SET status = 'Delivery' WHERE so_id = ? AND status = 'Order'";
                        try (PreparedStatement ps = connection.prepareStatement(updateSalesOrderSql)) {
                            ps.setInt(1, soId);
                            ps.executeUpdate();
                        }
                    } catch (NumberFormatException e) {
                        // Invalid SO ID, continue without updating
                    }
                }
            }
            
            connection.commit();
            return true;
            
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean deleteTransferOrderItem(int itemId) {
        String sql = "DELETE FROM Transfer_Order_Item WHERE to_item_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteTransferOrder(int transferId) {
        // First delete all items
        String deleteItemsSql = "DELETE FROM Transfer_Order_Item WHERE to_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(deleteItemsSql)) {
            ps.setInt(1, transferId);
            ps.executeUpdate(); // Even if there are no items, we continue

            // Then delete the order
            String deleteOrderSql = "DELETE FROM Transfer_Order WHERE to_id = ?";
            try (PreparedStatement psOrder = connection.prepareStatement(deleteOrderSql)) {
                psOrder.setInt(1, transferId);
                return psOrder.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteAllTransferOrderItems(int transferId) {
        String sql = "DELETE FROM Transfer_Order_Item WHERE to_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transferId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private TransferOrder mapTransferOrder(ResultSet rs) throws SQLException {
        TransferOrder order = new TransferOrder();
        order.setTransferId(rs.getInt("to_id"));
        order.setSourceWarehouseId(rs.getInt("source_warehouse_id"));
        order.setSourceWarehouseName(rs.getString("source_warehouse_name"));

        int destWarehouseId = rs.getInt("destination_warehouse_id");
        if (!rs.wasNull()) {
            order.setDestinationWarehouseId(destWarehouseId);
            order.setDestinationWarehouseName(rs.getString("destination_warehouse_name"));
        }

        int docRefId = rs.getInt("document_ref_id");
        if (!rs.wasNull()) {
            order.setDocumentRefId(docRefId);
        }

        String docRefType = rs.getString("document_ref_type");
        if (docRefType != null) {
            order.setDocumentRefType(docRefType);
        }

        order.setTransferType(rs.getString("transfer_type"));
        order.setStatus(rs.getString("status"));
        order.setDescription(rs.getString("description"));

        int approvedBy = rs.getInt("approved_by");
        if (!rs.wasNull()) {
            order.setApprovedBy(approvedBy);
            order.setApproverName(rs.getString("approver_name"));
        }

        order.setCreatedBy(rs.getInt("created_by"));
        order.setCreatorName(rs.getString("creator_name"));

        Timestamp transferDate = rs.getTimestamp("transfer_date");
        if (transferDate != null) {
            order.setTransferDate(transferDate.toLocalDateTime());
        }

        Timestamp createdDate = rs.getTimestamp("created_date");
        if (createdDate != null) {
            order.setCreatedDate(createdDate.toLocalDateTime());
        }

        return order;
    }

    public boolean createTransferOrderWithItems(TransferOrder order, List<TransferOrderItem> items) {
        Connection conn = connection;
        boolean autoCommit = true;

        try {
            // Save current auto-commit state
            autoCommit = conn.getAutoCommit();

            // Start transaction
            conn.setAutoCommit(false);

            // Create transfer order first
            int orderId = createTransferOrder(order);
            if (orderId <= 0) {
                conn.rollback();
                return false;
            }

            // Add all items
            boolean allItemsAdded = true;
            for (TransferOrderItem item : items) {
                item.setToId(orderId);
                if (!addTransferOrderItem(item)) {
                    allItemsAdded = false;
                    break;
                }
            }

            if (!allItemsAdded) {
                conn.rollback();
                return false;
            }

            // All operations successful, commit transaction
            conn.commit();
            return true;
        } catch (SQLException e) {
            try {
                // Something went wrong, rollback
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                // Restore auto-commit state
                conn.setAutoCommit(autoCommit);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public int createTransferOrderWithItemsAndReturnId(TransferOrder order, List<TransferOrderItem> items) {
        Connection conn = connection;
        boolean autoCommit = true;
        int orderId = -1;

        try {
            // Save current auto-commit state
            autoCommit = conn.getAutoCommit();

            // Start transaction
            conn.setAutoCommit(false);

            // Create transfer order first
            orderId = createTransferOrder(order);
            if (orderId <= 0) {
                conn.rollback();
                return -1;
            }

            // Add all items
            boolean allItemsAdded = true;
            for (TransferOrderItem item : items) {
                item.setToId(orderId);
                if (!addTransferOrderItem(item)) {
                    allItemsAdded = false;
                    break;
                }
            }

            if (!allItemsAdded) {
                conn.rollback();
                return -1;
            }

            // All operations successful, commit transaction
            conn.commit();
            return orderId;
        } catch (SQLException e) {
            try {
                // Something went wrong, rollback
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return -1;
        } finally {
            try {
                // Restore auto-commit state
                conn.setAutoCommit(autoCommit);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean updateTransferOrderWithItems(TransferOrder order, List<TransferOrderItem> items) {
        Connection conn = connection;
        boolean autoCommit = true;

        try {
            // Save current auto-commit state
            autoCommit = conn.getAutoCommit();

            // Start transaction
            conn.setAutoCommit(false);

            // Update transfer order
            if (!updateTransferOrder(order)) {
                conn.rollback();
                return false;
            }

            // Delete existing items
            deleteAllTransferOrderItems(order.getTransferId());

            // Add all new items
            boolean allItemsAdded = true;
            for (TransferOrderItem item : items) {
                item.setToId(order.getTransferId());
                if (!addTransferOrderItem(item)) {
                    allItemsAdded = false;
                    break;
                }
            }

            if (!allItemsAdded) {
                conn.rollback();
                return false;
            }

            // All operations successful, commit transaction
            conn.commit();
            return true;
        } catch (SQLException e) {
            try {
                // Something went wrong, rollback
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                // Restore original auto-commit state
                conn.setAutoCommit(autoCommit);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        // Giả lập kết nối DB (cần cấu hình lại nếu chạy thực tế)
        TransferOrderDAO dao = new TransferOrderDAO();

        // Tạo đơn chuyển kho mẫu
        TransferOrder order = new TransferOrder();
        order.setSourceWarehouseId(1);
        order.setDestinationWarehouseId(2);
        order.setTransferType("transfer");
        order.setStatus("draft");
        order.setDescription("Đơn chuyển kho thử nghiệm");
        order.setCreatedBy(1);

        // Tạo danh sách sản phẩm chuyển kho
        List<TransferOrderItem> items = new ArrayList<>();
        TransferOrderItem item1 = new TransferOrderItem();
        item1.setProductId(1);
        item1.setQuantity(10);
        items.add(item1);

        TransferOrderItem item2 = new TransferOrderItem();
        item2.setProductId(2);
        item2.setQuantity(5);
        items.add(item2);

        // Thêm đơn chuyển kho cùng các sản phẩm
        boolean result = dao.createTransferOrderWithItems(order, items);
        if (result) {
            System.out.println("Tạo đơn chuyển kho thành công!");
        } else {
            System.out.println("Tạo đơn chuyển kho thất bại!");
        }

        // Test case: Đơn nhập kho (Import), không cần DestinationWarehouseId
        TransferOrder importOrder = new TransferOrder();
        importOrder.setSourceWarehouseId(3);
        importOrder.setDestinationWarehouseId(null); // Không cần đích đến
        importOrder.setTransferType("import");
        importOrder.setStatus("draft");
        importOrder.setDescription("Đơn nhập kho thử nghiệm");
        importOrder.setCreatedBy(2);

        List<TransferOrderItem> importItems = new ArrayList<>();
        TransferOrderItem importItem1 = new TransferOrderItem();
        importItem1.setProductId(3);
        importItem1.setQuantity(20);
        importItems.add(importItem1);

        boolean importResult = dao.createTransferOrderWithItems(importOrder, importItems);
        if (importResult) {
            System.out.println("Tạo đơn nhập kho thành công!");
        } else {
            System.out.println("Tạo đơn nhập kho thất bại!");
        }

        // Lấy danh sách tất cả đơn chuyển kho
        List<TransferOrder> orders = dao.getAllTransferOrders();
        System.out.println("Danh sách đơn chuyển kho:");
        for (TransferOrder o : orders) {
            System.out.println("Mã đơn: " + o.getTransferId() + ", Từ kho: " + o.getSourceWarehouseName()
                    + ", Đến kho: " + o.getDestinationWarehouseName() + ", Trạng thái: " + o.getStatus());
        }    }

}
