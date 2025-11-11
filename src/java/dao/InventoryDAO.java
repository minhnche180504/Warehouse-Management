package dao;

import java.sql.*;
import java.util.*;
import java.math.BigDecimal;
import model.Inventory;
import model.InventoryDetail;
import model.ProductAttribute;
import java.sql.Timestamp;

public class InventoryDAO extends DBConnect {

    /**
     * Lấy danh sách sản phẩm có tồn kho theo warehouse
     */
    public List<Inventory> getProductsByWarehouse(int warehouseId) {
        List<Inventory> products = new ArrayList<>();
        String sql = "SELECT i.inventory_id, i.product_id, i.warehouse_id, i.quantity, "
                + "p.code as product_code, p.name as product_name, p.description as product_description, "
                + "p.price, u.unit_name, u.unit_code, "
                + "w.warehouse_name "
                + "FROM Inventory i "
                + "INNER JOIN Product p ON i.product_id = p.product_id "
                + "INNER JOIN Unit u ON p.unit_id = u.unit_id "
                + "INNER JOIN Warehouse w ON i.warehouse_id = w.warehouse_id "
                + "WHERE i.warehouse_id = ? AND i.quantity > 0 "
                + "ORDER BY p.name";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Inventory inventory = new Inventory();
                    inventory.setInventoryId(rs.getInt("inventory_id"));
                    inventory.setProductId(rs.getInt("product_id"));
                    inventory.setWarehouseId(rs.getInt("warehouse_id"));
                    inventory.setQuantity(rs.getInt("quantity"));
                    inventory.setProductCode(rs.getString("product_code"));
                    inventory.setProductName(rs.getString("product_name"));
                    inventory.setProductDescription(rs.getString("product_description"));
                    inventory.setPrice(rs.getBigDecimal("price"));
                    inventory.setUnit(rs.getString("unit_name"));
                    inventory.setWarehouseName(rs.getString("warehouse_name"));

                    products.add(inventory);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting products by warehouse: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Lấy giá sản phẩm theo ID
     */
    public BigDecimal getProductPrice(int productId) {
        String sql = "SELECT price FROM Product WHERE product_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("price");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting product price: " + e.getMessage());
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    /**
     * Kiểm tra tồn kho của sản phẩm trong warehouse
     */
    public boolean checkStock(int productId, int warehouseId, int requiredQuantity) {
        String sql = "SELECT quantity FROM Inventory WHERE product_id = ? AND warehouse_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int currentStock = rs.getInt("quantity");
                    return currentStock >= requiredQuantity;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking stock: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật tồn kho sau khi xuất hàng
     */
    public boolean updateInventory(int productId, int warehouseId, int quantityChange) {
        String sql = "UPDATE Inventory SET quantity = quantity + ? WHERE product_id = ? AND warehouse_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quantityChange); // Số âm để trừ kho
            ps.setInt(2, productId);
            ps.setInt(3, warehouseId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("Error updating inventory: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy số lượng tồn kho hiện tại
     */
    public int getCurrentStock(int productId, int warehouseId) {
        String sql = "SELECT quantity FROM Inventory WHERE product_id = ? AND warehouse_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("quantity");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting current stock: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Tạo record inventory nếu chưa tồn tại
     */
    public boolean createInventoryRecord(int productId, int warehouseId, int initialQuantity) {
        String sql = "INSERT INTO Inventory (product_id, warehouse_id, quantity) VALUES (?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);
            ps.setInt(3, initialQuantity);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("Error creating inventory record: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy thông tin chi tiết sản phẩm với tồn kho
     */
    public Inventory getProductInventoryDetail(int productId, int warehouseId) {
        String sql = "SELECT i.inventory_id, i.product_id, i.warehouse_id, i.quantity, "
                + "p.code as product_code, p.name as product_name, p.description as product_description, "
                + "p.price, u.unit_name, u.unit_code, "
                + "w.warehouse_name "
                + "FROM Inventory i "
                + "INNER JOIN Product p ON i.product_id = p.product_id "
                + "INNER JOIN Unit u ON p.unit_id = u.unit_id "
                + "INNER JOIN Warehouse w ON i.warehouse_id = w.warehouse_id "
                + "WHERE i.product_id = ? AND i.warehouse_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Inventory inventory = new Inventory();
                    inventory.setInventoryId(rs.getInt("inventory_id"));
                    inventory.setProductId(rs.getInt("product_id"));
                    inventory.setWarehouseId(rs.getInt("warehouse_id"));
                    inventory.setQuantity(rs.getInt("quantity"));
                    inventory.setProductCode(rs.getString("product_code"));
                    inventory.setProductName(rs.getString("product_name"));
                    inventory.setProductDescription(rs.getString("product_description"));
                    inventory.setPrice(rs.getBigDecimal("price"));
                    inventory.setUnit(rs.getString("unit_name"));
                    inventory.setWarehouseName(rs.getString("warehouse_name"));

                    return inventory;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting product inventory detail: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public InventoryDetail getInventoryDetail(int productId, int warehouseId) {
        InventoryDetail detail = new InventoryDetail();
        String sqlCore = "SELECT p.code AS product_code, p.name AS product_name, p.description AS product_description, "
                + "u.unit_name AS unit, p.price, s.name AS supplier_name, "
                + "w.warehouse_name, w.region, i.quantity AS quantity_on_hand "
                + "FROM Product p "
                + "JOIN Inventory i ON p.product_id = i.product_id "
                + "LEFT JOIN Unit u ON p.unit_id = u.unit_id "
                + "LEFT JOIN Supplier s ON p.supplier_id = s.supplier_id "
                + "LEFT JOIN Warehouse w ON i.warehouse_id = w.warehouse_id "
                + "WHERE p.product_id = ? AND i.warehouse_id = ?";

        try (PreparedStatement psCore = connection.prepareStatement(sqlCore)) {
            psCore.setInt(1, productId);
            psCore.setInt(2, warehouseId);

            try (ResultSet rsCore = psCore.executeQuery()) {
                if (rsCore.next()) {
                    detail.setProductCode(rsCore.getString("product_code"));
                    detail.setProductName(rsCore.getString("product_name"));
                    detail.setProductDescription(rsCore.getString("product_description"));
                    detail.setUnit(rsCore.getString("unit"));
                    detail.setPrice(rsCore.getBigDecimal("price"));
                    detail.setSupplierName(rsCore.getString("supplier_name"));
                    detail.setWarehouseName(rsCore.getString("warehouse_name"));
                    detail.setRegion(rsCore.getString("region"));
                    detail.setQuantityOnHand(rsCore.getInt("quantity_on_hand"));
                } else {
                    return null; // Product or inventory record not found
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting core inventory detail: " + e.getMessage());
            e.printStackTrace();
            return null;
        }

        // Get Product Attributes
        ProductAttributeDAO attributeDAO = new ProductAttributeDAO();
        detail.setProductAttributes(attributeDAO.getAttributesByProductId(productId));

        // Get Last Import Date
        String sqlLastImport = "SELECT MAX(created_at) AS last_import_date FROM Inventory_Transaction "
                + "WHERE product_id = ? AND warehouse_id = ? AND transaction_type = 'import'";
        try (PreparedStatement ps = connection.prepareStatement(sqlLastImport)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Timestamp ts = rs.getTimestamp("last_import_date");
                    if (ts != null) {
                        detail.setLastImportDate(new java.util.Date(ts.getTime()));
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting last import date: " + e.getMessage());
        }

        // Get Last Export Date
        String sqlLastExport = "SELECT MAX(created_at) AS last_export_date FROM Inventory_Transaction "
                + "WHERE product_id = ? AND warehouse_id = ? AND transaction_type = 'export'";
        try (PreparedStatement ps = connection.prepareStatement(sqlLastExport)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Timestamp ts = rs.getTimestamp("last_export_date");
                    if (ts != null) {
                        detail.setLastExportDate(new java.util.Date(ts.getTime()));
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting last export date: " + e.getMessage());
        }

        // Get Last Stock Check Info
        String sqlLastCheck = "SELECT TOP 1 scr.report_date, scri.counted_quantity, scri.discrepancy, scri.reason "
                + "FROM StockCheckReport scr "
                + "JOIN StockCheckReportItem scri ON scr.report_id = scri.report_id "
                + "WHERE scri.product_id = ? AND scr.warehouse_id = ? "
                + "ORDER BY scr.report_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sqlLastCheck)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    detail.setLastCheckDate(rs.getDate("report_date"));
                    detail.setLastActualQuantity(rs.getInt("counted_quantity"));
                    detail.setLastAdjustmentQty(rs.getInt("discrepancy"));
                    detail.setAdjustmentReason(rs.getString("reason"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting last stock check info: " + e.getMessage());
        }

        // Get Min Threshold (from Reorder_Alert table)
        String sqlThreshold = "SELECT threshold FROM Reorder_Alert WHERE product_id = ? AND warehouse_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sqlThreshold)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    detail.setMinThreshold(rs.getInt("threshold"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting min threshold: " + e.getMessage());
        }

        // Calculate isBelowThreshold
        if (detail.getMinThreshold() != null) {
            detail.setBelowThreshold(detail.getQuantityOnHand() < detail.getMinThreshold());
        }

        // Get Product Created At (earliest transaction)
        String sqlProductCreated = "SELECT MIN(created_at) AS product_created_at FROM Inventory_Transaction "
                + "WHERE product_id = ? AND warehouse_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sqlProductCreated)) {
            ps.setInt(1, productId);
            ps.setInt(2, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Timestamp ts = rs.getTimestamp("product_created_at");
                    if (ts != null) {
                        detail.setProductCreatedAt(new java.util.Date(ts.getTime()));
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting product created at: " + e.getMessage());
        }

        // Assuming imageUrl is not in DB for now, or needs to be added to Product table
        // detail.setImageUrl(null); 
        return detail;
    }

    public int getTotalStockQuantity(int warehouseId) {
        String sql = "SELECT SUM(quantity) FROM Inventory WHERE warehouse_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("getTotalStockQuantity: " + e.getMessage());
        }
        return 0;
    }

    public List<Inventory> getInventoryList() {
        List<Inventory> inventoryList = new ArrayList<>();
        String sql = "SELECT i.inventory_id, i.product_id, p.name AS product_name, p.code AS product_code, "
                + "i.warehouse_id, w.warehouse_name, i.quantity, u.unit_name "
                + "FROM Inventory i "
                + "JOIN Product p ON i.product_id = p.product_id "
                + "JOIN Warehouse w ON i.warehouse_id = w.warehouse_id "
                + "LEFT JOIN Unit u ON p.unit_id = u.unit_id "
                + "ORDER BY w.warehouse_name, p.name";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Inventory item = new Inventory();
                item.setInventoryId(rs.getInt("inventory_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setProductCode(rs.getString("product_code"));
                item.setWarehouseId(rs.getInt("warehouse_id"));
                item.setWarehouseName(rs.getString("warehouse_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnit(rs.getString("unit_name"));
                // Bạn có thể set thêm các trường khác của model Inventory nếu cần
                inventoryList.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error getting inventory list: " + e.getMessage());
            e.printStackTrace();
        }
        return inventoryList;
    }
}
