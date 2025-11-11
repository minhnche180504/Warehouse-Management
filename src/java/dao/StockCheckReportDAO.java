package dao;

import model.StockCheckReport;
import model.StockCheckReportItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StockCheckReportDAO extends DBConnect {

    // Tạo một báo cáo kiểm kê mới và các mục chi tiết của nó
    public int createStockCheckReport(StockCheckReport report) {
        // Cập nhật câu lệnh SQL để bao gồm manager_notes
        String sqlReport = "INSERT INTO StockCheckReport (report_code, warehouse_id, report_date, created_by, status, notes, manager_notes) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlItem = "INSERT INTO StockCheckReportItem (report_id, product_id, system_quantity, counted_quantity, discrepancy, reason) VALUES (?, ?, ?, ?, ?, ?)";
        int reportId = -1;

        try {
            connection.setAutoCommit(false); // Bắt đầu transaction

            // Thêm thông tin chung của báo cáo
            try (PreparedStatement psReport = connection.prepareStatement(sqlReport, Statement.RETURN_GENERATED_KEYS)) {
                psReport.setString(1, report.getReportCode());
                psReport.setInt(2, report.getWarehouseId());
                psReport.setDate(3, report.getReportDate());
                psReport.setInt(4, report.getCreatedBy());
                psReport.setString(5, report.getStatus());
                psReport.setString(6, report.getNotes()); // Ghi chú của Staff
                psReport.setString(7, report.getManagerNotes()); // Ghi chú của Manager
                psReport.executeUpdate();

                try (ResultSet generatedKeys = psReport.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        reportId = generatedKeys.getInt(1);
                    } else {
                        connection.rollback();
                        throw new SQLException("Tạo báo cáo kiểm kê thất bại, không lấy được ID.");
                    }
                }
            }

            // Thêm các mục chi tiết của báo cáo
            if (report.getItems() != null && !report.getItems().isEmpty()) {
                try (PreparedStatement psItem = connection.prepareStatement(sqlItem)) {
                    for (StockCheckReportItem item : report.getItems()) {
                        psItem.setInt(1, reportId);
                        psItem.setInt(2, item.getProductId());
                        psItem.setInt(3, item.getSystemQuantity());
                        psItem.setInt(4, item.getCountedQuantity());
                        item.setDiscrepancy(item.getCountedQuantity() - item.getSystemQuantity()); // Tính toán discrepancy
                        psItem.setInt(5, item.getDiscrepancy());
                        psItem.setString(6, item.getReason());
                        psItem.addBatch();
                    }
                    psItem.executeBatch();
                }
            }

            // Nếu là manager tạo và status là Completed thì cập nhật tồn kho
            if ("Completed".equalsIgnoreCase(report.getStatus())) {
                String sqlUpdateInventory = "UPDATE Inventory SET quantity = ? WHERE warehouse_id = ? AND product_id = ?";
                try (PreparedStatement ps = connection.prepareStatement(sqlUpdateInventory)) {
                    for (StockCheckReportItem item : report.getItems()) {
                        ps.setInt(1, item.getCountedQuantity());
                        ps.setInt(2, report.getWarehouseId());
                        ps.setInt(3, item.getProductId());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            connection.commit(); // Kết thúc transaction thành công
        } catch (SQLException e) {
            try {
                connection.rollback(); // Rollback nếu có lỗi
            } catch (SQLException ex) {
                System.out.println("Lỗi khi rollback transaction: " + ex.getMessage());
            }
            System.out.println("Lỗi khi tạo báo cáo kiểm kê: " + e.getMessage());
            e.printStackTrace();
            return -1; // Báo hiệu thất bại
        } finally {
            try {
                connection.setAutoCommit(true); // Trả lại auto-commit
            } catch (SQLException ex) {
                System.out.println("Lỗi khi reset auto-commit: " + ex.getMessage());
            }
        }
        return reportId;
    }

    // Lấy báo cáo kiểm kê bằng ID, bao gồm các mục chi tiết và tên liên quan
    public StockCheckReport getStockCheckReportById(int reportId) {
        StockCheckReport report = null;
        String sqlReport = "SELECT scr.*, w.warehouse_name, "
                + "u_created.first_name + ' ' + u_created.last_name AS created_by_name, "
                + "u_approved.first_name + ' ' + u_approved.last_name AS approved_by_name "
                + "FROM StockCheckReport scr "
                + "JOIN Warehouse w ON scr.warehouse_id = w.warehouse_id "
                + "JOIN [User] u_created ON scr.created_by = u_created.user_id "
                + "LEFT JOIN [User] u_approved ON scr.approved_by = u_approved.user_id "
                + "WHERE scr.report_id = ?";
        String sqlItems = "SELECT scri.*, p.name as product_name, p.code as product_code "
                + "FROM StockCheckReportItem scri "
                + "JOIN Product p ON scri.product_id = p.product_id "
                + "WHERE scri.report_id = ?";

        try (PreparedStatement psReport = connection.prepareStatement(sqlReport)) {
            psReport.setInt(1, reportId);
            try (ResultSet rsReport = psReport.executeQuery()) {
                if (rsReport.next()) {
                    report = new StockCheckReport();
                    report.setReportId(rsReport.getInt("report_id"));
                    report.setReportCode(rsReport.getString("report_code"));
                    report.setWarehouseId(rsReport.getInt("warehouse_id"));
                    report.setWarehouseName(rsReport.getString("warehouse_name"));
                    report.setReportDate(rsReport.getDate("report_date"));
                    report.setCreatedBy(rsReport.getInt("created_by"));
                    report.setCreatedByName(rsReport.getString("created_by_name"));
                    report.setCreatedAt(rsReport.getTimestamp("created_at"));
                    report.setStatus(rsReport.getString("status"));
                    report.setNotes(rsReport.getString("notes"));
                    if (rsReport.getObject("approved_by") != null) {
                        report.setApprovedBy(rsReport.getInt("approved_by"));
                        report.setApprovedByName(rsReport.getString("approved_by_name"));
                    }
                    report.setApprovedAt(rsReport.getTimestamp("approved_at"));
                    report.setManagerNotes(rsReport.getString("manager_notes"));

                    List<StockCheckReportItem> items = new ArrayList<>();
                    try (PreparedStatement psItems = connection.prepareStatement(sqlItems)) {
                        psItems.setInt(1, reportId);
                        try (ResultSet rsItems = psItems.executeQuery()) {
                            while (rsItems.next()) {
                                StockCheckReportItem item = new StockCheckReportItem();
                                item.setReportItemId(rsItems.getInt("report_item_id"));
                                item.setReportId(rsItems.getInt("report_id"));
                                item.setProductId(rsItems.getInt("product_id"));
                                item.setProductName(rsItems.getString("product_name"));
                                item.setProductCode(rsItems.getString("product_code"));
                                item.setSystemQuantity(rsItems.getInt("system_quantity"));
                                item.setCountedQuantity(rsItems.getInt("counted_quantity"));
                                item.setDiscrepancy(rsItems.getInt("discrepancy"));
                                item.setReason(rsItems.getString("reason"));
                                items.add(item);
                            }
                        }
                    }
                    report.setItems(items);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy báo cáo kiểm kê bằng ID: " + e.getMessage());
            e.printStackTrace();
        }
        return report;
    }

    // Lấy danh sách báo cáo kiểm kê với các bộ lọc (đã bỏ createdById)
    public List<StockCheckReport> getStockCheckReportsByFilters(Integer warehouseId, String status, java.util.Date fromDate, java.util.Date toDate, String reportCode, Integer userId) {
        List<StockCheckReport> reports = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT scr.report_id, scr.report_code, w.warehouse_name, scr.report_date, scr.created_by, "
                + "u_created.first_name + ' ' + u_created.last_name AS created_by_name, scr.status, "
                + "u_approved.first_name + ' ' + u_approved.last_name AS approved_by_name, scr.approved_at "
                + "FROM StockCheckReport scr "
                + "JOIN Warehouse w ON scr.warehouse_id = w.warehouse_id "
                + "JOIN [User] u_created ON scr.created_by = u_created.user_id "
                + "LEFT JOIN [User] u_approved ON scr.approved_by = u_approved.user_id "
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (warehouseId != null && warehouseId > 0) {
            sqlBuilder.append("AND scr.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (status != null && !status.trim().isEmpty()) {
            if ("Draft".equalsIgnoreCase(status)) {
                // Chỉ lấy các báo cáo Draft của user hiện tại
                sqlBuilder.append("AND scr.status = ? AND scr.created_by = ? ");
                params.add(status);
                params.add(userId);
            } else {
                // Lấy các báo cáo trạng thái khác Draft trong kho
                sqlBuilder.append("AND scr.status = ? ");
                params.add(status);
            }
        }
        if (fromDate != null) {
            sqlBuilder.append("AND scr.report_date >= ? ");
            params.add(new java.sql.Date(fromDate.getTime()));
        }
        if (toDate != null) {
            sqlBuilder.append("AND scr.report_date <= ? ");
            params.add(new java.sql.Date(toDate.getTime()));
        }
        if (reportCode != null && !reportCode.trim().isEmpty()) {
            sqlBuilder.append("AND scr.report_code LIKE ? ");
            params.add("%" + reportCode.trim() + "%");
        }

        sqlBuilder.append("ORDER BY scr.report_date DESC, scr.report_id DESC");

        try (PreparedStatement ps = connection.prepareStatement(sqlBuilder.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StockCheckReport report = new StockCheckReport();
                report.setReportId(rs.getInt("report_id"));
                report.setReportCode(rs.getString("report_code"));
                report.setWarehouseName(rs.getString("warehouse_name"));
                report.setReportDate(rs.getDate("report_date"));
                report.setCreatedBy(rs.getInt("created_by"));
                report.setCreatedByName(rs.getString("created_by_name"));
                report.setStatus(rs.getString("status"));
                report.setApprovedByName(rs.getString("approved_by_name"));
                report.setApprovedAt(rs.getTimestamp("approved_at"));
                reports.add(report);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy báo cáo kiểm kê theo bộ lọc: " + e.getMessage());
            e.printStackTrace();
        }
        return reports;
    }

    // Cập nhật toàn bộ thông tin báo cáo và chi tiết (xóa chi tiết cũ, thêm chi tiết mới)
    public boolean updateStockCheckReport(StockCheckReport report) {
        String sqlUpdateReport = "UPDATE StockCheckReport SET report_code = ?, warehouse_id = ?, report_date = ?, notes = ?, status = ? WHERE report_id = ? AND status = 'Draft'";
        String sqlDeleteItems = "DELETE FROM StockCheckReportItem WHERE report_id = ?";
        String sqlInsertItem = "INSERT INTO StockCheckReportItem (report_id, product_id, system_quantity, counted_quantity, discrepancy, reason) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            connection.setAutoCommit(false);

            // Cập nhật thông tin chung của báo cáo
            try (PreparedStatement psReport = connection.prepareStatement(sqlUpdateReport)) {
                psReport.setString(1, report.getReportCode());
                psReport.setInt(2, report.getWarehouseId());
                psReport.setDate(3, report.getReportDate());
                psReport.setString(4, report.getNotes());
                psReport.setString(5, report.getStatus()); // Truyền status mới (Draft hoặc Pending)
                psReport.setInt(6, report.getReportId());
                int rowsUpdated = psReport.executeUpdate();
                if (rowsUpdated == 0) {
                    connection.rollback();
                    return false;
                }
            }

            // Xóa các mục chi tiết cũ
            try (PreparedStatement psDeleteItems = connection.prepareStatement(sqlDeleteItems)) {
                psDeleteItems.setInt(1, report.getReportId());
                psDeleteItems.executeUpdate();
            }

            // Thêm các mục chi tiết mới
            if (report.getItems() != null && !report.getItems().isEmpty()) {
                try (PreparedStatement psItem = connection.prepareStatement(sqlInsertItem)) {
                    for (StockCheckReportItem item : report.getItems()) {
                        psItem.setInt(1, report.getReportId());
                        psItem.setInt(2, item.getProductId());
                        psItem.setInt(3, item.getSystemQuantity());
                        psItem.setInt(4, item.getCountedQuantity());
                        item.setDiscrepancy(item.getCountedQuantity() - item.getSystemQuantity());
                        psItem.setInt(5, item.getDiscrepancy());
                        psItem.setString(6, item.getReason());
                        psItem.addBatch();
                    }
                    psItem.executeBatch();
                }
            }
            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.out.println("Lỗi khi rollback transaction: " + ex.getMessage());
            }
            System.out.println("Lỗi khi cập nhật báo cáo kiểm kê: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                System.out.println("Lỗi khi reset auto-commit: " + ex.getMessage());
            }
        }
    }

    // Xóa một báo cáo kiểm kê (chỉ khi status là Pending)
    public boolean deleteStockCheckReport(int reportId) {
        // Cần xóa items trước nếu không có ON DELETE CASCADE
        String sqlDeleteItems = "DELETE FROM StockCheckReportItem WHERE report_id = ?";
        String sqlDeleteReport = "DELETE FROM StockCheckReport WHERE report_id = ? AND status = 'Draft'";
        try {
            connection.setAutoCommit(false);
            try (PreparedStatement psItems = connection.prepareStatement(sqlDeleteItems)) {
                psItems.setInt(1, reportId);
                psItems.executeUpdate();
            }
            try (PreparedStatement psReport = connection.prepareStatement(sqlDeleteReport)) {
                psReport.setInt(1, reportId);
                int rowsAffected = psReport.executeUpdate();
                if (rowsAffected > 0) {
                    connection.commit();
                    return true;
                } else {
                    connection.rollback();
                    return false; // Không xóa được report (có thể do status khác Pending)
                }
            }
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.out.println("Lỗi khi rollback transaction: " + ex.getMessage());
            }
            System.out.println("Lỗi khi xóa báo cáo kiểm kê: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                System.out.println("Lỗi khi reset auto-commit: " + ex.getMessage());
            }
        }
    }

    // Kiểm tra xem report_code đã tồn tại chưa (hữu ích khi tạo/sửa)
    public boolean isReportCodeExists(String reportCode) {
        // Trả về true nếu đã tồn tại mã này trong DB
        String sql = "SELECT 1 FROM StockCheckReport WHERE report_code = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, reportCode);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // Nếu lỗi thì coi như đã tồn tại để tránh trùng
        }
    }

    public boolean isReportCodeExists(String reportCode, int excludeReportId) {
        String sql = "SELECT 1 FROM StockCheckReport WHERE report_code = ? AND report_id != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, reportCode);
            ps.setInt(2, excludeReportId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // Fail-safe: assume it exists on error
        }
    }

    public synchronized String generateUniqueReportCode() {
        // Tìm số lớn nhất từ các mã hiện có (ví dụ: từ SCR-009 -> 9)
        String sql = "SELECT MAX(CAST(SUBSTRING(report_code, 5, LEN(report_code)) AS INT)) FROM StockCheckReport WHERE report_code LIKE 'SCR-%' AND ISNUMERIC(SUBSTRING(report_code, 5, LEN(report_code))) = 1";
        int maxNumber = 0;
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                maxNumber = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Could not get max report code number, starting from 0. Error: " + e.getMessage());
        }
        return String.format("SCR-%03d", maxNumber + 1);
    }

    public boolean approveReport(int reportId, int approvedBy, String managerNotes) {
        String sql = "UPDATE StockCheckReport SET status = 'Approved', approved_by = ?, approved_at = GETDATE(), manager_notes = ? WHERE report_id = ? AND status = 'Pending'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, approvedBy);
            ps.setString(2, managerNotes);
            ps.setInt(3, reportId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi khi duyệt báo cáo kiểm kê: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean rejectReport(int reportId, int rejectedBy, String managerNotes) {
        String sql = "UPDATE StockCheckReport SET status = 'Rejected', approved_by = ?, approved_at = GETDATE(), manager_notes = ? WHERE report_id = ? AND status = 'Pending'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, rejectedBy);
            ps.setString(2, managerNotes);
            ps.setInt(3, reportId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi khi từ chối báo cáo kiểm kê: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean completeReport(int reportId) {
        // 1. Lấy warehouse_id của báo cáo
        String sqlGetWarehouse = "SELECT warehouse_id FROM StockCheckReport WHERE report_id = ?";
        // 2. Lấy danh sách sản phẩm và số lượng kiểm kê thực tế
        String sqlGetItems = "SELECT product_id, counted_quantity FROM StockCheckReportItem WHERE report_id = ?";
        // 3. Cập nhật tồn kho
        String sqlUpdateInventory = "UPDATE Inventory SET quantity = ? WHERE warehouse_id = ? AND product_id = ?";
        // 4. Cập nhật trạng thái báo cáo
        String sqlUpdateReport = "UPDATE StockCheckReport SET status = 'Completed' WHERE report_id = ? AND status = 'Approved'";

        try {
            connection.setAutoCommit(false);

            int warehouseId = -1;
            try (PreparedStatement ps = connection.prepareStatement(sqlGetWarehouse)) {
                ps.setInt(1, reportId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        warehouseId = rs.getInt("warehouse_id");
                    } else {
                        connection.rollback();
                        return false;
                    }
                }
            }

            // Lấy danh sách sản phẩm và số lượng kiểm kê thực tế
            List<int[]> items = new ArrayList<>(); // [product_id, counted_quantity]
            try (PreparedStatement ps = connection.prepareStatement(sqlGetItems)) {
                ps.setInt(1, reportId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        items.add(new int[]{rs.getInt("product_id"), rs.getInt("counted_quantity")});
                    }
                }
            }

            // Cập nhật tồn kho từng sản phẩm
            try (PreparedStatement ps = connection.prepareStatement(sqlUpdateInventory)) {
                for (int[] item : items) {
                    ps.setInt(1, item[1]); // counted_quantity
                    ps.setInt(2, warehouseId);
                    ps.setInt(3, item[0]); // product_id
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            // Cập nhật trạng thái báo cáo
            try (PreparedStatement ps = connection.prepareStatement(sqlUpdateReport)) {
                ps.setInt(1, reportId);
                int updated = ps.executeUpdate();
                if (updated == 0) {
                    connection.rollback();
                    return false;
                }
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
            }
            System.out.println("Lỗi khi hoàn thành báo cáo kiểm kê và cập nhật tồn kho: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception ex) {
            }
        }
    }

    public int countAllReports() {
        String sql = "SELECT COUNT(*) FROM StockCheckReport";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<StockCheckReport> getUnapprovedStockCheckReports(int warehouseId) {
        List<StockCheckReport> list = new ArrayList<>();
        String sql = "SELECT TOP 5 report_id, warehouse_id, report_date, status, created_by "
                + "FROM StockCheckReport WHERE status = 'Pending' AND warehouse_id = ? ORDER BY report_date DESC";
        try (Connection conn = connection; PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, warehouseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    StockCheckReport report = new StockCheckReport();
                    report.setReportId(rs.getInt("report_id"));
                    report.setWarehouseId(rs.getInt("warehouse_id"));
                    report.setReportDate(rs.getDate("report_date"));
                    report.setStatus(rs.getString("status"));
                    report.setCreatedBy(rs.getInt("created_by"));
                    // Set other fields as needed
                    list.add(report);
                }
            }
        } catch (SQLException e) {
            System.out.println("getUnapprovedStockCheckReports: " + e.getMessage());
        }
        return list;
    }
}
