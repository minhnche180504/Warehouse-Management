package model;

/**
 * RfqItem class represents an item in a request for quotation
 * Maps to the RFQ_Item table in the database
 */
public class RfqItem {
    private Integer rfqItemId;
    private Integer rfqId;
    private Integer productId;
    private Integer quantity;
    
    // Additional fields for display purposes
    private String productCode;
    private String productName;
    private String unitName;
    private String unitCode;

    // Default constructor
    public RfqItem() {
    }

    // Constructor with all basic fields
    public RfqItem(Integer rfqItemId, Integer rfqId, Integer productId, Integer quantity) {
        this.rfqItemId = rfqItemId;
        this.rfqId = rfqId;
        this.productId = productId;
        this.quantity = quantity;
    }

    // Constructor without ID (for creation)
    public RfqItem(Integer rfqId, Integer productId, Integer quantity) {
        this.rfqId = rfqId;
        this.productId = productId;
        this.quantity = quantity;
    }

    // Getters and Setters
    public Integer getRfqItemId() {
        return rfqItemId;
    }

    public void setRfqItemId(Integer rfqItemId) {
        this.rfqItemId = rfqItemId;
    }

    public Integer getRfqId() {
        return rfqId;
    }

    public void setRfqId(Integer rfqId) {
        this.rfqId = rfqId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
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

    @Override
    public String toString() {
        return "RfqItem{" +
                "rfqItemId=" + rfqItemId +
                ", rfqId=" + rfqId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                ", productCode='" + productCode + '\'' +
                ", productName='" + productName + '\'' +
                '}';
    }
} 