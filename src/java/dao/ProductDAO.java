package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Product;
import model.ProductAttribute;
import model.Unit;

public class ProductDAO extends DBConnect {

    private PreparedStatement statement;
    private ResultSet resultSet;

    private void closeResources() {
        try {
            if (resultSet != null) {
                resultSet.close();
            }
            if (statement != null) {
                statement.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void saveProductAttributes(int productId, List<ProductAttribute> attributes) {
        ProductAttributeDAO attributeDAO = new ProductAttributeDAO();
        for (ProductAttribute attr : attributes) {
            attr.setProductId(productId);
            attributeDAO.createAttribute(attr);
        }
    }

    public int create(Product product) {
        String sql = "INSERT INTO Product (code, name, description, unit_id, supplier_id) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, product.getCode());
            ps.setString(2, product.getName());
            ps.setString(3, product.getDescription());

            // Set unit_id
            if (product.getUnitId() > 0) {
                ps.setInt(4, product.getUnitId());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }

            if (product.getSupplierId() != null) {
                ps.setInt(5, product.getSupplierId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }

            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                return -1;
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int productId = generatedKeys.getInt(1);
                    // If product has attributes, save them
                    if (product.getAttributes() != null && !product.getAttributes().isEmpty()) {
                        saveProductAttributes(productId, product.getAttributes());
                    }
                    return productId;
                } else {
                    return -1;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating product: " + e.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    public Product getById(int productId) {
        String sql = "SELECT p.*, s.name as supplier_name, u.unit_name, u.unit_code "
                + "FROM Product p "
                + "LEFT JOIN Supplier s ON p.supplier_id = s.supplier_id "
                + "LEFT JOIN Unit u ON p.unit_id = u.unit_id "
                + "WHERE p.product_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, productId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product product = mapResultSetToProduct(rs);

                    // Load product attributes
                    ProductAttributeDAO attributeDAO = new ProductAttributeDAO();
                    List<ProductAttribute> attributes = attributeDAO.getAttributesByProductId(productId);
                    product.setAttributes(attributes);

                    return product;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving product by ID: " + e.getMessage());
        } finally {
            closeResources();
        }

        return null;
    }

    public Map<Integer, Integer> getLatestStockQuantities() throws SQLException {
        Map<Integer, Integer> stockMap = new HashMap<>();
        String sql = "SELECT sc.product_id, sc.actual_quantity "
                + "FROM Stock_Check sc "
                + "INNER JOIN ( "
                + "    SELECT product_id, MAX([date]) AS latest_date "
                + "    FROM Stock_Check "
                + "    GROUP BY product_id "
                + ") latest ON sc.product_id = latest.product_id AND sc.[date] = latest.latest_date";

        try (
                PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                stockMap.put(rs.getInt("product_id"), rs.getInt("actual_quantity"));
            }
        }
        return stockMap;
    }

    public Product getByCode(String code) {
        String sql = "SELECT p.*, s.name as supplier_name, u.unit_name, u.unit_code "
                + "FROM Product p "
                + "LEFT JOIN Supplier s ON p.supplier_id = s.supplier_id "
                + "LEFT JOIN Unit u ON p.unit_id = u.unit_id "
                + "WHERE p.code = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, code);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving product by code: " + e.getMessage());
        } finally {
            closeResources();
        }

        return null;
    }

