package dao;

import java.sql.*;
import java.util.*;
import model.SalesOrder;
import model.SalesOrderItem;
import model.User;
import model.SalesOrderDisplay;
import utils.WarehouseAuthUtil;

public class SalesOrderDAO extends DBConnect {

    /**
     * Tạo sales order mới - SỬA ĐỂ TRẢ VỀ ID và thêm warehouse_id
     */
    public int createSalesOrder(SalesOrder salesOrder) {
        String sql = "INSERT INTO Sales_Order (customer_id, user_id, [date], status, order_number, total_amount, delivery_date, delivery_address, notes, warehouse_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, salesOrder.getCustomerId());
            ps.setInt(2, salesOrder.getUserId());
            ps.setTimestamp(3, new java.sql.Timestamp(salesOrder.getOrderDate().getTime()));
            ps.setString(4, salesOrder.getStatus());
            ps.setString(5, salesOrder.getOrderNumber());
            ps.setBigDecimal(6, salesOrder.getTotalAmount());

            if (salesOrder.getDeliveryDate() != null) {
                ps.setDate(7, new java.sql.Date(salesOrder.getDeliveryDate().getTime()));
            } else {
                ps.setNull(7, Types.DATE);
            }

            ps.setString(8, salesOrder.getDeliveryAddress());
            ps.setString(9, salesOrder.getNotes());
            ps.setInt(10, salesOrder.getWarehouseId());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Trả về ID mới tạo
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating sales order: " + e.getMessage());
            e.printStackTrace();
        }
        return 0; // Trả về 0 nếu thất bại
    }

    /**
     * ★ FIXED: Cập nhật sales order - cho phép cập nhật order có status 'Order'
     */
    public boolean updateSalesOrder(SalesOrder salesOrder) {
        // ★ FIX: Thay đổi điều kiện từ 'Pending' thành 'Order'
        String sql = "UPDATE Sales_Order SET customer_id = ?, user_id = ?, [date] = ?, "
                + "total_amount = ?, delivery_date = ?, delivery_address = ?, notes = ?, warehouse_id = ? "
                + "WHERE so_id = ? AND status = 'Order'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, salesOrder.getCustomerId());
            ps.setInt(2, salesOrder.getUserId());
            ps.setTimestamp(3, new java.sql.Timestamp(salesOrder.getOrderDate().getTime()));
            ps.setBigDecimal(4, salesOrder.getTotalAmount());

            if (salesOrder.getDeliveryDate() != null) {
                ps.setDate(5, new java.sql.Date(salesOrder.getDeliveryDate().getTime()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, salesOrder.getDeliveryAddress());
            ps.setString(7, salesOrder.getNotes());
            ps.setInt(8, salesOrder.getWarehouseId());
            ps.setInt(9, salesOrder.getSoId());

            System.out.println("DEBUG: Executing update for soId=" + salesOrder.getSoId() + ", status should be 'Order'");

            int rows = ps.executeUpdate();

            System.out.println("DEBUG: Update affected " + rows + " rows");

            return rows > 0;

        } catch (SQLException e) {
            System.err.println("Error updating sales order: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ★ NEW: Cập nhật sales order không kiểm tra status (dành cho các trường
     * hợp đặc biệt)
     */
    public boolean updateSalesOrderWithoutStatusCheck(SalesOrder salesOrder) {
        String sql = "UPDATE Sales_Order SET customer_id = ?, user_id = ?, [date] = ?, "
                + "total_amount = ?, delivery_date = ?, delivery_address = ?, notes = ?, warehouse_id = ? "
                + "WHERE so_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, salesOrder.getCustomerId());
            ps.setInt(2, salesOrder.getUserId());
            ps.setTimestamp(3, new java.sql.Timestamp(salesOrder.getOrderDate().getTime()));
            ps.setBigDecimal(4, salesOrder.getTotalAmount());

            if (salesOrder.getDeliveryDate() != null) {
                ps.setDate(5, new java.sql.Date(salesOrder.getDeliveryDate().getTime()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, salesOrder.getDeliveryAddress());
            ps.setString(7, salesOrder.getNotes());
            ps.setInt(8, salesOrder.getWarehouseId());
            ps.setInt(9, salesOrder.getSoId());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("Error updating sales order without status check: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE Sales_Order SET status = ? WHERE so_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setLong(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Hủy sales order
     */
    public boolean cancelSalesOrder(int soId, String cancellationReason, int cancelledBy) {
        String sql = "UPDATE Sales_Order SET status = 'Cancelled', cancelled_at = GETDATE(), "
                + "cancelled_by = ?, cancellation_reason = ? WHERE so_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cancelledBy);
            ps.setString(2, cancellationReason);
            ps.setInt(3, soId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("Error cancelling sales order: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update sales order status to "returning"
     *
     */
    public boolean updateSalesOrderToReturning(int soId) {
        String sql = "UPDATE Sales_Order SET status = 'returning' WHERE so_id = ? AND status = 'Delivery'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, soId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error updating sales order to returning: " + e.getMessage());
            return false;
        }
    }

    /**
     * Update sales order status to "returned"
     */
    public boolean updateSalesOrderToReturned(int soId) {
        String sql = "UPDATE Sales_Order SET status = 'returned' WHERE so_id = ? AND status = 'returning'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, soId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error updating sales order to returned: " + e.getMessage());
            return false;
        }
    }

    /**
     * Update sales order status to "Completed"
     */
    public boolean updateSalesOrderToCompleted(int soId) {
        String sql = "UPDATE Sales_Order SET status = 'Completed' WHERE so_id = ? AND status = 'Delivery'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, soId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error updating sales order to completed: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get all sales orders with "Pending" status for export transfer orders
     */
    public List<SalesOrder> getAllSalesOrders(User currentUser) {
        List<SalesOrder> orders = new ArrayList<>();

        String sql = "SELECT so.so_id, so.customer_id, so.[date], so.status, so.total_amount, "
                + "so.user_id, so.order_number, so.delivery_date, so.delivery_address, so.notes, "
                + "so.warehouse_id, so.cancellation_reason, so.cancelled_by, so.cancelled_at, "
                + "c.customer_name, c.email as customer_email, "
                + "u.first_name + ' ' + u.last_name as user_name, "
                + "w.warehouse_name, w.address as warehouse_address "
                + "FROM Sales_Order so "
                + "LEFT JOIN Customer c ON so.customer_id = c.customer_id "
                + "LEFT JOIN [User] u ON so.user_id = u.user_id "
                + "LEFT JOIN Warehouse w ON so.warehouse_id = w.warehouse_id";

        // ★ WAREHOUSE FILTERING
        String whereClause = WarehouseAuthUtil.getWarehouseWhereClause(currentUser, "so");
        if (!whereClause.isEmpty()) {
            sql += " WHERE " + whereClause;
        }

        sql += " ORDER BY so.[date] DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SalesOrder order = mapResultSetToSalesOrder(rs);
                orders.add(order);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all sales orders: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * ★ OVERLOAD: Backward compatibility cho code cũ
     */
    public List<SalesOrder> getAllSalesOrders() {
        // Trả về tất cả orders (cho Admin hoặc khi không cần filter)
        return getAllSalesOrdersInternal();
    }

    /**
     * Internal method để lấy tất cả orders không filter
     */
    private List<SalesOrder> getAllSalesOrdersInternal() {
        List<SalesOrder> orders = new ArrayList<>();
        String sql = "SELECT so.so_id, so.customer_id, so.[date], so.status, so.total_amount, "
                + "so.user_id, so.order_number, so.delivery_date, so.delivery_address, so.notes, "
                + "so.warehouse_id, so.cancellation_reason, so.cancelled_by, so.cancelled_at, "
                + "c.customer_name, c.email as customer_email, "
                + "u.first_name + ' ' + u.last_name as user_name, "
                + "w.warehouse_name, w.address as warehouse_address "
                + "FROM Sales_Order so "
                + "LEFT JOIN Customer c ON so.customer_id = c.customer_id "
                + "LEFT JOIN [User] u ON so.user_id = u.user_id "
                + "LEFT JOIN Warehouse w ON so.warehouse_id = w.warehouse_id "
                + "ORDER BY so.[date] DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SalesOrder order = mapResultSetToSalesOrder(rs);
                orders.add(order);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all sales orders: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * ★ FIXED: Get pending sales orders với warehouse filtering - CẬP NHẬT
     * THÀNH 'Order'
     */
    public List<SalesOrder> getAllPendingSalesOrders(User currentUser) {
        List<SalesOrder> orders = new ArrayList<>();
        String sql = "SELECT so.so_id, so.customer_id, so.[date], so.status, so.total_amount, "
                + "so.user_id, so.order_number, so.delivery_date, so.delivery_address, so.notes, "
                + "so.warehouse_id, so.cancellation_reason, so.cancelled_by, so.cancelled_at, "
                + "c.customer_name, c.email as customer_email, "
                + "u.first_name + ' ' + u.last_name as user_name, "
                + "w.warehouse_name, w.address as warehouse_address "
                + "FROM Sales_Order so "
                + "LEFT JOIN Customer c ON so.customer_id = c.customer_id "
                + "LEFT JOIN [User] u ON so.user_id = u.user_id "
                + "LEFT JOIN Warehouse w ON so.warehouse_id = w.warehouse_id "
                + "WHERE so.status = 'Order'"; // ★ FIXED: Thay 'Pending' thành 'Order'

        // ★ WAREHOUSE FILTERING
        String whereClause = WarehouseAuthUtil.getWarehouseWhereClause(currentUser, "so");
        if (!whereClause.isEmpty()) {
            sql += " AND " + whereClause;
        }

        sql += " ORDER BY so.[date] DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                orders.add(mapResultSetToSalesOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting processing sales orders: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * ★ OVERLOAD: Backward compatibility
     */
    public List<SalesOrder> getAllPendingSalesOrders() {
        return getAllPendingSalesOrdersInternal();
    }

    private List<SalesOrder> getAllPendingSalesOrdersInternal() {
        List<SalesOrder> orders = new ArrayList<>();
        String sql = "SELECT so.so_id, so.customer_id, so.[date], so.status, so.total_amount, "
                + "so.user_id, so.order_number, so.delivery_date, so.delivery_address, so.notes, "
                + "so.warehouse_id, so.cancellation_reason, so.cancelled_by, so.cancelled_at, "
                + "c.customer_name, c.email as customer_email, "
                + "u.first_name + ' ' + u.last_name as user_name, "
                + "w.warehouse_name, w.address as warehouse_address "
                + "FROM Sales_Order so "
                + "LEFT JOIN Customer c ON so.customer_id = c.customer_id "
                + "LEFT JOIN [User] u ON so.user_id = u.user_id "
                + "LEFT JOIN Warehouse w ON so.warehouse_id = w.warehouse_id "
                + "WHERE so.status = 'Order' "
                + // ★ FIXED: Thay 'Pending' thành 'Order'
                "ORDER BY so.[date] DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                orders.add(mapResultSetToSalesOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting processing sales orders: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * ★ FIXED: Lấy sales order theo ID với warehouse access check
     */
    public SalesOrder getSalesOrderById(int soId, User currentUser) {
        String sql = "SELECT so.so_id, so.customer_id, so.[date], so.status, so.total_amount, "
                + "so.user_id, so.order_number, so.delivery_date, so.delivery_address, so.notes, "
                + "so.warehouse_id, so.cancellation_reason, so.cancelled_by, so.cancelled_at, "
                + "c.customer_name, c.email as customer_email, "
                + "u.first_name + ' ' + u.last_name as user_name, "
                + "cb.first_name + ' ' + cb.last_name as cancelled_by_name, "
                + "w.warehouse_name, w.address as warehouse_address "
                + "FROM Sales_Order so "
                + "LEFT JOIN Customer c ON so.customer_id = c.customer_id "
                + "LEFT JOIN [User] u ON so.user_id = u.user_id "
                + "LEFT JOIN [User] cb ON so.cancelled_by = cb.user_id "
                + "LEFT JOIN Warehouse w ON so.warehouse_id = w.warehouse_id "
                + "WHERE so.so_id = ?";

        // ★ WAREHOUSE FILTERING
        String whereClause = WarehouseAuthUtil.getWarehouseWhereClause(currentUser, "so");
        if (!whereClause.isEmpty()) {
            sql += " AND " + whereClause;
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, soId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SalesOrder order = mapResultSetToSalesOrder(rs);
                    order.setCancelledByName(rs.getString("cancelled_by_name"));

                    // Load order items
                    SalesOrderItemDAO itemDAO = new SalesOrderItemDAO();
                    List<SalesOrderItem> items = itemDAO.getSalesOrderItemsBySoId(soId);
                    order.setItems(items);

                    return order;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting sales order by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * ★ OVERLOAD: Backward compatibility - không filter warehouse
     */
    public SalesOrder getSalesOrderById(int soId) {
        return getSalesOrderByIdInternal(soId);
    }

    private SalesOrder getSalesOrderByIdInternal(int soId) {
        String sql = "SELECT so.so_id, so.customer_id, so.[date], so.status, so.total_amount, "
                + "so.user_id, so.order_number, so.delivery_date, so.delivery_address, so.notes, "
                + "so.warehouse_id, so.cancellation_reason, so.cancelled_by, so.cancelled_at, "
                + "c.customer_name, c.email as customer_email, "
                + "u.first_name + ' ' + u.last_name as user_name, "
                + "cb.first_name + ' ' + cb.last_name as cancelled_by_name, "
                + "w.warehouse_name, w.address as warehouse_address "
                + "FROM Sales_Order so "
                + "LEFT JOIN Customer c ON so.customer_id = c.customer_id "
                + "LEFT JOIN [User] u ON so.user_id = u.user_id "
                + "LEFT JOIN [User] cb ON so.cancelled_by = cb.user_id "
                + "LEFT JOIN Warehouse w ON so.warehouse_id = w.warehouse_id "
                + "WHERE so.so_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, soId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SalesOrder order = mapResultSetToSalesOrder(rs);
                    order.setCancelledByName(rs.getString("cancelled_by_name"));

                    // Load order items
                    SalesOrderItemDAO itemDAO = new SalesOrderItemDAO();
                    List<SalesOrderItem> items = itemDAO.getSalesOrderItemsBySoId(soId);
                    order.setItems(items);

                    return order;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting sales order by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Map ResultSet to SalesOrder object với warehouse info
     */
    private SalesOrder mapResultSetToSalesOrder(ResultSet rs) throws SQLException {
        SalesOrder order = new SalesOrder();
        order.setSoId(rs.getInt("so_id"));
        order.setCustomerId(rs.getInt("customer_id"));
        order.setOrderDate(rs.getTimestamp("date"));
        order.setStatus(rs.getString("status"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderNumber(rs.getString("order_number"));
        order.setDeliveryDate(rs.getDate("delivery_date"));
        order.setDeliveryAddress(rs.getString("delivery_address"));
        order.setNotes(rs.getString("notes"));
        order.setWarehouseId(rs.getInt("warehouse_id"));
        order.setCancellationReason(rs.getString("cancellation_reason"));

        // Handle nullable cancelled_by
        int cancelledBy = rs.getInt("cancelled_by");
        if (!rs.wasNull()) {
            order.setCancelledBy(cancelledBy);
        }

        order.setCancelledAt(rs.getTimestamp("cancelled_at"));

        // Set related information
        order.setCustomerName(rs.getString("customer_name"));
        order.setCustomerEmail(rs.getString("customer_email"));
        order.setUserName(rs.getString("user_name"));
        order.setWarehouseName(rs.getString("warehouse_name"));
        order.setWarehouseAddress(rs.getString("warehouse_address"));

        return order;
    }

    /**
     * ★ FIXED: Search sales orders với warehouse filtering
     */
    public List<SalesOrder> searchSalesOrders(String orderNumber, String customerName, String status,
            java.util.Date fromDate, java.util.Date toDate, User currentUser) {
        List<SalesOrder> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT so.so_id, so.customer_id, so.[date], so.status, so.total_amount, ");
        sql.append("so.user_id, so.order_number, so.delivery_date, so.delivery_address, so.notes, ");
        sql.append("so.warehouse_id, so.cancellation_reason, so.cancelled_by, so.cancelled_at, ");
        sql.append("c.customer_name, c.email as customer_email, ");
        sql.append("u.first_name + ' ' + u.last_name as user_name, ");
        sql.append("w.warehouse_name, w.address as warehouse_address ");
        sql.append("FROM Sales_Order so ");
        sql.append("LEFT JOIN Customer c ON so.customer_id = c.customer_id ");
        sql.append("LEFT JOIN [User] u ON so.user_id = u.user_id ");
        sql.append("LEFT JOIN Warehouse w ON so.warehouse_id = w.warehouse_id ");
        sql.append("WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();

        // ★ WAREHOUSE FILTERING
        String whereClause = WarehouseAuthUtil.getWarehouseWhereClause(currentUser, "so");
        if (!whereClause.isEmpty()) {
            sql.append("AND ").append(whereClause).append(" ");
        }

        if (orderNumber != null && !orderNumber.trim().isEmpty()) {
            sql.append("AND so.order_number LIKE ? ");
            parameters.add("%" + orderNumber.trim() + "%");
        }

        if (customerName != null && !customerName.trim().isEmpty()) {
            sql.append("AND c.customer_name LIKE ? ");
            parameters.add("%" + customerName.trim() + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND so.status = ? ");
            parameters.add(status.trim());
        }

        if (fromDate != null) {
            sql.append("AND so.[date] >= ? ");
            parameters.add(new java.sql.Date(fromDate.getTime()));
        }

        if (toDate != null) {
            sql.append("AND so.[date] <= ? ");
            parameters.add(new java.sql.Date(toDate.getTime()));
        }

        sql.append("ORDER BY so.[date] DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesOrder order = mapResultSetToSalesOrder(rs);
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching sales orders: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * ★ FIXED: Lấy tất cả sales orders của một khách hàng với warehouse
     * filtering
     */
    public List<SalesOrder> getSalesOrdersByCustomerId(int customerId, User currentUser) {
        List<SalesOrder> orders = new ArrayList<>();
        String sql = "SELECT so.so_id, so.customer_id, so.[date], so.status, so.total_amount, "
                + "so.user_id, so.order_number, so.delivery_date, so.delivery_address, so.notes, "
                + "so.warehouse_id, so.cancellation_reason, so.cancelled_by, so.cancelled_at, "
                + "c.customer_name, c.email as customer_email, "
                + "u.first_name + ' ' + u.last_name as user_name, "
                + "w.warehouse_name, w.address as warehouse_address "
                + "FROM Sales_Order so "
                + "LEFT JOIN Customer c ON so.customer_id = c.customer_id "
                + "LEFT JOIN [User] u ON so.user_id = u.user_id "
                + "LEFT JOIN Warehouse w ON so.warehouse_id = w.warehouse_id "
                + "WHERE so.customer_id = ?";

        // ★ WAREHOUSE FILTERING
        String whereClause = WarehouseAuthUtil.getWarehouseWhereClause(currentUser, "so");
        if (!whereClause.isEmpty()) {
            sql += " AND " + whereClause;
        }

        sql += " ORDER BY so.[date] DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesOrder order = mapResultSetToSalesOrder(rs);
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting customer sales orders: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * ★ OVERLOAD: Backward compatibility
     */
    public List<SalesOrder> getSalesOrdersByCustomerId(int customerId) {
        return getSalesOrdersByCustomerIdInternal(customerId);
    }

    private List<SalesOrder> getSalesOrdersByCustomerIdInternal(int customerId) {
        List<SalesOrder> orders = new ArrayList<>();
        String sql = "SELECT so.so_id, so.customer_id, so.[date], so.status, so.total_amount, "
                + "so.user_id, so.order_number, so.delivery_date, so.delivery_address, so.notes, "
                + "so.warehouse_id, so.cancellation_reason, so.cancelled_by, so.cancelled_at, "
                + "c.customer_name, c.email as customer_email, "
                + "u.first_name + ' ' + u.last_name as user_name, "
                + "w.warehouse_name, w.address as warehouse_address "
                + "FROM Sales_Order so "
                + "LEFT JOIN Customer c ON so.customer_id = c.customer_id "
                + "LEFT JOIN [User] u ON so.user_id = u.user_id "
                + "LEFT JOIN Warehouse w ON so.warehouse_id = w.warehouse_id "
                + "WHERE so.customer_id = ? "
                + "ORDER BY so.[date] DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesOrder order = mapResultSetToSalesOrder(rs);
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting customer sales orders: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Get all sales orders with "returning" status for import transfer orders
     */
    public List<SalesOrder> getReturningSalesOrdersByWarehouse(int warehouseId) {
        List<SalesOrder> salesOrders = new ArrayList<>();
        String sql = "SELECT so.*, c.customer_name, c.email as customer_email, "
                + "u.first_name + ' ' + u.last_name as user_name, "
                + "w.warehouse_name, w.address as warehouse_address "
                + "FROM Sales_Order so "
                + "JOIN Customer c ON so.customer_id = c.customer_id "
                + "JOIN [User] u ON so.user_id = u.user_id "
                + "JOIN Warehouse w ON so.warehouse_id = w.warehouse_id "
                + "WHERE so.status = 'returning' AND so.warehouse_id = ? "
                + "ORDER BY so.[date] DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                salesOrders.add(mapResultSetToSalesOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting returning sales orders: " + e.getMessage());
        }

        return salesOrders;
    }

    public List<SalesOrderDisplay> getSalesOrdersForWarehouse(int warehouseId) {
        List<SalesOrderDisplay> list = new ArrayList<>();
        String sql = "SELECT TOP 5 so.so_id, c.customer_name, so.[date], so.status "
                + "FROM Sales_Order so "
                + "JOIN Customer c ON so.customer_id = c.customer_id "
                + "WHERE so.status IN ('Order', 'Delivery', 'Returning') AND so.warehouse_id = ? "
                + "ORDER BY so.[date] DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesOrderDisplay so = new SalesOrderDisplay();
                    so.setSoId(rs.getInt("so_id"));
                    so.setCustomerName(rs.getString("customer_name"));
                    so.setOrderDate(rs.getDate("date"));
                    so.setStatus(rs.getString("status"));
                    list.add(so);
                }
            }
        } catch (Exception e) {
            System.out.println("getSalesOrdersForWarehouse: " + e.getMessage());
        }
        return list;
    }
}
