package model;

import java.sql.Date;
import java.sql.Timestamp;

public class DiscountCode {
    private int discountId;
    private String code;
    private String name;
    private String description;
    private String discountType; // "PERCENTAGE" or "FIXED_AMOUNT"
    private double discountValue;
    private double minOrderAmount;
    private Double maxDiscountAmount;
    private Timestamp startDate;
    private Timestamp endDate;
    private Integer usageLimit;
    private int usedCount;
    private boolean isActive;
    private int createdBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Constructor
    public DiscountCode() {}
    
    public DiscountCode(String code, String name, String discountType, double discountValue, 
                       double minOrderAmount, Timestamp startDate, Timestamp endDate, int createdBy) {
        this.code = code;
        this.name = name;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minOrderAmount = minOrderAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.createdBy = createdBy;
        this.isActive = true;
        this.usedCount = 0;
    }
    
    // Utility methods
    public boolean isValid() {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return isActive && 
               startDate.before(now) && 
               endDate.after(now) &&
               (usageLimit == null || usedCount < usageLimit);
    }
    
    public double calculateDiscountAmount(double orderAmount) {
        if (orderAmount < minOrderAmount) {
            return 0;
        }
        
        double discountAmount = 0;
        if ("PERCENTAGE".equals(discountType)) {
            discountAmount = orderAmount * discountValue / 100;
            if (maxDiscountAmount != null && discountAmount > maxDiscountAmount) {
                discountAmount = maxDiscountAmount;
            }
        } else if ("FIXED_AMOUNT".equals(discountType)) {
            discountAmount = discountValue;
        }
        
        return Math.min(discountAmount, orderAmount);
    }
    
    // Getters and Setters
    public int getDiscountId() { return discountId; }
    public void setDiscountId(int discountId) { this.discountId = discountId; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }
    
    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }
    
    public double getMinOrderAmount() { return minOrderAmount; }
    public void setMinOrderAmount(double minOrderAmount) { this.minOrderAmount = minOrderAmount; }
    
    public Double getMaxDiscountAmount() { return maxDiscountAmount; }
    public void setMaxDiscountAmount(Double maxDiscountAmount) { this.maxDiscountAmount = maxDiscountAmount; }
    
    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }
    
    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }
    
    public Integer getUsageLimit() { return usageLimit; }
    public void setUsageLimit(Integer usageLimit) { this.usageLimit = usageLimit; }
    
    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    @Override
    public String toString() {
        return "DiscountCode{" +
                "discountId=" + discountId +
                ", code='" + code + '\'' +
                ", name='" + name + '\'' +
                ", discountType='" + discountType + '\'' +
                ", discountValue=" + discountValue +
                ", isActive=" + isActive +
                '}';
    }
}