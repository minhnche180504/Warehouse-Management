package model;

import java.math.BigDecimal;

public class Inventory {
    private int inventoryId;
    private int productId;
    private int warehouseId;
    private int quantity;
    private int reorderLevel;
    private java.util.Date lastUpdated;
    
    // Product information for display
    private String productCode;
    private String productName;
    private String productDescription;
    private BigDecimal price;
    private String unit;
    
    // Warehouse information
    private String warehouseName;

    // Constructors
    public Inventory() {}

    public Inventory(int productId, int warehouseId, int quantity) {
        this.productId = productId;
        this.warehouseId = warehouseId;
        this.quantity = quantity;
    }

    // Getters and Setters
    public int getInventoryId() { return inventoryId; }
    public void setInventoryId(int inventoryId) { this.inventoryId = inventoryId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getWarehouseId() { return warehouseId; }
    public void setWarehouseId(int warehouseId) { this.warehouseId = warehouseId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getReorderLevel() { return reorderLevel; }
    public void setReorderLevel(int reorderLevel) { this.reorderLevel = reorderLevel; }

    public java.util.Date getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(java.util.Date lastUpdated) { this.lastUpdated = lastUpdated; }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductDescription() { return productDescription; }
    public void setProductDescription(String productDescription) { this.productDescription = productDescription; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
    
    // Utility methods
    public boolean isLowStock() {
        return quantity <= reorderLevel;
    }
    
    public boolean hasStock() {
        return quantity > 0;
    }
}