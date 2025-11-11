package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PurchaseRequest;
import model.PurchaseRequestItem;

public class PurchaseRequestDAO extends DBConnect {

    public synchronized String generatePrNumber() {
        String sql = "SELECT COUNT(*) AS total FROM Purchase_Request";
        int count = 0;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return String.format("PR-%04d", count + 1);
    }

    public boolean createPurchaseRequest(PurchaseRequest pr) {
        String prNumber = generatePrNumber();
        pr.setPrNumber(prNumber);
        String insertPrSql = "INSERT INTO Purchase_Request (pr_number, requested_by, request_date, warehouse_id, preferred_delivery_date, reason, status, confirm_by, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertItemSql = "INSERT INTO Purchase_Request_Item (pr_id, product_id, quantity, note) VALUES (?, ?, ?, ?)";
        boolean success = false;
        try {
            connection.setAutoCommit(false);

            try (PreparedStatement psPr = connection.prepareStatement(insertPrSql, Statement.RETURN_GENERATED_KEYS)) {
                psPr.setString(1, pr.getPrNumber());
                psPr.setInt(2, pr.getRequestedBy());
                psPr.setTimestamp(3, pr.getRequestDate());
                psPr.setInt(4, pr.getWarehouseId());
                if (pr.getPreferredDeliveryDate() != null) {
                    psPr.setDate(5, pr.getPreferredDeliveryDate());
                } else {
                    psPr.setNull(5, Types.DATE);
                }
                psPr.setString(6, pr.getReason());
                psPr.setString(7, pr.getStatus());
                if (pr.getConfirmBy() != null) {
                    psPr.setInt(8, pr.getConfirmBy());
                } else {
                    psPr.setNull(8, Types.INTEGER);
                }
                psPr.setTimestamp(9, pr.getCreatedAt());

                int affectedRows = psPr.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Creating purchase request failed, no rows affected.");
                }

                try (ResultSet generatedKeys = psPr.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int prId = generatedKeys.getInt(1);

                        if (pr.getItems() != null && !pr.getItems().isEmpty()) {
                            try (PreparedStatement psItem = connection.prepareStatement(insertItemSql)) {
                                for (PurchaseRequestItem item : pr.getItems()) {
                                    psItem.setInt(1, prId);
                                    psItem.setInt(2, item.getProductId());
                                    psItem.setInt(3, item.getQuantity());
                                    if (item.getNote() != null) {
                                        psItem.setString(4, item.getNote());
                                    } else {
                                        psItem.setNull(4, Types.VARCHAR);
                                    }
                                    psItem.addBatch();
                                }
                                psItem.executeBatch();
                            }
                        }
                        connection.commit();
                        success = true;
                    } else {
                        throw new SQLException("Creating purchase request failed, no ID obtained.");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return success;
    }

    public PurchaseRequest getPurchaseRequestById(int prId) {
        PurchaseRequest pr = null;
        String prSql = "SELECT pr.*, u1.first_name AS requestedByFirstName, u1.last_name AS requestedByLastName, " +
                       "u2.first_name AS confirmByFirstName, u2.last_name AS confirmByLastName " +
                       "FROM Purchase_Request pr " +
                       "LEFT JOIN [User] u1 ON pr.requested_by = u1.user_id " +
                       "LEFT JOIN [User] u2 ON pr.confirm_by = u2.user_id " +
                       "WHERE pr.pr_id = ?";
        String itemsSql = "SELECT pri.*, p.name as productName, p.code as productCode "
                + "FROM Purchase_Request_Item pri "
                + "JOIN Product p ON pri.product_id = p.product_id "
                + "WHERE pri.pr_id = ?";
        try (PreparedStatement psPr = connection.prepareStatement(prSql)) {
            psPr.setInt(1, prId);
            try (ResultSet rsPr = psPr.executeQuery()) {
                if (rsPr.next()) {
                    pr = new PurchaseRequest();
                    pr.setPrId(rsPr.getInt("pr_id"));
                    pr.setPrNumber(rsPr.getString("pr_number"));
                    pr.setRequestedBy(rsPr.getInt("requested_by"));
                    pr.setRequestDate(rsPr.getTimestamp("request_date"));
                    pr.setWarehouseId(rsPr.getInt("warehouse_id"));
                    pr.setPreferredDeliveryDate(rsPr.getDate("preferred_delivery_date"));
                    pr.setReason(rsPr.getString("reason"));
                    pr.setStatus(rsPr.getString("status"));
                    int confirmBy = rsPr.getInt("confirm_by");
                    if (!rsPr.wasNull()) {
                        pr.setConfirmBy(confirmBy);
                    }
                    pr.setCreatedAt(rsPr.getTimestamp("created_at"));

                    // Set requestedByName
                    String requestedByName = rsPr.getString("requestedByFirstName") + " " + rsPr.getString("requestedByLastName");
                    pr.setRequestedByName(requestedByName.trim());

                    // Set confirmByName
                    String confirmByFirstName = rsPr.getString("confirmByFirstName");
                    String confirmByLastName = rsPr.getString("confirmByLastName");
                    if (confirmByFirstName != null && confirmByLastName != null) {
                        pr.setConfirmByName((confirmByFirstName + " " + confirmByLastName).trim());
                    } else {
                        pr.setConfirmByName("");
                    }

                    try (PreparedStatement psItems = connection.prepareStatement(itemsSql)) {
                        psItems.setInt(1, prId);
                        try (ResultSet rsItems = psItems.executeQuery()) {
                            List<PurchaseRequestItem> items = new ArrayList<>();
                            while (rsItems.next()) {
                                PurchaseRequestItem item = new PurchaseRequestItem();
                                item.setPrItemId(rsItems.getInt("pr_item_id"));
                                item.setPrId(rsItems.getInt("pr_id"));
                                item.setProductId(rsItems.getInt("product_id"));
                                item.setQuantity(rsItems.getInt("quantity"));
                                item.setNote(rsItems.getString("note"));
                                item.setProductName(rsItems.getString("productName"));
                                item.setProductCode(rsItems.getString("productCode"));
                                items.add(item);
                            }
                            pr.setItems(items);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pr;
    }

    public List<PurchaseRequest> getPurchaseRequestsByFilter(String status, String searchTerm) {
        List<PurchaseRequest> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT pr.*, u.first_name, u.last_name, w.warehouse_name "
                + "FROM Purchase_Request pr "
                + "JOIN [User] u ON pr.requested_by = u.user_id "
                + "JOIN Warehouse w ON pr.warehouse_id = w.warehouse_id "
                + "WHERE 1=1 ");

        if (status != null && !status.isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND pr.status = ? ");
        }
        // Thay đổi filter searchTerm thành filter theo khoảng ngày request_date
        if (searchTerm != null && !searchTerm.isEmpty()) {
            // Giả sử searchTerm là chuỗi ngày bắt đầu và ngày kết thúc cách nhau dấu phẩy, ví dụ "2023-01-01,2023-01-31"
            String[] dates = searchTerm.split(",");
            if (dates.length == 2) {
                sql.append("AND pr.request_date >= ? AND pr.request_date <= ? ");
            }
        }
        sql.append("ORDER BY pr.created_at DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (status != null && !status.isEmpty() && !"all".equalsIgnoreCase(status)) {
                ps.setString(paramIndex++, status);
            }
            if (searchTerm != null && !searchTerm.isEmpty()) {
                String[] dates = searchTerm.split(",");
                if (dates.length == 2) {
                    ps.setDate(paramIndex++, java.sql.Date.valueOf(dates[0]));
                    ps.setDate(paramIndex++, java.sql.Date.valueOf(dates[1]));
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PurchaseRequest pr = new PurchaseRequest();
                    pr.setPrId(rs.getInt("pr_id"));
                    pr.setPrNumber(rs.getString("pr_number"));
                    pr.setRequestedBy(rs.getInt("requested_by"));
                    pr.setRequestDate(rs.getTimestamp("request_date"));
                    pr.setWarehouseId(rs.getInt("warehouse_id"));
                    pr.setPreferredDeliveryDate(rs.getDate("preferred_delivery_date"));
                    pr.setReason(rs.getString("reason"));
                    pr.setStatus(rs.getString("status"));
                    int confirmBy = rs.getInt("confirm_by");
                    if (!rs.wasNull()) {
                        pr.setConfirmBy(confirmBy);
                    }
                    pr.setCreatedAt(rs.getTimestamp("created_at"));
                    pr.setRequestedByName(rs.getString("first_name") + " " + rs.getString("last_name"));
                    pr.setWarehouseName(rs.getString("warehouse_name"));
                    list.add(pr);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PurchaseRequest> getAllPurchaseRequests() {
        return getPurchaseRequestsByFilter("all", null);
    }

    public boolean updatePurchaseRequest(PurchaseRequest pr) {
        String updatePrSql = "UPDATE Purchase_Request SET preferred_delivery_date = ?, reason = ?, status = ?, confirm_by = ? WHERE pr_id = ?";
        String deleteItemsSql = "DELETE FROM Purchase_Request_Item WHERE pr_id = ?";
        String insertItemSql = "INSERT INTO Purchase_Request_Item (pr_id, product_id, quantity, note) VALUES (?, ?, ?, ?)";
        boolean success = false;
        try {
            connection.setAutoCommit(false);

            try (PreparedStatement psUpdate = connection.prepareStatement(updatePrSql)) {
                if (pr.getPreferredDeliveryDate() != null) {
                    psUpdate.setDate(1, pr.getPreferredDeliveryDate());
                } else {
                    psUpdate.setNull(1, Types.DATE);
                }
                psUpdate.setString(2, pr.getReason());
                psUpdate.setString(3, pr.getStatus());
                if (pr.getConfirmBy() != null) {
                    psUpdate.setInt(4, pr.getConfirmBy());
                } else {
                    psUpdate.setNull(4, Types.INTEGER);
                }
                psUpdate.setInt(5, pr.getPrId());

                int affectedRows = psUpdate.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Updating purchase request failed, no rows affected.");
                }
            }

            try (PreparedStatement psDelete = connection.prepareStatement(deleteItemsSql)) {
                psDelete.setInt(1, pr.getPrId());
                psDelete.executeUpdate();
            }

            if (pr.getItems() != null && !pr.getItems().isEmpty()) {
                try (PreparedStatement psInsert = connection.prepareStatement(insertItemSql)) {
                    for (PurchaseRequestItem item : pr.getItems()) {
                        psInsert.setInt(1, pr.getPrId());
                        psInsert.setInt(2, item.getProductId());
                        psInsert.setInt(3, item.getQuantity());
                        if (item.getNote() != null) {
                            psInsert.setString(4, item.getNote());
                        } else {
                            psInsert.setNull(4, Types.VARCHAR);
                        }
                        psInsert.addBatch();
                    }
                    psInsert.executeBatch();
                }
            }

            connection.commit();
            success = true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return success;
    }

    public boolean deletePurchaseRequest(int prId) {
        String deleteItemsSql = "DELETE FROM Purchase_Request_Item WHERE pr_id = ?";
        String deletePrSql = "DELETE FROM Purchase_Request WHERE pr_id = ?";
        boolean success = false;
        try {
            connection.setAutoCommit(false);

            try (PreparedStatement psDeleteItems = connection.prepareStatement(deleteItemsSql)) {
                psDeleteItems.setInt(1, prId);
                psDeleteItems.executeUpdate();
            }

            try (PreparedStatement psDeletePr = connection.prepareStatement(deletePrSql)) {
                int affectedRows = 0;
                psDeletePr.setInt(1, prId);
                affectedRows = psDeletePr.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Deleting purchase request failed, no rows affected.");
                }
            }

            connection.commit();
            success = true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return success;
    }
}
