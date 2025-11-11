package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import model.User;
import model.WarehouseDisplay;
import model.Warehouse;

public class WarehouseDAO extends DBConnect {

    // Lấy danh sách tất cả kho cho dropdown (simple)
    public List<Warehouse> getAll() {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT warehouse_id, warehouse_name, address, region, manager_id, status, created_at FROM Warehouse WHERE status = 'Active' ORDER BY warehouse_name";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setWarehouseName(rs.getString("warehouse_name"));
                w.setAddress(rs.getString("address"));
                w.setRegion(rs.getString("region"));
                w.setManagerId(rs.getInt("manager_id"));
                w.setStatus(rs.getString("status"));
                w.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(w);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách tất cả kho (có thông tin manager)
    public List<WarehouseDisplay> getAllWarehouses() {
        List<WarehouseDisplay> list = new ArrayList<>();
        String sql = "SELECT w.*, " +
                     "u.first_name + ' ' + u.last_name AS manager_name, " +
                     "u.email AS manager_email, " +
                     "FORMAT(w.created_at, 'dd/MM/yyyy') AS created_at_formatted " +
                     "FROM Warehouse w LEFT JOIN [User] u ON w.manager_id = u.user_id";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                WarehouseDisplay w = new WarehouseDisplay();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setWarehouseName(rs.getString("warehouse_name"));
                w.setAddress(rs.getString("address"));
                w.setRegion(rs.getString("region"));
                w.setManagerId(rs.getInt("manager_id"));
                w.setManagerName(rs.getString("manager_name"));
                w.setManagerMail(rs.getString("manager_email"));
                w.setStatus(rs.getString("status"));
                w.setCreatedAtFormatted(rs.getString("created_at_formatted"));
                list.add(w);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách tất cả manager
    public List<User> getAllManagers() {
        List<User> managers = new ArrayList<>();
        String sql = "SELECT user_id, first_name, last_name FROM [User] WHERE role_id = 2 ORDER BY first_name, last_name";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User manager = new User();
                manager.setUserId(rs.getInt("user_id"));
                manager.setFirstName(rs.getString("first_name"));
                manager.setLastName(rs.getString("last_name"));
                managers.add(manager);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return managers;
    }

    // Lấy thông tin kho theo ID
    public WarehouseDisplay getWarehouseById(int id) {
        String sql = "SELECT w.*, u.first_name + ' ' + u.last_name AS manager_name, " +
                     "FORMAT(w.created_at, 'dd/MM/yyyy') AS created_at_formatted " +
                     "FROM Warehouse w LEFT JOIN [User] u ON w.manager_id = u.user_id WHERE w.warehouse_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    WarehouseDisplay w = new WarehouseDisplay();
                    w.setWarehouseId(rs.getInt("warehouse_id"));
                    w.setWarehouseName(rs.getString("warehouse_name"));
                    w.setAddress(rs.getString("address"));
                    w.setRegion(rs.getString("region"));
                    w.setManagerId(rs.getInt("manager_id"));
                    w.setManagerName(rs.getString("manager_name"));
                    w.setStatus(rs.getString("status"));
                    w.setCreatedAtFormatted(rs.getString("created_at_formatted"));
                    return w;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm kho mới, trả về true nếu thành công
    public boolean insertWarehouse(WarehouseDisplay warehouse) {
        String sql = "INSERT INTO Warehouse (warehouse_name, address, region, manager_id, status, created_at) VALUES (?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, warehouse.getWarehouseName());
            ps.setString(2, warehouse.getAddress());
            ps.setString(3, warehouse.getRegion());
            if (warehouse.getManagerId() > 0) {
                ps.setInt(4, warehouse.getManagerId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, warehouse.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra tên kho đã tồn tại chưa
    public boolean isWarehouseNameExists(String warehouseName) {
        String sql = "SELECT COUNT(*) FROM Warehouse WHERE warehouse_name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, warehouseName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tìm kiếm kho theo tên, trạng thái, khu vực
    public List<WarehouseDisplay> searchWarehouses(String searchName, String searchStatus, String searchRegion) {
        List<WarehouseDisplay> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT w.*, u.first_name + ' ' + u.last_name AS manager_name, ");
        sql.append("FORMAT(w.created_at, 'dd/MM/yyyy') AS created_at_formatted ");
        sql.append("FROM Warehouse w LEFT JOIN [User] u ON w.manager_id = u.user_id WHERE 1=1");

        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND w.warehouse_name LIKE ?");
        }
        if (searchStatus != null && !searchStatus.trim().isEmpty()) {
            sql.append(" AND w.status = ?");
        }
        if (searchRegion != null && !searchRegion.trim().isEmpty()) {
            sql.append(" AND w.region = ?");
        }
        sql.append(" ORDER BY w.warehouse_id ASC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (searchName != null && !searchName.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchName.trim() + "%");
            }
            if (searchStatus != null && !searchStatus.trim().isEmpty()) {
                ps.setString(paramIndex++, searchStatus.trim());
            }
            if (searchRegion != null && !searchRegion.trim().isEmpty()) {
                ps.setString(paramIndex++, searchRegion.trim());
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WarehouseDisplay w = new WarehouseDisplay();
                    w.setWarehouseId(rs.getInt("warehouse_id"));
                    w.setWarehouseName(rs.getString("warehouse_name"));
                    w.setAddress(rs.getString("address"));
                    w.setRegion(rs.getString("region"));
                    w.setManagerId(rs.getInt("manager_id"));
                    w.setManagerName(rs.getString("manager_name"));
                    w.setStatus(rs.getString("status"));
                    w.setCreatedAtFormatted(rs.getString("created_at_formatted"));
                    list.add(w);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Cập nhật kho
    public boolean updateWarehouse(WarehouseDisplay w) {
        if (w.getWarehouseId() == 0) {
            // Do not allow update for warehouse with id = 0
            return false;
        }
        String getOldManagerSql = "SELECT manager_id FROM Warehouse WHERE warehouse_id = ?";
        String updateWarehouseSql = "UPDATE Warehouse SET warehouse_name=?, address=?, region=?, manager_id=?, status=? WHERE warehouse_id=?";
        String updateUserWarehouseSql = "UPDATE [User] SET warehouse_id = ? WHERE user_id = ?";

        Connection conn = this.connection;
        boolean originalAutoCommitState = true;

        try {
            originalAutoCommitState = conn.getAutoCommit();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Lấy ID của manager cũ
            int oldManagerId = 0;
            try (PreparedStatement psGetOld = conn.prepareStatement(getOldManagerSql)) {
                psGetOld.setInt(1, w.getWarehouseId());
                try (ResultSet rs = psGetOld.executeQuery()) {
                    if (rs.next()) {
                        Object managerIdObj = rs.getObject("manager_id");
                        if (managerIdObj != null) {
                            oldManagerId = (int) managerIdObj;
                        }
                    }
                }
            }

            // 2. Cập nhật bảng Warehouse
            try (PreparedStatement psUpdateWarehouse = conn.prepareStatement(updateWarehouseSql)) {
                psUpdateWarehouse.setString(1, w.getWarehouseName());
                psUpdateWarehouse.setString(2, w.getAddress());
                psUpdateWarehouse.setString(3, w.getRegion());
                if (w.getManagerId() > 0) {
                    psUpdateWarehouse.setInt(4, w.getManagerId());
                } else {
                    psUpdateWarehouse.setNull(4, Types.INTEGER);
                }
                psUpdateWarehouse.setString(5, w.getStatus());
                psUpdateWarehouse.setInt(6, w.getWarehouseId());
                psUpdateWarehouse.executeUpdate();
            }

            int newManagerId = w.getManagerId();

            // 3. Cập nhật warehouse_id của manager cũ thành NULL (nếu có và khác manager mới)
            if (oldManagerId > 0 && oldManagerId != newManagerId) {
                try (PreparedStatement psUpdateOldManager = conn.prepareStatement(updateUserWarehouseSql)) {
                    psUpdateOldManager.setNull(1, Types.INTEGER);
                    psUpdateOldManager.setInt(2, oldManagerId);
                    psUpdateOldManager.executeUpdate();
                }
            }

            // 4. Cập nhật warehouse_id cho manager mới
            if (newManagerId > 0) {
                try (PreparedStatement psUpdateNewManager = conn.prepareStatement(updateUserWarehouseSql)) {
                    psUpdateNewManager.setInt(1, w.getWarehouseId());
                    psUpdateNewManager.setInt(2, newManagerId);
                    psUpdateNewManager.executeUpdate();
                }
            }

            conn.commit(); // Hoàn thành transaction
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(originalAutoCommitState);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Kiểm tra tên warehouse đã tồn tại (ngoại trừ warehouse hiện tại)
    public boolean isWarehouseNameExistsExcept(String warehouseName, int excludeId) {
        String sql = "SELECT COUNT(*) FROM Warehouse WHERE warehouse_name = ? AND warehouse_id != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, warehouseName);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy manager theo ID
    public User getManagerById(int managerId) {
        String sql = "SELECT user_id, first_name, last_name FROM [User] WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User manager = new User();
                    manager.setUserId(rs.getInt("user_id"));
                    manager.setFirstName(rs.getString("first_name"));
                    manager.setLastName(rs.getString("last_name"));
                    return manager;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Xoá kho
    public boolean deleteWarehouse(int id) {
        String sql = "DELETE FROM Warehouse WHERE warehouse_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy tổng số sản phẩm trong tất cả kho
    public int getTotalProductsAllWarehouses() {
        String sql = "SELECT COUNT(DISTINCT p.product_id) FROM Product p " +
                     "INNER JOIN Inventory i ON p.product_id = i.product_id " +
                     "WHERE i.quantity > 0";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Lấy tổng số sản phẩm trong một kho cụ thể
    public int getTotalProductsPerWarehouse(Integer warehouseId) {
        if (warehouseId == null) {
            return 0;
        }
        String sql = "SELECT COUNT(DISTINCT p.product_id) FROM Product p " +
                     "INNER JOIN Inventory i ON p.product_id = i.product_id " +
                     "WHERE i.warehouse_id = ? AND i.quantity > 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Lấy thống kê số sản phẩm theo từng kho
    public java.util.Map<Integer, Integer> getWarehouseProductSummary() {
        java.util.Map<Integer, Integer> summary = new java.util.HashMap<>();
        String sql = "SELECT w.warehouse_id, w.warehouse_name, " +
                     "COUNT(DISTINCT CASE WHEN i.quantity > 0 THEN p.product_id END) as product_count " +
                     "FROM Warehouse w " +
                     "LEFT JOIN Inventory i ON w.warehouse_id = i.warehouse_id " +
                     "LEFT JOIN Product p ON i.product_id = p.product_id " +
                     "WHERE w.status = 'Active' " +
                     "GROUP BY w.warehouse_id, w.warehouse_name " +
                     "ORDER BY w.warehouse_name";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                summary.put(rs.getInt("warehouse_id"), rs.getInt("product_count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return summary;
    }
    
    // Lấy thống kê số sản phẩm cho một kho cụ thể
    public java.util.Map<Integer, Integer> getWarehouseProductSummaryByWarehouseId(Integer warehouseId) {
        java.util.Map<Integer, Integer> summary = new java.util.HashMap<>();
        if (warehouseId == null) {
            return summary;
        }
        
        String sql = "SELECT w.warehouse_id, w.warehouse_name, " +
                     "COUNT(DISTINCT CASE WHEN i.quantity > 0 THEN p.product_id END) as product_count " +
                     "FROM Warehouse w " +
                     "LEFT JOIN Inventory i ON w.warehouse_id = i.warehouse_id " +
                     "LEFT JOIN Product p ON i.product_id = p.product_id " +
                     "WHERE w.status = 'Active' AND w.warehouse_id = ? " +
                     "GROUP BY w.warehouse_id, w.warehouse_name " +
                     "ORDER BY w.warehouse_name";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    summary.put(rs.getInt("warehouse_id"), rs.getInt("product_count"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return summary;
    }
}