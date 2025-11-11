package dao;

import model.ProductAlert;
import java.sql.*;
import java.util.*;

public class ProductAlertDAO extends DBConnect {

    /**
     * Lấy danh sách cảnh báo theo warehouse
     */
    public List<ProductAlert> getAlertsByWarehouse(int warehouseId) {
        List<ProductAlert> alerts = new ArrayList<>();
        String sql = "SELECT ra.alert_id, ra.product_id, ra.warehouse_id, ra.warning_threshold, "
                + "ra.critical_threshold, ra.triggered_date, ra.current_stock, ra.is_active, "
                + "ra.alert_start_date, ra.alert_expiry_date, ra.alert_duration_days, "
                + "p.code as product_code, p.name as product_name, "
                + "w.warehouse_name, u.unit_name, "
                + "ISNULL(i.quantity, 0) as actual_stock, "
                + "CASE "
                + "  WHEN ISNULL(i.quantity, 0) = 0 THEN 'OUT_OF_STOCK' "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.critical_threshold THEN 'CRITICAL' "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.warning_threshold THEN 'WARNING' "
                + "  ELSE 'STABLE' "
                + "END as alert_level, "
                + "CASE WHEN ra.alert_expiry_date < GETDATE() THEN 1 ELSE 0 END as is_expired, "
                + "DATEDIFF(day, GETDATE(), ra.alert_expiry_date) as days_until_expiry "
                + "FROM Reorder_Alert ra "
                + "JOIN Product p ON ra.product_id = p.product_id "
                + "JOIN Warehouse w ON ra.warehouse_id = w.warehouse_id "
                + "LEFT JOIN Unit u ON p.unit_id = u.unit_id "
                + "LEFT JOIN Inventory i ON ra.product_id = i.product_id AND ra.warehouse_id = i.warehouse_id "
                + "WHERE ra.is_active = 1 AND ra.warehouse_id = ? "
                + "ORDER BY "
                + "CASE WHEN ra.alert_expiry_date < GETDATE() THEN 0 ELSE 1 END, "
                + "CASE "
                + "  WHEN ISNULL(i.quantity, 0) = 0 THEN 1 "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.critical_threshold THEN 2 "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.warning_threshold THEN 3 "
                + "  ELSE 4 "
                + "END, ra.triggered_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    alerts.add(mapResultSetToProductAlert(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting alerts by warehouse: " + e.getMessage());
            e.printStackTrace();
        }
        return alerts;
    }

    /**
     * Lấy tất cả cảnh báo (cho admin)
     */
    public List<ProductAlert> getAllAlerts() {
        List<ProductAlert> alerts = new ArrayList<>();
        String sql = "SELECT ra.alert_id, ra.product_id, ra.warehouse_id, ra.warning_threshold, "
                + "ra.critical_threshold, ra.triggered_date, ra.current_stock, ra.is_active, "
                + "ra.alert_start_date, ra.alert_expiry_date, ra.alert_duration_days, "
                + "p.code as product_code, p.name as product_name, "
                + "w.warehouse_name, u.unit_name, "
                + "ISNULL(i.quantity, 0) as actual_stock, "
                + "CASE "
                + "  WHEN ISNULL(i.quantity, 0) = 0 THEN 'OUT_OF_STOCK' "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.critical_threshold THEN 'CRITICAL' "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.warning_threshold THEN 'WARNING' "
                + "  ELSE 'STABLE' "
                + "END as alert_level, "
                + "CASE WHEN ra.alert_expiry_date < GETDATE() THEN 1 ELSE 0 END as is_expired, "
                + "DATEDIFF(day, GETDATE(), ra.alert_expiry_date) as days_until_expiry "
                + "FROM Reorder_Alert ra "
                + "JOIN Product p ON ra.product_id = p.product_id "
                + "JOIN Warehouse w ON ra.warehouse_id = w.warehouse_id "
                + "LEFT JOIN Unit u ON p.unit_id = u.unit_id "
                + "LEFT JOIN Inventory i ON ra.product_id = i.product_id AND ra.warehouse_id = i.warehouse_id "
                + "WHERE ra.is_active = 1 "
                + "ORDER BY "
                + "CASE WHEN ra.alert_expiry_date < GETDATE() THEN 0 ELSE 1 END, "
                + "CASE "
                + "  WHEN ISNULL(i.quantity, 0) = 0 THEN 1 "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.critical_threshold THEN 2 "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.warning_threshold THEN 3 "
                + "  ELSE 4 "
                + "END, ra.triggered_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    alerts.add(mapResultSetToProductAlert(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting all alerts: " + e.getMessage());
            e.printStackTrace();
        }
        return alerts;
    }

    /**
     * FIXED: Kiểm tra alert đã tồn tại chưa
     */
    public boolean alertExists(int productId, int warehouseId) {
        String sql = "SELECT COUNT(*) FROM Reorder_Alert WHERE product_id = ? AND warehouse_id = ? AND is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking alert existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra alert đã tồn tại chưa (bao gồm cả deactive)
     */
    public boolean alertExistsAny(int productId, int warehouseId) {
        String sql = "SELECT COUNT(*) FROM Reorder_Alert WHERE product_id = ? AND warehouse_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking alert existence (any): " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy alert deactive (is_active=0) theo productId, warehouseId
     */
    public Integer getDeactiveAlertId(int productId, int warehouseId) {
        String sql = "SELECT alert_id FROM Reorder_Alert WHERE product_id = ? AND warehouse_id = ? AND is_active = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("alert_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting deactive alert id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy alert theo product và warehouse
     */
    public ProductAlert getAlertByProductAndWarehouse(int productId, int warehouseId) {
        String sql = "SELECT ra.alert_id, ra.product_id, ra.warehouse_id, ra.warning_threshold, "
                + "ra.critical_threshold, ra.triggered_date, ra.current_stock, ra.is_active, "
                + "ra.alert_start_date, ra.alert_expiry_date, ra.alert_duration_days, "
                + "p.code as product_code, p.name as product_name, "
                + "w.warehouse_name, u.unit_name, "
                + "ISNULL(i.quantity, 0) as actual_stock, "
                + "CASE "
                + "  WHEN ISNULL(i.quantity, 0) = 0 THEN 'OUT_OF_STOCK' "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.critical_threshold THEN 'CRITICAL' "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.warning_threshold THEN 'WARNING' "
                + "  ELSE 'STABLE' "
                + "END as alert_level, "
                + "CASE WHEN ra.alert_expiry_date < GETDATE() THEN 1 ELSE 0 END as is_expired, "
                + "DATEDIFF(day, GETDATE(), ra.alert_expiry_date) as days_until_expiry "
                + "FROM Reorder_Alert ra "
                + "JOIN Product p ON ra.product_id = p.product_id "
                + "JOIN Warehouse w ON ra.warehouse_id = w.warehouse_id "
                + "LEFT JOIN Unit u ON p.unit_id = u.unit_id "
                + "LEFT JOIN Inventory i ON ra.product_id = i.product_id AND ra.warehouse_id = i.warehouse_id "
                + "WHERE ra.product_id = ? AND ra.warehouse_id = ? AND ra.is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProductAlert(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting alert by product and warehouse: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách sản phẩm cần mua hàng dựa trên alert (Critical và Out of Stock)
     */
    public List<ProductAlert> getProductsNeedingPurchase(int warehouseId) {
        List<ProductAlert> alerts = new ArrayList<>();
        String sql = "SELECT ra.alert_id, ra.product_id, ra.warehouse_id, ra.warning_threshold, "
                + "ra.critical_threshold, ra.triggered_date, ra.current_stock, ra.is_active, "
                + "ra.alert_start_date, ra.alert_expiry_date, ra.alert_duration_days, "
                + "p.code as product_code, p.name as product_name, "
                + "w.warehouse_name, u.unit_name, "
                + "ISNULL(i.quantity, 0) as actual_stock, "
                + "CASE "
                + "  WHEN ISNULL(i.quantity, 0) = 0 THEN 'OUT_OF_STOCK' "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.critical_threshold THEN 'CRITICAL' "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.warning_threshold THEN 'WARNING' "
                + "  ELSE 'STABLE' "
                + "END as alert_level, "
                + "CASE WHEN ra.alert_expiry_date < GETDATE() THEN 1 ELSE 0 END as is_expired, "
                + "DATEDIFF(day, GETDATE(), ra.alert_expiry_date) as days_until_expiry "
                + "FROM Reorder_Alert ra "
                + "JOIN Product p ON ra.product_id = p.product_id "
                + "JOIN Warehouse w ON ra.warehouse_id = w.warehouse_id "
                + "LEFT JOIN Unit u ON p.unit_id = u.unit_id "
                + "LEFT JOIN Inventory i ON ra.product_id = i.product_id AND ra.warehouse_id = i.warehouse_id "
                + "WHERE ra.is_active = 1 AND ra.warehouse_id = ? "
                + "AND (ISNULL(i.quantity, 0) = 0 OR ISNULL(i.quantity, 0) <= ra.critical_threshold) "
                + "AND ra.alert_expiry_date >= GETDATE() "
                + "ORDER BY "
                + "CASE WHEN ISNULL(i.quantity, 0) = 0 THEN 1 ELSE 2 END, "
                + "ra.triggered_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    alerts.add(mapResultSetToProductAlert(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting products needing purchase: " + e.getMessage());
            e.printStackTrace();
        }
        return alerts;
    }

    /**
     * Cập nhật lại alert deactive thành active và update thông tin mới
     */
    public boolean reactivateAlert(int alertId, int warningThreshold, int criticalThreshold, int durationDays) {
        String sql = "UPDATE Reorder_Alert SET warning_threshold = ?, critical_threshold = ?, alert_duration_days = ?, alert_start_date = GETDATE(), alert_expiry_date = DATEADD(day, ?, GETDATE()), is_active = 1, last_updated = GETDATE() WHERE alert_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warningThreshold);
            ps.setInt(2, criticalThreshold);
            ps.setInt(3, durationDays);
            ps.setInt(4, durationDays);
            ps.setInt(5, alertId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error reactivating alert: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Tạo hoặc cập nhật cảnh báo
     */
    public boolean createOrUpdateAlert(int productId, int warehouseId, int warningThreshold, 
                                     int criticalThreshold, int durationDays, int createdBy) {
        // Validation
        if (criticalThreshold >= warningThreshold) {
            System.err.println("Critical threshold must be less than warning threshold");
            return false;
        }

        // Nếu đã có alert active thì update
        if (alertExists(productId, warehouseId)) {
            return updateExistingAlert(productId, warehouseId, warningThreshold, criticalThreshold, durationDays);
        } else if (alertExistsAny(productId, warehouseId)) {
            // Nếu có alert deactive thì reactivate
            Integer deactiveId = getDeactiveAlertId(productId, warehouseId);
            if (deactiveId != null) {
                return reactivateAlert(deactiveId, warningThreshold, criticalThreshold, durationDays);
            }
        }
        // Nếu chưa có alert nào thì tạo mới
        return createNewAlert(productId, warehouseId, warningThreshold, criticalThreshold, durationDays, createdBy);
    }

    /**
     * Tạo alert mới
     */
    private boolean createNewAlert(int productId, int warehouseId, int warningThreshold, 
                                 int criticalThreshold, int durationDays, int createdBy) {
        String sql = "INSERT INTO Reorder_Alert (product_id, warehouse_id, warning_threshold, critical_threshold, "
                + "current_stock, is_active, created_by, created_at, last_updated, alert_start_date, "
                + "alert_expiry_date, alert_duration_days) "
                + "VALUES (?, ?, ?, ?, ISNULL((SELECT quantity FROM Inventory WHERE product_id = ? AND warehouse_id = ?), 0), "
                + "1, ?, GETDATE(), GETDATE(), GETDATE(), DATEADD(day, ?, GETDATE()), ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);
            ps.setInt(3, warningThreshold);
            ps.setInt(4, criticalThreshold);
            ps.setInt(5, productId);
            ps.setInt(6, warehouseId);
            ps.setInt(7, createdBy);
            ps.setInt(8, durationDays);
            ps.setInt(9, durationDays);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error creating new alert: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật alert hiện có
     */
    private boolean updateExistingAlert(int productId, int warehouseId, int warningThreshold, 
                                      int criticalThreshold, int durationDays) {
        String sql = "UPDATE Reorder_Alert SET warning_threshold = ?, critical_threshold = ?, "
                + "alert_duration_days = ?, alert_expiry_date = DATEADD(day, ?, alert_start_date), "
                + "last_updated = GETDATE(), current_stock = ISNULL((SELECT quantity FROM Inventory WHERE product_id = ? AND warehouse_id = ?), 0) "
                + "WHERE product_id = ? AND warehouse_id = ? AND is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warningThreshold);
            ps.setInt(2, criticalThreshold);
            ps.setInt(3, durationDays);
            ps.setInt(4, durationDays);
            ps.setInt(5, productId);
            ps.setInt(6, warehouseId);
            ps.setInt(7, productId);
            ps.setInt(8, warehouseId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating existing alert: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * FIXED: Vô hiệu hóa cảnh báo thay vì xóa
     */
    public boolean deactivateAlert(int alertId) {
        String sql = "UPDATE Reorder_Alert SET is_active = 0, last_updated = GETDATE() WHERE alert_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, alertId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deactivating alert: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy số lượng cảnh báo theo warehouse
     */
    public Map<String, Integer> getAlertCountsByWarehouse(int warehouseId) {
        Map<String, Integer> counts = new HashMap<>();
        String sql = "SELECT "
                + "SUM(CASE WHEN ISNULL(i.quantity, 0) = 0 THEN 1 ELSE 0 END) as out_of_stock, "
                + "SUM(CASE WHEN ISNULL(i.quantity, 0) > 0 AND ISNULL(i.quantity, 0) <= ra.critical_threshold THEN 1 ELSE 0 END) as critical, "
                + "SUM(CASE WHEN ISNULL(i.quantity, 0) > ra.critical_threshold AND ISNULL(i.quantity, 0) <= ra.warning_threshold THEN 1 ELSE 0 END) as warning, "
                + "SUM(CASE WHEN ISNULL(i.quantity, 0) > ra.warning_threshold THEN 1 ELSE 0 END) as stable, "
                + "SUM(CASE WHEN ra.alert_expiry_date < GETDATE() THEN 1 ELSE 0 END) as expired "
                + "FROM Reorder_Alert ra "
                + "LEFT JOIN Inventory i ON ra.product_id = i.product_id AND ra.warehouse_id = i.warehouse_id "
                + "WHERE ra.is_active = 1 AND ra.warehouse_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    counts.put("out_of_stock", rs.getInt("out_of_stock"));
                    counts.put("critical", rs.getInt("critical"));
                    counts.put("warning", rs.getInt("warning"));
                    counts.put("stable", rs.getInt("stable"));
                    counts.put("expired", rs.getInt("expired"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting alert counts: " + e.getMessage());
            e.printStackTrace();
        }
        return counts;
    }

    /**
     * Chuyển cảnh báo hết hạn vào lịch sử
     */
    public void moveExpiredAlertsToHistory() {
        try {
            connection.setAutoCommit(false);
            
            // Insert expired alerts into history
            String insertHistorySql = "INSERT INTO Alert_History (alert_id, product_id, warehouse_id, alert_level, "
                    + "stock_quantity, threshold_value, triggered_date, resolved_date, status, created_by, expiry_date, auto_resolved) "
                    + "SELECT ra.alert_id, ra.product_id, ra.warehouse_id, "
                    + "CASE "
                    + "  WHEN ISNULL(i.quantity, 0) = 0 THEN 'OUT_OF_STOCK' "
                    + "  WHEN ISNULL(i.quantity, 0) <= ra.critical_threshold THEN 'CRITICAL' "
                    + "  WHEN ISNULL(i.quantity, 0) <= ra.warning_threshold THEN 'WARNING' "
                    + "  ELSE 'STABLE' "
                    + "END, "
                    + "ISNULL(i.quantity, 0), ra.warning_threshold, ra.triggered_date, GETDATE(), 'EXPIRED', "
                    + "ra.created_by, ra.alert_expiry_date, 1 "
                    + "FROM Reorder_Alert ra "
                    + "LEFT JOIN Inventory i ON ra.product_id = i.product_id AND ra.warehouse_id = i.warehouse_id "
                    + "WHERE ra.is_active = 1 AND ra.alert_expiry_date < GETDATE()";

            try (PreparedStatement ps = connection.prepareStatement(insertHistorySql)) {
                ps.executeUpdate();
            }

            // Deactivate expired alerts
            String deactivateSql = "UPDATE Reorder_Alert SET is_active = 0, last_updated = GETDATE() "
                    + "WHERE is_active = 1 AND alert_expiry_date < GETDATE()";

            try (PreparedStatement ps = connection.prepareStatement(deactivateSql)) {
                ps.executeUpdate();
            }

            connection.commit();
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.err.println("Error rolling back transaction: " + ex.getMessage());
            }
            System.err.println("Error moving expired alerts to history: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                System.err.println("Error resetting auto-commit: " + e.getMessage());
            }
        }
    }

    /**
     * Lấy lịch sử cảnh báo theo warehouse
     */
    public List<ProductAlert> getAlertHistoryByWarehouse(int warehouseId, int limit) {
        List<ProductAlert> history = new ArrayList<>();
        String sql = "SELECT TOP (?) ah.*, p.code as product_code, p.name as product_name, "
                + "w.warehouse_name, u.first_name + ' ' + u.last_name as created_by_name "
                + "FROM Alert_History ah "
                + "JOIN Product p ON ah.product_id = p.product_id "
                + "JOIN Warehouse w ON ah.warehouse_id = w.warehouse_id "
                + "LEFT JOIN [User] u ON ah.created_by = u.user_id "
                + "WHERE ah.warehouse_id = ? "
                + "ORDER BY ah.triggered_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductAlert alert = new ProductAlert();
                    alert.setAlertId(rs.getInt("alert_id"));
                    alert.setProductId(rs.getInt("product_id"));
                    alert.setWarehouseId(rs.getInt("warehouse_id"));
                    alert.setAlertLevel(rs.getString("alert_level"));
                    alert.setCurrentStock(rs.getInt("stock_quantity"));
                    alert.setWarningThreshold(rs.getInt("threshold_value"));
                    alert.setTriggeredDate(rs.getTimestamp("triggered_date"));
                    alert.setProductCode(rs.getString("product_code"));
                    alert.setProductName(rs.getString("product_name"));
                    alert.setWarehouseName(rs.getString("warehouse_name"));
                    history.add(alert);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting alert history: " + e.getMessage());
            e.printStackTrace();
        }
        return history;
    }

    /**
     * Cập nhật current stock cho tất cả alerts trong warehouse
     */
    public void updateCurrentStockByWarehouse(int warehouseId) {
        String sql = "UPDATE ra SET current_stock = ISNULL(i.quantity, 0) "
                + "FROM Reorder_Alert ra "
                + "LEFT JOIN Inventory i ON ra.product_id = i.product_id AND ra.warehouse_id = i.warehouse_id "
                + "WHERE ra.is_active = 1 AND ra.warehouse_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error updating current stock: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Lấy alert theo ID
     */
    public ProductAlert getAlertById(int alertId) {
        String sql = "SELECT ra.alert_id, ra.product_id, ra.warehouse_id, ra.warning_threshold, "
                + "ra.critical_threshold, ra.triggered_date, ra.current_stock, ra.is_active, "
                + "ra.alert_start_date, ra.alert_expiry_date, ra.alert_duration_days, "
                + "p.code as product_code, p.name as product_name, "
                + "w.warehouse_name, u.unit_name, "
                + "ISNULL(i.quantity, 0) as actual_stock, "
                + "CASE "
                + "  WHEN ISNULL(i.quantity, 0) = 0 THEN 'OUT_OF_STOCK' "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.critical_threshold THEN 'CRITICAL' "
                + "  WHEN ISNULL(i.quantity, 0) <= ra.warning_threshold THEN 'WARNING' "
                + "  ELSE 'STABLE' "
                + "END as alert_level, "
                + "CASE WHEN ra.alert_expiry_date < GETDATE() THEN 1 ELSE 0 END as is_expired, "
                + "DATEDIFF(day, GETDATE(), ra.alert_expiry_date) as days_until_expiry "
                + "FROM Reorder_Alert ra "
                + "JOIN Product p ON ra.product_id = p.product_id "
                + "JOIN Warehouse w ON ra.warehouse_id = w.warehouse_id "
                + "LEFT JOIN Unit u ON p.unit_id = u.unit_id "
                + "LEFT JOIN Inventory i ON ra.product_id = i.product_id AND ra.warehouse_id = i.warehouse_id "
                + "WHERE ra.alert_id = ? AND ra.is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, alertId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProductAlert(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting alert by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Map ResultSet to ProductAlert object
     */
    private ProductAlert mapResultSetToProductAlert(ResultSet rs) throws SQLException {
        ProductAlert alert = new ProductAlert();
        alert.setAlertId(rs.getInt("alert_id"));
        alert.setProductId(rs.getInt("product_id"));
        alert.setWarehouseId(rs.getInt("warehouse_id"));
        alert.setWarningThreshold(rs.getInt("warning_threshold"));
        alert.setCriticalThreshold(rs.getInt("critical_threshold"));
        alert.setTriggeredDate(rs.getTimestamp("triggered_date"));
        alert.setCurrentStock(rs.getInt("actual_stock"));
        alert.setActive(rs.getBoolean("is_active"));
        alert.setAlertStartDate(rs.getTimestamp("alert_start_date"));
        alert.setAlertExpiryDate(rs.getTimestamp("alert_expiry_date"));
        alert.setAlertDurationDays(rs.getInt("alert_duration_days"));
        alert.setProductCode(rs.getString("product_code"));
        alert.setProductName(rs.getString("product_name"));
        alert.setWarehouseName(rs.getString("warehouse_name"));
        alert.setUnitName(rs.getString("unit_name"));
        alert.setAlertLevel(rs.getString("alert_level"));
        alert.setExpired(rs.getBoolean("is_expired"));
        alert.setDaysUntilExpiry(rs.getInt("days_until_expiry"));

        return alert;
    }
    
    /**
     * Lấy lịch sử cảnh báo chi tiết theo warehouse với cấu trúc mới
     */
    public List<Map<String, Object>> getDetailedAlertHistoryByWarehouse(int warehouseId, int limit) {
        List<Map<String, Object>> history = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " ah.*, " +
                     "p.code as product_code, p.name as product_name, " +
                     "w.warehouse_name, " +
                     "u_performed.first_name + ' ' + u_performed.last_name as performed_by_name, " +
                     "u_resolved.first_name + ' ' + u_resolved.last_name as resolved_by_name, " +
                     "ir.reason as purchase_request_reason " +
                     "FROM Alert_History ah " +
                     "JOIN Product p ON ah.product_id = p.product_id " +
                     "JOIN Warehouse w ON ah.warehouse_id = w.warehouse_id " +
                     "JOIN [User] u_performed ON ah.performed_by = u_performed.user_id " +
                     "LEFT JOIN [User] u_resolved ON ah.resolved_by_user_id = u_resolved.user_id " +
                     "LEFT JOIN Import_Request ir ON ah.resolved_by_purchase_request_id = ir.request_id " +
                     "WHERE ah.warehouse_id = ? " +
                     "ORDER BY ah.action_date DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> record = new HashMap<>();
                    record.put("historyId", rs.getInt("history_id"));
                    record.put("alertId", rs.getInt("alert_id"));
                    record.put("productCode", rs.getString("product_code"));
                    record.put("productName", rs.getString("product_name"));
                    record.put("warehouseName", rs.getString("warehouse_name"));
                    record.put("actionType", rs.getString("action_type"));
                    record.put("alertLevel", rs.getString("alert_level"));
                    record.put("warningThreshold", rs.getInt("warning_threshold"));
                    record.put("criticalThreshold", rs.getInt("critical_threshold"));
                    record.put("stockQuantity", rs.getInt("stock_quantity"));
                    record.put("oldWarningThreshold", rs.getObject("old_warning_threshold"));
                    record.put("oldCriticalThreshold", rs.getObject("old_critical_threshold"));
                    record.put("oldExpiryDate", rs.getTimestamp("old_expiry_date"));
                    record.put("newExpiryDate", rs.getTimestamp("new_expiry_date"));
                    record.put("resolvedByPurchaseRequestId", rs.getObject("resolved_by_purchase_request_id"));
                    record.put("actionDate", rs.getTimestamp("action_date"));
                    record.put("alertStartDate", rs.getTimestamp("alert_start_date"));
                    record.put("alertExpiryDate", rs.getTimestamp("alert_expiry_date"));
                    record.put("performedByName", rs.getString("performed_by_name"));
                    record.put("resolvedByName", rs.getString("resolved_by_name"));
                    record.put("notes", rs.getString("notes"));
                    record.put("systemGenerated", rs.getBoolean("system_generated"));
                    record.put("purchaseRequestReason", rs.getString("purchase_request_reason"));
                    history.add(record);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting detailed alert history by warehouse: " + e.getMessage());
            e.printStackTrace();
        }
        return history;
    }
    
    /**
     * Lấy tất cả lịch sử cảnh báo (cho Admin/Manager)
     */
    public List<Map<String, Object>> getAllDetailedAlertHistory(int limit) {
        List<Map<String, Object>> history = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " ah.*, " +
                     "p.code as product_code, p.name as product_name, " +
                     "w.warehouse_name, " +
                     "u_performed.first_name + ' ' + u_performed.last_name as performed_by_name, " +
                     "u_resolved.first_name + ' ' + u_resolved.last_name as resolved_by_name, " +
                     "ir.reason as purchase_request_reason " +
                     "FROM Alert_History ah " +
                     "JOIN Product p ON ah.product_id = p.product_id " +
                     "JOIN Warehouse w ON ah.warehouse_id = w.warehouse_id " +
                     "JOIN [User] u_performed ON ah.performed_by = u_performed.user_id " +
                     "LEFT JOIN [User] u_resolved ON ah.resolved_by_user_id = u_resolved.user_id " +
                     "LEFT JOIN Import_Request ir ON ah.resolved_by_purchase_request_id = ir.request_id " +
                     "ORDER BY ah.action_date DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> record = new HashMap<>();
                record.put("historyId", rs.getInt("history_id"));
                record.put("alertId", rs.getInt("alert_id"));
                record.put("productCode", rs.getString("product_code"));
                record.put("productName", rs.getString("product_name"));
                record.put("warehouseName", rs.getString("warehouse_name"));
                record.put("actionType", rs.getString("action_type"));
                record.put("alertLevel", rs.getString("alert_level"));
                record.put("warningThreshold", rs.getInt("warning_threshold"));
                record.put("criticalThreshold", rs.getInt("critical_threshold"));
                record.put("stockQuantity", rs.getInt("stock_quantity"));
                record.put("oldWarningThreshold", rs.getObject("old_warning_threshold"));
                record.put("oldCriticalThreshold", rs.getObject("old_critical_threshold"));
                record.put("oldExpiryDate", rs.getTimestamp("old_expiry_date"));
                record.put("newExpiryDate", rs.getTimestamp("new_expiry_date"));
                record.put("resolvedByPurchaseRequestId", rs.getObject("resolved_by_purchase_request_id"));
                record.put("actionDate", rs.getTimestamp("action_date"));
                record.put("alertStartDate", rs.getTimestamp("alert_start_date"));
                record.put("alertExpiryDate", rs.getTimestamp("alert_expiry_date"));
                record.put("performedByName", rs.getString("performed_by_name"));
                record.put("resolvedByName", rs.getString("resolved_by_name"));
                record.put("notes", rs.getString("notes"));
                record.put("systemGenerated", rs.getBoolean("system_generated"));
                record.put("purchaseRequestReason", rs.getString("purchase_request_reason"));
                history.add(record);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all detailed alert history: " + e.getMessage());
            e.printStackTrace();
        }
        return history;
    }
    
    /**
     * Ghi lại lịch sử khi alert được giải quyết bằng purchase request
     */
    public boolean logAlertResolvedByPurchase(int alertId, int purchaseRequestId, int resolvedByUserId, String notes) {
        String sql = "INSERT INTO Alert_History (alert_id, product_id, warehouse_id, action_type, alert_level, " +
                     "warning_threshold, critical_threshold, stock_quantity, " +
                     "resolved_by_purchase_request_id, resolved_by_user_id, " +
                     "alert_start_date, alert_expiry_date, performed_by, notes, system_generated) " +
                     "SELECT ra.alert_id, ra.product_id, ra.warehouse_id, 'RESOLVED_BY_PURCHASE', " +
                     "CASE " +
                     "  WHEN ra.current_stock = 0 THEN 'OUT_OF_STOCK' " +
                     "  WHEN ra.current_stock <= ra.critical_threshold THEN 'CRITICAL' " +
                     "  WHEN ra.current_stock <= ra.warning_threshold THEN 'WARNING' " +
                     "  ELSE 'STABLE' " +
                     "END, ra.warning_threshold, ra.critical_threshold, ra.current_stock, " +
                     "?, ?, ra.alert_start_date, ra.alert_expiry_date, ?, ?, 0 " +
                     "FROM Reorder_Alert ra WHERE ra.alert_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, purchaseRequestId);
            ps.setInt(2, resolvedByUserId);
            ps.setInt(3, resolvedByUserId);
            ps.setString(4, notes);
            ps.setInt(5, alertId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error logging alert resolution by purchase: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy thống kê lịch sử cảnh báo
     */
    public Map<String, Integer> getAlertHistoryStats(int warehouseId) {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) as total_actions, " +
                     "SUM(CASE WHEN action_type = 'CREATED' THEN 1 ELSE 0 END) as created_count, " +
                     "SUM(CASE WHEN action_type = 'UPDATED' THEN 1 ELSE 0 END) as updated_count, " +
                     "SUM(CASE WHEN action_type = 'RESOLVED_BY_PURCHASE' THEN 1 ELSE 0 END) as resolved_count, " +
                     "SUM(CASE WHEN action_type = 'EXPIRED' THEN 1 ELSE 0 END) as expired_count, " +
                     "SUM(CASE WHEN action_type = 'DEACTIVATED' THEN 1 ELSE 0 END) as deactivated_count " +
                     "FROM Alert_History " +
                     "WHERE warehouse_id = ? AND action_date >= DATEADD(month, -1, GETDATE())";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("total", rs.getInt("total_actions"));
                    stats.put("created", rs.getInt("created_count"));
                    stats.put("updated", rs.getInt("updated_count"));
                    stats.put("resolved", rs.getInt("resolved_count"));
                    stats.put("expired", rs.getInt("expired_count"));
                    stats.put("deactivated", rs.getInt("deactivated_count"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting alert history stats: " + e.getMessage());
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Ghi lại lịch sử khi alert được cập nhật (UPDATED)
     */
    public boolean logAlertUpdated(int alertId, int performedBy, int oldWarning, int oldCritical, Timestamp oldExpiry, int newWarning, int newCritical, Timestamp newExpiry, String notes) {
        String sql = "INSERT INTO Alert_History (alert_id, product_id, warehouse_id, action_type, alert_level, " +
                "warning_threshold, critical_threshold, stock_quantity, old_warning_threshold, old_critical_threshold, old_expiry_date, new_expiry_date, " +
                "alert_start_date, alert_expiry_date, performed_by, notes, system_generated) " +
                "SELECT ra.alert_id, ra.product_id, ra.warehouse_id, 'UPDATED', " +
                "CASE " +
                "  WHEN ra.current_stock = 0 THEN 'OUT_OF_STOCK' " +
                "  WHEN ra.current_stock <= ra.critical_threshold THEN 'CRITICAL' " +
                "  WHEN ra.current_stock <= ra.warning_threshold THEN 'WARNING' " +
                "  ELSE 'STABLE' " +
                "END, ?, ?, ra.current_stock, ?, ?, ?, ?, ra.alert_start_date, ra.alert_expiry_date, ?, ?, 0 " +
                "FROM Reorder_Alert ra WHERE ra.alert_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, newWarning);
            ps.setInt(2, newCritical);
            ps.setInt(3, oldWarning);
            ps.setInt(4, oldCritical);
            ps.setTimestamp(5, oldExpiry);
            ps.setTimestamp(6, newExpiry);
            ps.setInt(7, performedBy);
            ps.setString(8, notes);
            ps.setInt(9, alertId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error logging alert update: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Ghi lại lịch sử khi alert được tạo mới (CREATED)
     */
    public boolean logAlertCreated(int alertId, int performedBy, String notes) {
        String sql = "INSERT INTO Alert_History (alert_id, product_id, warehouse_id, action_type, alert_level, " +
                "warning_threshold, critical_threshold, stock_quantity, alert_start_date, alert_expiry_date, performed_by, notes, system_generated) " +
                "SELECT ra.alert_id, ra.product_id, ra.warehouse_id, 'CREATED', " +
                "CASE " +
                "  WHEN ra.current_stock = 0 THEN 'OUT_OF_STOCK' " +
                "  WHEN ra.current_stock <= ra.critical_threshold THEN 'CRITICAL' " +
                "  WHEN ra.current_stock <= ra.warning_threshold THEN 'WARNING' " +
                "  ELSE 'STABLE' " +
                "END, ra.warning_threshold, ra.critical_threshold, ra.current_stock, ra.alert_start_date, ra.alert_expiry_date, ?, ?, 0 " +
                "FROM Reorder_Alert ra WHERE ra.alert_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, performedBy);
            ps.setString(2, notes);
            ps.setInt(3, alertId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error logging alert creation: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Ghi lại lịch sử khi alert bị vô hiệu hóa (DEACTIVATED)
     */
    public boolean logAlertDeactivated(int alertId, int performedBy, String notes) {
        String sql = "INSERT INTO Alert_History (alert_id, product_id, warehouse_id, action_type, alert_level, " +
                "warning_threshold, critical_threshold, stock_quantity, alert_start_date, alert_expiry_date, performed_by, notes, system_generated) " +
                "SELECT ra.alert_id, ra.product_id, ra.warehouse_id, 'DEACTIVATED', " +
                "CASE " +
                "  WHEN ra.current_stock = 0 THEN 'OUT_OF_STOCK' " +
                "  WHEN ra.current_stock <= ra.critical_threshold THEN 'CRITICAL' " +
                "  WHEN ra.current_stock <= ra.warning_threshold THEN 'WARNING' " +
                "  ELSE 'STABLE' " +
                "END, ra.warning_threshold, ra.critical_threshold, ra.current_stock, ra.alert_start_date, ra.alert_expiry_date, ?, ?, 0 " +
                "FROM Reorder_Alert ra WHERE ra.alert_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, performedBy);
            ps.setString(2, notes);
            ps.setInt(3, alertId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error logging alert deactivation: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}