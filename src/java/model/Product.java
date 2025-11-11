package model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Product class represents a product in the warehouse management system
 * 
 * This class maps to the Product table in the database
 */
public class Product {
    private int productId;
    private String code;
    private String name;
    private String description;
    private Unit unit;
    private int unitId;
    private String unitName;
    private String unitCode;
    private BigDecimal price;
    private Integer supplierId;  
    private String supplierName; 
    private int stockQuantity;          // Thêm trường tồn kho
    private int freeToUseQuantity;      // Thêm trường free to use
    private List<ProductAttribute> attributes;

    public Product() {
        this.attributes = new ArrayList<>();
    }

    public Product(int productId, String code, String name, String description, Unit unit, BigDecimal price, Integer supplierId, String supplierName) {
        this.productId = productId;
        this.code = code;
        this.name = name;
        this.description = description;
        this.unit = unit;
        this.unitId = unit != null ? unit.getUnitId() : 0;
        this.price = price;
        this.supplierId = supplierId;
        this.supplierName = supplierName;
        this.attributes = new ArrayList<>();
    }
    
    // Constructor with unitId for when Unit object is not available
    public Product(int productId, String code, String name, String description, int unitId, String unitName, String unitCode, BigDecimal price, Integer supplierId, String supplierName) {
        this.productId = productId;
        this.code = code;
        this.name = name;
        this.description = description;
        this.unitId = unitId;
        this.unitName = unitName;
        this.unitCode = unitCode;
        this.price = price;
        this.supplierId = supplierId;
        this.supplierName = supplierName;
        this.attributes = new ArrayList<>();
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }    
    
    public Unit getUnit() {
        return unit;
    }

    public void setUnit(Unit unit) {
        this.unit = unit;
        if (unit != null) {
            this.unitId = unit.getUnitId();
            this.unitName = unit.getUnitName();
            this.unitCode = unit.getUnitCode();
        }
    }
    
    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }

    public String getUnitCode() {
        return unitCode;
    }

    public void setUnitCode(String unitCode) {
        this.unitCode = unitCode;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Integer getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Integer supplierId) {
        this.supplierId = supplierId;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }
    
    public List<ProductAttribute> getAttributes() {
        return attributes;
    }

    public void setAttributes(List<ProductAttribute> attributes) {
        this.attributes = attributes;
    }
    
    public int getStockQuantity() {
        return stockQuantity;
    }
    
    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
    
    public int getFreeToUseQuantity() {
        return freeToUseQuantity;
    }
    
    public void setFreeToUseQuantity(int freeToUseQuantity) {
        this.freeToUseQuantity = freeToUseQuantity;
    }
    
    public void addAttribute(ProductAttribute attribute) {
        if (this.attributes == null) {
            this.attributes = new ArrayList<>();
        }
        this.attributes.add(attribute);
    }
    
    public void addAttribute(String name, String value) {
        ProductAttribute attribute = new ProductAttribute(this.productId, name, value);
        addAttribute(attribute);
    }
    
    public String getAttributeValue(String attributeName) {
        if (attributes == null) {
            return null;
        }
        return attributes.stream()
                .filter(attr -> attributeName.equals(attr.getAttributeName()))
                .map(ProductAttribute::getAttributeValue)
                .findFirst()
                .orElse(null);
    }

    @Override
    public String toString() {
        return "Product{" + "productId=" + productId + ", code=" + code + ", name=" + name + 
                ", description=" + description + ", unitId=" + unitId + ", unitName=" + unitName + 
                ", unitCode=" + unitCode + ", price=" + price + ", supplierId=" + supplierId + 
                ", supplierName=" + supplierName + ", attributes=" + attributes + '}';
    }

    

    

    
    
}
