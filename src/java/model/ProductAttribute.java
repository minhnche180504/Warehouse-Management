package model;

import java.time.LocalDateTime;

/**
 * Represents a product attribute in the warehouse management system
 * Maps to the ProductAttribute table in the database
 */
public class ProductAttribute {
    private int attributeId;
    private int productId;
    private String attributeName;
    private String attributeValue;
    private LocalDateTime createdAt;
    private LocalDateTime lastUpdated;
    
    // Default constructor
    public ProductAttribute() {
    }
    
    // Constructor with all fields
    public ProductAttribute(int attributeId, int productId, String attributeName, 
            String attributeValue, LocalDateTime createdAt, LocalDateTime lastUpdated) {
        this.attributeId = attributeId;
        this.productId = productId;
        this.attributeName = attributeName;
        this.attributeValue = attributeValue;
        this.createdAt = createdAt;
        this.lastUpdated = lastUpdated;
    }
    
    // Constructor with essential fields (without ID and timestamps)
    public ProductAttribute(int productId, String attributeName, String attributeValue) {
        this.productId = productId;
        this.attributeName = attributeName;
        this.attributeValue = attributeValue;
    }

    public int getAttributeId() {
        return attributeId;
    }

    public void setAttributeId(int attributeId) {
        this.attributeId = attributeId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getAttributeName() {
        return attributeName;
    }

    public void setAttributeName(String attributeName) {
        this.attributeName = attributeName;
    }

    public String getAttributeValue() {
        return attributeValue;
    }

    public void setAttributeValue(String attributeValue) {
        this.attributeValue = attributeValue;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    @Override
    public String toString() {
        return "ProductAttribute{" + "attributeId=" + attributeId + 
               ", productId=" + productId + 
               ", attributeName=" + attributeName + 
               ", attributeValue=" + attributeValue + 
               ", createdAt=" + createdAt + 
               ", lastUpdated=" + lastUpdated + '}';
    }
}
