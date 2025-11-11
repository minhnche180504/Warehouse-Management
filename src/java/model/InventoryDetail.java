package model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class InventoryDetail {
    private int productId;
    private String productCode;
    private String productName;
    private String productDescription;
    private String unit;
    private BigDecimal price;
    private String supplierName;
    private String warehouseName;
    private String region;
    private int quantityOnHand;
    private Date lastImportDate;
    private Date lastExportDate;
    private Date lastCheckDate;
    private Integer lastActualQuantity;
    private Integer lastAdjustmentQty;
    private String adjustmentReason;
    private Integer minThreshold;
    private boolean isBelowThreshold;
    private List<ProductAttribute> productAttributes;
    private Date productCreatedAt; // Date product was first added/transacted
    private String imageUrl; // Optional: if you have image URLs for products

    // Getters and Setters

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductDescription() {
        return productDescription;
    }

    public void setProductDescription(String productDescription) {
        this.productDescription = productDescription;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public int getQuantityOnHand() {
        return quantityOnHand;
    }

    public void setQuantityOnHand(int quantityOnHand) {
        this.quantityOnHand = quantityOnHand;
    }

    public Date getLastImportDate() {
        return lastImportDate;
    }

    public void setLastImportDate(Date lastImportDate) {
        this.lastImportDate = lastImportDate;
    }

    public Date getLastExportDate() {
        return lastExportDate;
    }

    public void setLastExportDate(Date lastExportDate) {
        this.lastExportDate = lastExportDate;
    }

    public Date getLastCheckDate() {
        return lastCheckDate;
    }

    public void setLastCheckDate(Date lastCheckDate) {
        this.lastCheckDate = lastCheckDate;
    }

    public Integer getLastActualQuantity() {
        return lastActualQuantity;
    }

    public void setLastActualQuantity(Integer lastActualQuantity) {
        this.lastActualQuantity = lastActualQuantity;
    }

    public Integer getLastAdjustmentQty() {
        return lastAdjustmentQty;
    }

    public void setLastAdjustmentQty(Integer lastAdjustmentQty) {
        this.lastAdjustmentQty = lastAdjustmentQty;
    }

    public String getAdjustmentReason() {
        return adjustmentReason;
    }

    public void setAdjustmentReason(String adjustmentReason) {
        this.adjustmentReason = adjustmentReason;
    }

    public Integer getMinThreshold() {
        return minThreshold;
    }

    public void setMinThreshold(Integer minThreshold) {
        this.minThreshold = minThreshold;
    }

    public boolean isBelowThreshold() {
        return isBelowThreshold;
    }

    public void setBelowThreshold(boolean belowThreshold) {
        isBelowThreshold = belowThreshold;
    }

    public List<ProductAttribute> getProductAttributes() {
        return productAttributes;
    }

    public void setProductAttributes(List<ProductAttribute> productAttributes) {
        this.productAttributes = productAttributes;
    }

    public Date getProductCreatedAt() {
        return productCreatedAt;
    }

    public void setProductCreatedAt(Date productCreatedAt) {
        this.productCreatedAt = productCreatedAt;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
