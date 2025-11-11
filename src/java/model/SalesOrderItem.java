package model;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class SalesOrderItem {
    private int soItemId;
    private int soId;
    private int productId;
    private int quantity;
    private BigDecimal unitPrice; // Giá gốc từ kho
    private BigDecimal sellingPrice; // Giá bán thực tế
    private BigDecimal totalPrice;
    
    // Product information
    private String productCode;
    private String productName;

    // Constructors
    public SalesOrderItem() {}

    public SalesOrderItem(int soId, int productId, int quantity, BigDecimal unitPrice) {
        this.soId = soId;
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.sellingPrice = unitPrice; // Mặc định bằng giá gốc
        calculateTotalPrice();
    }

    public SalesOrderItem(int soId, int productId, int quantity, BigDecimal unitPrice, BigDecimal sellingPrice) {
        this.soId = soId;
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.sellingPrice = sellingPrice;
        calculateTotalPrice();
    }

    // Getters and Setters
    public int getSoItemId() { return soItemId; }
    public void setSoItemId(int soItemId) { this.soItemId = soItemId; }

    public int getSoId() { return soId; }
    public void setSoId(int soId) { this.soId = soId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { 
        this.quantity = quantity;
        calculateTotalPrice();
    }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { 
        this.unitPrice = unitPrice;
        // Nếu chưa có selling price, set bằng unit price
        if (this.sellingPrice == null) {
            this.sellingPrice = unitPrice;
        }
        calculateTotalPrice();
    }

    public BigDecimal getSellingPrice() { 
        return sellingPrice != null ? sellingPrice : unitPrice; 
    }
    
    public void setSellingPrice(BigDecimal sellingPrice) { 
        this.sellingPrice = sellingPrice;
        calculateTotalPrice();
    }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    // Business logic methods
    public void calculateTotalPrice() {
        BigDecimal price = sellingPrice != null ? sellingPrice : unitPrice;
        if (price != null && quantity > 0) {
            this.totalPrice = price.multiply(BigDecimal.valueOf(quantity));
        } else {
            this.totalPrice = BigDecimal.ZERO;
        }
    }

    /**
     * Tính lãi cho 1 sản phẩm (selling_price - unit_price)
     */
    public BigDecimal getProfitPerUnit() {
        BigDecimal selling = getSellingPrice();
        if (selling != null && unitPrice != null) {
            return selling.subtract(unitPrice);
        }
        return BigDecimal.ZERO;
    }

    /**
     * Tính tổng lãi cho item này
     */
    public BigDecimal getTotalProfit() {
        return getProfitPerUnit().multiply(BigDecimal.valueOf(quantity));
    }

    /**
     * Tính % lãi (profit / unit_price * 100)
     */
    public BigDecimal getProfitPercentage() {
        if (unitPrice != null && unitPrice.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal profit = getProfitPerUnit();
            return profit.divide(unitPrice, 4, RoundingMode.HALF_UP)
                         .multiply(BigDecimal.valueOf(100));
        }
        return BigDecimal.ZERO;
    }

    /**
     * Thiết lập selling price dựa trên % lãi
     */
    public void setSellingPriceByProfitPercentage(BigDecimal profitPercentage) {
        if (unitPrice != null && profitPercentage != null) {
            BigDecimal multiplier = BigDecimal.ONE.add(
                profitPercentage.divide(BigDecimal.valueOf(100), 4, RoundingMode.HALF_UP)
            );
            this.sellingPrice = unitPrice.multiply(multiplier);
            calculateTotalPrice();
        }
    }

    /**
     * Format giá tiền cho hiển thị
     */
    public String getFormattedUnitPrice() {
        if (unitPrice == null) return "0";
        return String.format("%,.0f", unitPrice);
    }

    public String getFormattedSellingPrice() {
        BigDecimal selling = getSellingPrice();
        if (selling == null) return "0";
        return String.format("%,.0f", selling);
    }

    public String getFormattedTotalPrice() {
        if (totalPrice == null) return "0";
        return String.format("%,.0f", totalPrice);
    }

    public String getFormattedProfitPerUnit() {
        return String.format("%,.0f", getProfitPerUnit());
    }

    public String getFormattedTotalProfit() {
        return String.format("%,.0f", getTotalProfit());
    }

    public String getFormattedProfitPercentage() {
        return String.format("%.1f%%", getProfitPercentage());
    }

    @Override
    public String toString() {
        return "SalesOrderItem{" +
                "soItemId=" + soItemId +
                ", productCode='" + productCode + '\'' +
                ", productName='" + productName + '\'' +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", sellingPrice=" + getSellingPrice() +
                ", totalPrice=" + totalPrice +
                ", profitPercentage=" + getFormattedProfitPercentage() +
                '}';
    }
}