    public List<Product> getAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, s.name as supplier_name, u.unit_name, u.unit_code "
                + "FROM Product p "
                + "LEFT JOIN Supplier s ON p.supplier_id = s.supplier_id "
                + "LEFT JOIN Unit u ON p.unit_id = u.unit_id "
                + "ORDER BY p.product_id";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            ProductAttributeDAO attributeDAO = new ProductAttributeDAO();

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);

                // Load attributes for each product
                List<ProductAttribute> attributes = attributeDAO.getAttributesByProductId(product.getProductId());
                product.setAttributes(attributes);

                products.add(product);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving all products: " + e.getMessage());
        } finally {
            closeResources();
        }

        return products;
    }

    public List<Product> getBySupplierId(int supplierId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, s.name as supplier_name, u.unit_name, u.unit_code "
                + "FROM Product p "
                + "LEFT JOIN Supplier s ON p.supplier_id = s.supplier_id "
                + "LEFT JOIN Unit u ON p.unit_id = u.unit_id "
                + "WHERE p.supplier_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, supplierId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving products by supplier ID: " + e.getMessage());
        } finally {
            closeResources();
        }

        return products;
    }

    public List<Product> searchByName(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, s.name as supplier_name, u.unit_name, u.unit_code "
                + "FROM Product p "
                + "LEFT JOIN Supplier s ON p.supplier_id = s.supplier_id "
                + "LEFT JOIN Unit u ON p.unit_id = u.unit_id "
                + "WHERE p.name LIKE ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching products by name: " + e.getMessage());
        } finally {
            closeResources();
        }

        return products;
    }

    /**
     * Search products by attribute name and value
     *
     * @param attributeName Attribute name to search for
     * @param attributeValue Attribute value to search for
     * @return List of products that have the specified attribute with the
     * specified value
     */
    public List<Product> searchByAttribute(String attributeName, String attributeValue) {
        List<Product> products = new ArrayList<>();

        // First get product IDs that match the attribute filter
        ProductAttributeDAO attributeDAO = new ProductAttributeDAO();
        List<Integer> productIds = attributeDAO.getProductIdsByAttributeNameAndValue(attributeName, attributeValue);

        if (productIds.isEmpty()) {
            return products;
        }

        // Build query with IN clause
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT p.*, s.name as supplier_name, u.unit_name, u.unit_code ")
                .append("FROM Product p ")
                .append("LEFT JOIN Supplier s ON p.supplier_id = s.supplier_id ")
                .append("LEFT JOIN Unit u ON p.unit_id = u.unit_id ")
                .append("WHERE p.product_id IN (");

        for (int i = 0; i < productIds.size(); i++) {
            if (i > 0) {
                sqlBuilder.append(",");
            }
            sqlBuilder.append("?");
        }
        sqlBuilder.append(")");

        try (PreparedStatement ps = connection.prepareStatement(sqlBuilder.toString())) {
            // Set product IDs as parameters
            for (int i = 0; i < productIds.size(); i++) {
                ps.setInt(i + 1, productIds.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = mapResultSetToProduct(rs);

                    // Load product attributes
                    List<ProductAttribute> attributes = attributeDAO.getAttributesByProductId(product.getProductId());
                    product.setAttributes(attributes);

                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching products by attribute: " + e.getMessage());
        } finally {
            closeResources();
        }

        return products;
    }

    /**
     * Search products by multiple attribute filters
     *
     * @param attributeFilters Map of attribute name-value pairs to filter by
     * @return List of products that match ALL the attribute filters
     */
    public List<Product> searchByMultipleAttributes(Map<String, String> attributeFilters) {
        List<Product> products = new ArrayList<>();

        if (attributeFilters == null || attributeFilters.isEmpty()) {
            return products;
        }

        // First get product IDs that match all attribute filters
        ProductAttributeDAO attributeDAO = new ProductAttributeDAO();
        List<Integer> productIds = attributeDAO.getProductIdsByMultipleAttributes(attributeFilters);

        if (productIds.isEmpty()) {
            return products;
        }

        // Build query with IN clause
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT p.*, s.name as supplier_name, u.unit_name, u.unit_code ")
                .append("FROM Product p ")
                .append("LEFT JOIN Supplier s ON p.supplier_id = s.supplier_id ")
                .append("LEFT JOIN Unit u ON p.unit_id = u.unit_id ")
                .append("WHERE p.product_id IN (");

        for (int i = 0; i < productIds.size(); i++) {
            if (i > 0) {
                sqlBuilder.append(",");
            }
            sqlBuilder.append("?");
        }
        sqlBuilder.append(")");

        try (PreparedStatement ps = connection.prepareStatement(sqlBuilder.toString())) {
            // Set product IDs as parameters
            for (int i = 0; i < productIds.size(); i++) {
                ps.setInt(i + 1, productIds.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = mapResultSetToProduct(rs);

                    // Load product attributes
                    List<ProductAttribute> attributes = attributeDAO.getAttributesByProductId(product.getProductId());
                    product.setAttributes(attributes);

                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching products by multiple attributes: " + e.getMessage());
        } finally {
            closeResources();
        }

        return products;
    }

    public boolean update(Product product) {
        String sql = "UPDATE Product SET code = ?, name = ?, description = ?, "
                + "unit_id = ?, price = ?, supplier_id = ? "
                + "WHERE product_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, product.getCode());
            ps.setString(2, product.getName());
            ps.setString(3, product.getDescription());

            if (product.getUnitId() > 0) {
                ps.setInt(4, product.getUnitId());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }

            if (product.getPrice() != null) {
                ps.setBigDecimal(5, product.getPrice());
            } else {
                ps.setNull(5, java.sql.Types.DECIMAL);
            }

            if (product.getSupplierId() != null) {
                ps.setInt(6, product.getSupplierId());
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }

            ps.setInt(7, product.getProductId());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0 && product.getAttributes() != null) {
                // Update product attributes
                updateProductAttributes(product.getProductId(), product.getAttributes());
            }

            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    private void updateProductAttributes(int productId, List<ProductAttribute> attributes) {
        // First delete all existing attributes for this product
        ProductAttributeDAO attributeDAO = new ProductAttributeDAO();
        attributeDAO.deleteAttributesByProductId(productId);

        // Then create new attributes
        for (ProductAttribute attr : attributes) {
            attr.setProductId(productId);
            attributeDAO.createAttribute(attr);
        }
    }

    public boolean delete(int productId) {
        String sql = "DELETE FROM Product WHERE product_id=?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, productId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting product: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean isCodeExists(String code, Integer productId) {
        String sql = "SELECT COUNT(*) FROM Product WHERE code = ?";

        if (productId != null) {
            sql += " AND product_id <> ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, code);

            if (productId != null) {
                ps.setInt(2, productId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking if code exists: " + e.getMessage());
        } finally {
            closeResources();
        }

        return false;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setCode(rs.getString("code"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));

        // Handle Unit relationship
        int unitId = rs.getInt("unit_id");
        if (!rs.wasNull()) {
            // Set the unit ID first
            product.setUnitId(unitId);

            // If we're joining with the Unit table, get unit name and code
            try {
                String unitName = rs.getString("unit_name");
                String unitCode = rs.getString("unit_code");
                if (unitName != null && unitCode != null) {
                    // Create and set Unit object for complete sync
                    Unit unit = new Unit();
                    unit.setUnitId(unitId);
                    unit.setUnitName(unitName);
                    unit.setUnitCode(unitCode);
                    product.setUnit(unit);

                    // These will already be set by setUnit() but being explicit
                    // for clarity
                    product.setUnitName(unitName);
                    product.setUnitCode(unitCode);
                }
            } catch (SQLException e) {
                // Column doesn't exist in result set, which is okay
            }
        }

        BigDecimal price = rs.getBigDecimal("price");
        if (price != null) {
            product.setPrice(price);
        } else {
            product.setPrice(null);
        }

        int supplierId = rs.getInt("supplier_id");
        if (!rs.wasNull()) {
            product.setSupplierId(supplierId);
        }

        try {
            String supplierName = rs.getString("supplier_name");
            product.setSupplierName(supplierName);
        } catch (SQLException e) {
            // Bỏ qua nếu không có cột từ bảng Supplier
        }

        return product;
    }

    public int getTotalProducts(int warehouseId) {
        String sql = "SELECT COUNT(DISTINCT i.product_id) FROM Inventory i WHERE i.warehouse_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("getTotalProducts: " + e.getMessage());
        }
        return 0;
    }

    public List<Product> getRecentProducts(int warehouseId, int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " p.* " +
                 "FROM Inventory i " +
                 "JOIN Product p ON i.product_id = p.product_id " +
                 "WHERE i.warehouse_id = ? " +
                 "ORDER BY p.product_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                ProductAttributeDAO attributeDAO = new ProductAttributeDAO();
                while (rs.next()) {
                    Product product = mapResultSetToProduct(rs);
                    List<ProductAttribute> attributes = attributeDAO.getAttributesByProductId(product.getProductId());
                    product.setAttributes(attributes);
                    list.add(product);
                }
            }
        } catch (SQLException e) {
            System.out.println("getRecentProducts: " + e.getMessage());
        }
        return list;
    }

    // Hàm main để test tất cả các phương thức của ProductDAO
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();

        if (dao.connection != null) {
            System.out.println("Database connection successful");

            try {
                // Test getAll
                System.out.println("\n1. Test getAll():");
                List<Product> allProducts = dao.getAll();
                System.out.println("Tổng số sản phẩm: " + allProducts.size());
                if (!allProducts.isEmpty()) {
                    System.out.println("Sản phẩm đầu tiên: " + allProducts.get(0).getName());

                    // Test getById
                    System.out.println("\n2. Test getById():");
                    int firstId = allProducts.get(0).getProductId();
                    Product product = dao.getById(firstId);
                    System.out.println("Tìm sản phẩm ID=" + firstId + ": "
                            + (product != null ? product.getName() : "Không tìm thấy"));

                    // Test getByCode
                    System.out.println("\n3. Test getByCode():");
                    if (allProducts.get(0).getCode() != null) {
                        String code = allProducts.get(0).getCode();
                        product = dao.getByCode(code);
                        System.out.println("Tìm sản phẩm code=" + code + ": "
                                + (product != null ? product.getName() : "Không tìm thấy"));
                    }
                }

                // Test getBySupplierId
                System.out.println("\n4. Test getBySupplierId():");
                int testSupplierId = 2; // Giả sử supplier_id=2 tồn tại trong db
                List<Product> supplierProducts = dao.getBySupplierId(testSupplierId);
                System.out.println("Số sản phẩm của supplier ID=" + testSupplierId + ": " + supplierProducts.size());

                // Test searchByName
                System.out.println("\n5. Test searchByName():");
                String searchKeyword = "Dell"; // Từ khóa tìm kiếm
                List<Product> searchResults = dao.searchByName(searchKeyword);
                System.out.println("Kết quả tìm kiếm với từ khóa '" + searchKeyword + "': " + searchResults.size());
                for (Product p : searchResults) {
                    System.out.println("  - " + p.getName());
                }

                // Test create
                System.out.println("\n6. Test create():");
                Product newProduct = new Product();
                String uniqueCode = "TEST-" + System.currentTimeMillis();
                newProduct.setCode(uniqueCode);
                newProduct.setName("Sản phẩm Test");
                newProduct.setDescription("Mô tả sản phẩm test");
                newProduct.setUnitId(1); // Assuming unit_id=1 exists (pcs)
                newProduct.setPrice(new BigDecimal("100000"));
                newProduct.setSupplierId(1);

                int newId = dao.create(newProduct);
                System.out.println("Tạo sản phẩm mới, ID: " + newId);

                // Test isCodeExists - kiểm tra mã vừa tạo có tồn tại không
                System.out.println("\n7. Test isCodeExists():");
                boolean exists = dao.isCodeExists(uniqueCode, null);
                System.out.println("Mã " + uniqueCode + " tồn tại: " + exists);

                // Test update nếu tạo thành công
                if (newId > 0) {
                    System.out.println("\n8. Test update():");
                    Product updatedProduct = dao.getById(newId);
                    if (updatedProduct != null) {
                        updatedProduct.setName("Sản phẩm Test (Đã cập nhật)");
                        updatedProduct.setPrice(new BigDecimal("150000"));
                        boolean updateResult = dao.update(updatedProduct);
                        System.out.println("Cập nhật sản phẩm ID=" + newId + ": "
                                + (updateResult ? "Thành công" : "Thất bại"));

                        // Kiểm tra lại sau khi update
                        Product afterUpdate = dao.getById(newId);
                        if (afterUpdate != null) {
                            System.out.println("Tên sau khi update: " + afterUpdate.getName());
                            System.out.println("Giá sau khi update: " + afterUpdate.getPrice());
                        }
                    }
                }

                // Test delete nếu tạo thành công
                if (newId > 0) {
                    System.out.println("\n9. Test delete():");
                    boolean deleteResult = dao.delete(newId);
                    System.out.println("Xóa sản phẩm ID=" + newId + ": "
                            + (deleteResult ? "Thành công" : "Thất bại"));

                    // Kiểm tra lại sau khi xóa
                    Product afterDelete = dao.getById(newId);
                    System.out.println("Sản phẩm sau khi xóa: "
                            + (afterDelete == null ? "Đã xóa thành công" : "Vẫn còn tồn tại"));
                }
            } catch (Exception e) {
                System.err.println("Error during test: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.out.println("Failed to establish database connection");
        }
    }

    public Product getProductById(int productId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
