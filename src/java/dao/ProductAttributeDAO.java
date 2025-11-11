package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.ProductAttribute;

public class ProductAttributeDAO extends DBConnect {
    
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
            System.out.println("Error closing resources: " + e.getMessage());
        }
    }
      public List<ProductAttribute> getAttributesByProductId(int productId) {
        List<ProductAttribute> attributes = new ArrayList<>();
        String query = "SELECT * FROM ProductAttribute WHERE product_id = ?";
        
        try {
            statement = connection.prepareStatement(query);
            statement.setInt(1, productId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                ProductAttribute attribute = mapResultSetToAttribute(resultSet);
                attributes.add(attribute);
            }
        } catch (SQLException e) {
            System.out.println("Error getting attributes for product: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return attributes;
    }
      public ProductAttribute getAttributeById(int attributeId) {
        String query = "SELECT * FROM ProductAttribute WHERE attribute_id = ?";
        
        try {
            statement = connection.prepareStatement(query);
            statement.setInt(1, attributeId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return mapResultSetToAttribute(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error getting attribute by ID: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return null;
    }
      public int createAttribute(ProductAttribute attribute) {
        String query = "INSERT INTO ProductAttribute (product_id, attribute_name, attribute_value) "
                + "VALUES (?, ?, ?)";
        
        try {
            statement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            
            statement.setInt(1, attribute.getProductId());
            statement.setString(2, attribute.getAttributeName());
            statement.setString(3, attribute.getAttributeValue());
            
            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating attribute failed, no rows affected.");
            }
            
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating attribute failed, no ID obtained.");
            }
        } catch (SQLException e) {
            System.out.println("Error creating attribute: " + e.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }
      public boolean updateAttribute(ProductAttribute attribute) {
        String query = "UPDATE ProductAttribute SET attribute_name = ?, attribute_value = ?, "
                + "last_updated = ? WHERE attribute_id = ?";
        
        try {
            statement = connection.prepareStatement(query);
            
            statement.setString(1, attribute.getAttributeName());
            statement.setString(2, attribute.getAttributeValue());
            statement.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(4, attribute.getAttributeId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating attribute: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
      public boolean deleteAttribute(int attributeId) {
        String query = "DELETE FROM ProductAttribute WHERE attribute_id = ?";
        
        try {
            statement = connection.prepareStatement(query);
            statement.setInt(1, attributeId);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting attribute: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
      public boolean deleteAttributesByProductId(int productId) {
        String query = "DELETE FROM ProductAttribute WHERE product_id = ?";
        
        try {
            statement = connection.prepareStatement(query);
            statement.setInt(1, productId);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting attributes for product: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
      public List<ProductAttribute> getAttributesByNameAndValue(String name, String value) {
        List<ProductAttribute> attributes = new ArrayList<>();
        String query = "SELECT * FROM ProductAttribute WHERE attribute_name = ? AND attribute_value = ?";
        
        try {
            statement = connection.prepareStatement(query);
            statement.setString(1, name);
            statement.setString(2, value);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                ProductAttribute attribute = mapResultSetToAttribute(resultSet);
                attributes.add(attribute);
            }
        } catch (SQLException e) {
            System.out.println("Error getting attributes by name and value: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return attributes;
    }
      private ProductAttribute mapResultSetToAttribute(ResultSet rs) throws SQLException {
        ProductAttribute attribute = new ProductAttribute();
        attribute.setAttributeId(rs.getInt("attribute_id"));
        attribute.setProductId(rs.getInt("product_id"));
        attribute.setAttributeName(rs.getString("attribute_name"));
        attribute.setAttributeValue(rs.getString("attribute_value"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            attribute.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp lastUpdated = rs.getTimestamp("last_updated");
        if (lastUpdated != null) {
            attribute.setLastUpdated(lastUpdated.toLocalDateTime());
        }
        
        return attribute;
    }
    
    /**
     * Get product IDs that have a specific attribute name and value
     * @param attributeName The name of the attribute
     * @param attributeValue The value of the attribute
     * @return A list of product IDs
     */
    public List<Integer> getProductIdsByAttributeNameAndValue(String attributeName, String attributeValue) {
        List<Integer> productIds = new ArrayList<>();
        String query = "SELECT DISTINCT product_id FROM ProductAttribute WHERE attribute_name = ? AND attribute_value LIKE ?";
        
        try {
            statement = connection.prepareStatement(query);
            statement.setString(1, attributeName);
            statement.setString(2, "%" + attributeValue + "%");
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                productIds.add(resultSet.getInt("product_id"));
            }
        } catch (SQLException e) {
            System.out.println("Error getting products by attribute: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return productIds;
    }
    
    /**
     * Get product IDs that match multiple attribute filters
     * @param attributeFilters Map of attribute name-value pairs to filter by
     * @return A list of product IDs that match ALL the filters
     */
    public List<Integer> getProductIdsByMultipleAttributes(Map<String, String> attributeFilters) {
        if (attributeFilters == null || attributeFilters.isEmpty()) {
            return new ArrayList<>();
        }
        
        // Start with a base query to get all products with the first attribute
        StringBuilder queryBuilder = new StringBuilder();
        queryBuilder.append("SELECT product_id FROM ProductAttribute WHERE ");
        
        // Add conditions for each attribute
        int paramIndex = 0;
        for (Map.Entry<String, String> entry : attributeFilters.entrySet()) {
            if (paramIndex > 0) {
                queryBuilder.append(" AND product_id IN (SELECT product_id FROM ProductAttribute WHERE ");
            }
            
            queryBuilder.append("attribute_name = ? AND attribute_value LIKE ?");
            
            if (paramIndex > 0) {
                queryBuilder.append(")");
            }
            
            paramIndex += 2;
        }
        
        List<Integer> productIds = new ArrayList<>();
        try {
            statement = connection.prepareStatement(queryBuilder.toString());
            
            // Set parameters for each attribute
            int index = 1;
            for (Map.Entry<String, String> entry : attributeFilters.entrySet()) {
                statement.setString(index++, entry.getKey());
                statement.setString(index++, "%" + entry.getValue() + "%");
            }
            
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                productIds.add(resultSet.getInt("product_id"));
            }
        } catch (SQLException e) {
            System.out.println("Error getting products by multiple attributes: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return productIds;
    }
}
