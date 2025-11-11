package model;

import java.math.BigDecimal;

/**
 * TransferOrderItem class represents an item in a transfer order
 * This class maps to the Transfer_Order_Item table in the database
 */
public class TransferOrderItem {
    private int toItemId;
    private int toId; // Transfer order ID
    private int productId;
    private String productName;
    private String productCode;
    private int quantity;
    private BigDecimal unitPrice;
    private Unit unit;
    
    public TransferOrderItem() {
    }

    public TransferOrderItem(int toItemId, int toId, int productId, int quantity) {
        this.toItemId = toItemId;
        this.toId = toId;
        this.productId = productId;
        this.quantity = quantity;
    }

    public TransferOrderItem(int toItemId, int toId, int productId, int quantity, BigDecimal unitPrice) {
        this.toItemId = toItemId;
        this.toId = toId;
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public int getToItemId() {
        return toItemId;
    }

    public void setToItemId(int toItemId) {
        this.toItemId = toItemId;
    }

    public int getToId() {
        return toId;
    }

    public void setToId(int toId) {
        this.toId = toId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getTotalPrice() {
        if (unitPrice != null) {
            return unitPrice.multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }

    public Unit getUnit() {
        return unit;
    }

    public void setUnit(Unit unit) {
        this.unit = unit;
    }
}
