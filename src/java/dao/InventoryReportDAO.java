package dao;

import model.InventoryReport;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class InventoryReportDAO extends DBConnect {

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
     * Get inventory report with filters and pagination
     */
    public List<InventoryReport> getInventoryReportWithFilters(
            String productFilter,
            Integer warehouseFilter,
            String supplierFilter,
            String stockLevel,
            Integer page,
            Integer pageSize) {

        List<InventoryReport> reports = new ArrayList<>();
        StringBuilder sql = new StringBuilder();

        sql.append("SELECT p.product_id, p.code as product_code, p.name as product_name, ")
                .append("p.price as unit_cost, ")
                .append("ISNULL(i.quantity, 0) as on_hand, ")
                // Free to use: On hand - sales orders (Order) - transfer out (Pending, Processing)
                .append("CASE WHEN (ISNULL(i.quantity, 0) - ISNULL(order_so.total_order, 0) - ISNULL(transfer_out.total_transfer_out, 0)) < 0 THEN 0 ELSE (ISNULL(i.quantity, 0) - ISNULL(order_so.total_order, 0) - ISNULL(transfer_out.total_transfer_out, 0)) END as free_to_use, ")
                // Incoming: purchase orders + transfer in + sales orders (Returning) + transfer_incoming (exclude Completed) + inventory transfer incoming
                .append("(ISNULL(incoming.total_incoming, 0) + ISNULL(transfer_incoming.total_transfer_incoming, 0) + ISNULL(inv_transfer_incoming.total_inv_transfer_incoming, 0) + ISNULL(returning_so.total_returning, 0)) as incoming, ")
                // Outgoing: sales orders (Delivery) + transfer_outgoing (exclude Completed) + inventory transfer outgoing
                .append("(ISNULL(outgoing.total_outgoing, 0) + ISNULL(transfer_outgoing.total_transfer_outgoing, 0) + ISNULL(inv_transfer_outgoing.total_inv_transfer_outgoing, 0)) as outgoing, ")
                .append("(ISNULL(i.quantity, 0) * ISNULL(p.price, 0)) as total_value, ")
                .append("w.warehouse_name, w.warehouse_id, ")
                .append("u.unit_name, u.unit_code, ")
                .append("s.name as supplier_name, ")
                .append("ISNULL(ra.warning_threshold, 10) as reorder_threshold ")
                .append("FROM Product p ")
                .append("LEFT JOIN Inventory i ON p.product_id = i.product_id ");
        if (warehouseFilter != null) {
            sql.append("AND i.warehouse_id = ? ");
        }
        sql.append("LEFT JOIN Warehouse w ON i.warehouse_id = w.warehouse_id ")
                .append("LEFT JOIN Unit u ON p.unit_id = u.unit_id ")
                .append("LEFT JOIN Supplier s ON p.supplier_id = s.supplier_id ")
                .append("LEFT JOIN (")
                .append("    SELECT ra.product_id, ra.warehouse_id, ra.warning_threshold ")
                .append("    FROM Reorder_Alert ra ")
                .append("    WHERE ra.is_active = 1 ")
                .append(") ra ON p.product_id = ra.product_id AND i.warehouse_id = ra.warehouse_id ")
                // INCOMING: Purchase Orders (Pending, Confirmed)
                .append("LEFT JOIN (")
                .append("    SELECT poi.product_id, po.warehouse_id, SUM(poi.quantity) as total_incoming ")
                .append("    FROM Purchase_Order_Item poi ")
                .append("    JOIN Purchase_Order po ON poi.po_id = po.po_id ")
                .append("    WHERE po.status IN ('Pending', 'Confirmed') AND po.warehouse_id IS NOT NULL ")
                .append("    GROUP BY poi.product_id, po.warehouse_id")
                .append(") incoming ON p.product_id = incoming.product_id AND i.warehouse_id = incoming.warehouse_id ")
                // OUTGOING: Sales Orders (Delivery)
                .append("LEFT JOIN (")
                .append("    SELECT soi.product_id, so.warehouse_id, SUM(soi.quantity) as total_outgoing ")
                .append("    FROM Sales_Order_Item soi ")
                .append("    JOIN Sales_Order so ON soi.so_id = so.so_id ")
                .append("    WHERE so.status = 'Delivery' AND so.warehouse_id IS NOT NULL ")
                .append("    GROUP BY soi.product_id, so.warehouse_id")
                .append(") outgoing ON p.product_id = outgoing.product_id AND i.warehouse_id = outgoing.warehouse_id ")
                // ORDER SALES: Sales Orders (Order)
                .append("LEFT JOIN (")
                .append("    SELECT soi.product_id, so.warehouse_id, SUM(soi.quantity) as total_order ")
                .append("    FROM Sales_Order_Item soi ")
                .append("    JOIN Sales_Order so ON soi.so_id = so.so_id ")
                .append("    WHERE so.status = 'Order' AND so.warehouse_id IS NOT NULL ")
                .append("    GROUP BY soi.product_id, so.warehouse_id")
                .append(") order_so ON p.product_id = order_so.product_id AND i.warehouse_id = order_so.warehouse_id ")
                // TRANSFER OUT: Transfer Orders (Pending, Processing, source warehouse)
                .append("LEFT JOIN (")
                .append("    SELECT toi.product_id, to_.source_warehouse_id as warehouse_id, SUM(toi.quantity) as total_transfer_out ")
                .append("    FROM Transfer_Order_Item toi ")
                .append("    JOIN Transfer_Order to_ ON toi.to_id = to_.to_id ")
                .append("    WHERE to_.status IN ('Pending', 'Processing') AND to_.source_warehouse_id IS NOT NULL ")
                .append("    GROUP BY toi.product_id, to_.source_warehouse_id")
                .append(") transfer_out ON p.product_id = transfer_out.product_id AND i.warehouse_id = transfer_out.warehouse_id ")
                // --- NEW: TRANSFER OUTGOING (Delivery only, exclude Completed) ---
                .append("LEFT JOIN (")
                .append("    SELECT toi.product_id, to_.source_warehouse_id as warehouse_id, SUM(toi.quantity) as total_transfer_outgoing ")
                .append("    FROM Transfer_Order_Item toi ")
                .append("    JOIN Transfer_Order to_ ON toi.to_id = to_.to_id ")
                .append("    WHERE to_.status IN ('Delivery') AND to_.source_warehouse_id IS NOT NULL ")
                .append("    GROUP BY toi.product_id, to_.source_warehouse_id")
                .append(") transfer_outgoing ON p.product_id = transfer_outgoing.product_id AND i.warehouse_id = transfer_outgoing.warehouse_id ")
                // --- NEW: TRANSFER INCOMING (Delivery only, exclude Completed) ---
                .append("LEFT JOIN (")
                .append("    SELECT toi.product_id, to_.destination_warehouse_id as warehouse_id, SUM(toi.quantity) as total_transfer_incoming ")
                .append("    FROM Transfer_Order_Item toi ")
                .append("    JOIN Transfer_Order to_ ON toi.to_id = to_.to_id ")
                .append("    WHERE to_.status IN ('Delivery') AND to_.destination_warehouse_id IS NOT NULL ")
                .append("    GROUP BY toi.product_id, to_.destination_warehouse_id")
                .append(") transfer_incoming ON p.product_id = transfer_incoming.product_id AND i.warehouse_id = transfer_incoming.warehouse_id ")
                // --- NEW: INVENTORY TRANSFER OUTGOING (Delivery only, exclude warehouse_id = 0) ---
                .append("LEFT JOIN (")
                .append("    SELECT iti.product_id, it.source_warehouse_id as warehouse_id, SUM(iti.quantity) as total_inv_transfer_outgoing ")
                .append("    FROM Inventory_Transfer_Item iti ")
                .append("    JOIN Inventory_Transfer it ON iti.it_id = it.it_id ")
                .append("    WHERE it.status = 'Delivery' AND it.source_warehouse_id > 0 ")
                .append("    GROUP BY iti.product_id, it.source_warehouse_id")
                .append(") inv_transfer_outgoing ON p.product_id = inv_transfer_outgoing.product_id AND i.warehouse_id = inv_transfer_outgoing.warehouse_id ")
                // --- NEW: INVENTORY TRANSFER INCOMING (Delivery only, exclude warehouse_id = 0) ---
                .append("LEFT JOIN (")
                .append("    SELECT iti.product_id, it.destination_warehouse_id as warehouse_id, SUM(iti.quantity) as total_inv_transfer_incoming ")
                .append("    FROM Inventory_Transfer_Item iti ")
                .append("    JOIN Inventory_Transfer it ON iti.it_id = it.it_id ")
                .append("    WHERE it.status = 'Delivery' AND it.destination_warehouse_id > 0 ")
                .append("    GROUP BY iti.product_id, it.destination_warehouse_id")
                .append(") inv_transfer_incoming ON p.product_id = inv_transfer_incoming.product_id AND i.warehouse_id = inv_transfer_incoming.warehouse_id ")
                // SALES ORDERS RETURNING: Sales Orders (Returning)
                .append("LEFT JOIN (")
                .append("    SELECT soi.product_id, so.warehouse_id, SUM(soi.quantity) as total_returning ")
                .append("    FROM Sales_Order_Item soi ")
                .append("    JOIN Sales_Order so ON soi.so_id = so.so_id ")
                .append("    WHERE so.status = 'Returning' AND so.warehouse_id IS NOT NULL ")
                .append("    GROUP BY soi.product_id, so.warehouse_id")
                .append(") returning_so ON p.product_id = returning_so.product_id AND i.warehouse_id = returning_so.warehouse_id ")
                .append("WHERE 1=1 ");

        // Add filters
        if (productFilter != null && !productFilter.trim().isEmpty()) {
            sql.append("AND (p.code LIKE ? OR p.name LIKE ?) ");
        }
        if (supplierFilter != null && !supplierFilter.trim().isEmpty()) {
            sql.append("AND s.name LIKE ? ");
        }
        if (stockLevel != null && !stockLevel.trim().isEmpty()) {
            switch (stockLevel) {
                case "low":
                    sql.append("AND ISNULL(i.quantity, 0) <= ISNULL(ra.warning_threshold, 10) ");
                    break;
                case "out":
                    sql.append("AND ISNULL(i.quantity, 0) = 0 ");
                    break;
                case "normal":
                    sql.append("AND ISNULL(i.quantity, 0) > ISNULL(ra.warning_threshold, 10) ");
                    break;
            }
        }
        // Exclude the middle warehouse (warehouse_id = 0) and only show the user's warehouse if warehouseFilter is not null
        if (warehouseFilter != null) {
            sql.append("AND (i.warehouse_id = ? OR i.warehouse_id IS NULL) ");
        }

        sql.append("ORDER BY p.product_id, w.warehouse_id ");

        // Add pagination
        if (page != null && pageSize != null) {
            sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;

            // Set filter parameters
            if (productFilter != null && !productFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + productFilter + "%");
                statement.setString(paramIndex++, "%" + productFilter + "%");
            }
            if (warehouseFilter != null) {
                statement.setInt(paramIndex++, warehouseFilter); // for the JOIN
            }
            if (supplierFilter != null && !supplierFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + supplierFilter + "%");
            }
            if (warehouseFilter != null) {
                statement.setInt(paramIndex++, warehouseFilter); // for the WHERE clause
            }
            if (page != null && pageSize != null) {
                statement.setInt(paramIndex++, (page - 1) * pageSize);
                statement.setInt(paramIndex++, pageSize);
            }

            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                InventoryReport report = getFromResultSet(resultSet);
                if (report != null) {
                    reports.add(report);
                }
            }

        } catch (SQLException ex) {
            System.err.println("Error getting inventory report: " + ex.getMessage());
        } finally {
            closeResources();
        }

        return reports;
    }

    /**
     * Get total count for pagination
     */
    public Integer getTotalFilteredCount(
            String productFilter,
            Integer warehouseFilter,
            String supplierFilter,
            String stockLevel) {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT CONCAT(p.product_id, '-', ISNULL(i.warehouse_id, 0))) ")
                .append("FROM Product p ")
                .append("LEFT JOIN Inventory i ON p.product_id = i.product_id " + (warehouseFilter != null ? "AND i.warehouse_id = ? " : ""))
                .append("LEFT JOIN Warehouse w ON i.warehouse_id = w.warehouse_id ")
                .append("LEFT JOIN Supplier s ON p.supplier_id = s.supplier_id ")
                .append("LEFT JOIN (")
                .append("    SELECT ra.product_id, ra.warehouse_id, ra.warning_threshold ")
                .append("    FROM Reorder_Alert ra ")
                .append("    WHERE ra.is_active = 1 ")
                .append(") ra ON p.product_id = ra.product_id AND i.warehouse_id = ra.warehouse_id ")
                .append("WHERE 1=1 ");

        // Add same filters as main query
        if (productFilter != null && !productFilter.trim().isEmpty()) {
            sql.append("AND (p.code LIKE ? OR p.name LIKE ?) ");
        }
        // warehouseFilter is now handled in the JOIN above
        if (supplierFilter != null && !supplierFilter.trim().isEmpty()) {
            sql.append("AND s.name LIKE ? ");
        }
        if (stockLevel != null && !stockLevel.trim().isEmpty()) {
            switch (stockLevel) {
                case "low":
                    sql.append("AND ISNULL(i.quantity, 0) <= ISNULL(ra.warning_threshold, 10) ");
                    break;
                case "out":
                    sql.append("AND ISNULL(i.quantity, 0) = 0 ");
                    break;
                case "normal":
                    sql.append("AND ISNULL(i.quantity, 0) > ISNULL(ra.warning_threshold, 10) ");
                    break;
            }
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;

            // Set filter parameters
            if (productFilter != null && !productFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + productFilter + "%");
                statement.setString(paramIndex++, "%" + productFilter + "%");
            }
            if (warehouseFilter != null) {
                statement.setInt(paramIndex++, warehouseFilter);
            }
            if (supplierFilter != null && !supplierFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + supplierFilter + "%");
            }

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt(1);
            }

        } catch (SQLException ex) {
            System.err.println("Error getting total count: " + ex.getMessage());
        } finally {
            closeResources();
        }

        return 0;
    }

    /**
     * Map ResultSet to InventoryReport object
     */
    public InventoryReport getFromResultSet(ResultSet rs) throws SQLException {
        InventoryReport report = new InventoryReport();

        report.setProductId(rs.getInt("product_id"));
        report.setProductCode(rs.getString("product_code"));
        report.setProductName(rs.getString("product_name"));

        BigDecimal unitCost = rs.getBigDecimal("unit_cost");
        report.setUnitCost(unitCost != null ? unitCost : BigDecimal.ZERO);

        BigDecimal totalValue = rs.getBigDecimal("total_value");
        report.setTotalValue(totalValue != null ? totalValue : BigDecimal.ZERO);

        report.setOnHand(rs.getInt("on_hand"));
        report.setFreeToUse(rs.getInt("free_to_use"));
        report.setIncoming(rs.getInt("incoming"));
        report.setOutgoing(rs.getInt("outgoing"));

        report.setWarehouseName(rs.getString("warehouse_name"));
        report.setWarehouseId(rs.getInt("warehouse_id"));
        report.setUnitName(rs.getString("unit_name"));
        report.setUnitCode(rs.getString("unit_code"));
        report.setSupplierName(rs.getString("supplier_name"));

        Integer threshold = rs.getInt("reorder_threshold");
        report.setReorderThreshold(threshold);

        // Determine replenishment status
        Integer stock = report.getOnHand();
        if (stock == 0) {
            report.setReplenishment("Out of Stock");
            report.setNeedsRestock(true);
        } else if (stock <= threshold) {
            report.setReplenishment("Restock");
            report.setNeedsRestock(true);
        } else {
            report.setReplenishment("Normal");
            report.setNeedsRestock(false);
        }

        // Set location
        String location = report.getWarehouseName();
        if (location == null || location.trim().isEmpty()) {
            // Skip this row entirely (do not show Middle Warehouse)
            return null;
        }
        report.setLocation(location);

        return report;
    }

    public List<InventoryReport> getRecentInventoryByWarehouse(int warehouseId) {
        List<InventoryReport> inventoryList = new ArrayList<>();
        String sql = "SELECT p.product_id, p.code as product_code, p.name as product_name, "
                + "ISNULL(i.quantity, 0) as on_hand, "
                + "w.warehouse_name "
                + "FROM Product p "
                + "LEFT JOIN Inventory i ON p.product_id = i.product_id AND i.warehouse_id = ? "
                + "JOIN Warehouse w ON i.warehouse_id = w.warehouse_id "
                + "WHERE i.warehouse_id = ? "
                + "ORDER BY i.date_received DESC "
                + "LIMIT 10"; // Lấy 10 sản phẩm gần đây

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            ps.setInt(2, warehouseId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryReport report = new InventoryReport();
                    report.setProductCode(rs.getString("product_code"));
                    report.setProductName(rs.getString("product_name"));
                    report.setWarehouseName(rs.getString("warehouse_name"));
                    report.setOnHand(rs.getInt("on_hand"));
                    inventoryList.add(report);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting recent inventory: " + e.getMessage());
            e.printStackTrace();
        }

        return inventoryList;
    }

    // --- DEBUG MAIN METHOD ---
    public static void main(String[] args) {
        InventoryReportDAO dao = new InventoryReportDAO();
        try {
            // Try with no filters, warehouse 1 (change as needed)
            Integer warehouseId = 1; // Change to a valid warehouse ID in your DB
            List<InventoryReport> reports = dao.getInventoryReportWithFilters(null, warehouseId, null, null, 1, 10);
            System.out.println("Total reports: " + reports.size());
            for (int i = 0; i < Math.min(5, reports.size()); i++) {
                InventoryReport r = reports.get(i);
                System.out.println(r.getProductCode() + " | OnHand: " + r.getOnHand() + " | FreeToUse: " + r.getFreeToUse() + " | Incoming: " + r.getIncoming() + " | Outgoing: " + r.getOutgoing() + " | Warehouse: " + r.getWarehouseName());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
