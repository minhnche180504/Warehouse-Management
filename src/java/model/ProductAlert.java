package model;

import java.sql.Timestamp;

public class ProductAlert {
    private int alertId;
    private int productId;
    private int warehouseId;
    private int warningThreshold;
    private int criticalThreshold;
    private Timestamp triggeredDate;
    private int currentStock;
    private boolean isActive;
    private int createdBy;
    private Timestamp createdAt;
    private Timestamp lastUpdated;

    // Thêm các trường mới cho ngày cảnh báo và hết hạn
    private Timestamp alertStartDate;
    private Timestamp alertExpiryDate;
    private int alertDurationDays;

    // Additional fields for display
    private String productCode;
    private String productName;
    private String warehouseName;
    private String unitName;
    // alertLevel: trạng thái cảnh báo thực tế lưu trong DB (OUT_OF_STOCK, CRITICAL, WARNING, STABLE)
    private String alertLevel;
    private boolean isExpired;
    private int daysUntilExpiry;

    // New fields for alert history action tracking
    private String status;
    private String actionType;
    private Timestamp actionTime;
    private Integer actionBy;
    private Integer relatedPrId;

    // Constructors
    public ProductAlert() {}

    public ProductAlert(int productId, int warehouseId, int warningThreshold, int criticalThreshold, int currentStock) {
        this.productId = productId;
        this.warehouseId = warehouseId;
        this.warningThreshold = warningThreshold;
        this.criticalThreshold = criticalThreshold;
        this.currentStock = currentStock;
        this.isActive = true;
        this.alertDurationDays = 30; // Mặc định 30 ngày
    }

    // Getters and Setters
    public int getAlertId() { return alertId; }
    public void setAlertId(int alertId) { this.alertId = alertId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getWarehouseId() { return warehouseId; }
    public void setWarehouseId(int warehouseId) { this.warehouseId = warehouseId; }

    public int getWarningThreshold() { return warningThreshold; }
    public void setWarningThreshold(int warningThreshold) { this.warningThreshold = warningThreshold; }

    public int getCriticalThreshold() { return criticalThreshold; }
    public void setCriticalThreshold(int criticalThreshold) { this.criticalThreshold = criticalThreshold; }

    public Timestamp getTriggeredDate() { return triggeredDate; }
    public void setTriggeredDate(Timestamp triggeredDate) { this.triggeredDate = triggeredDate; }

    public int getCurrentStock() { return currentStock; }
    public void setCurrentStock(int currentStock) { this.currentStock = currentStock; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(Timestamp lastUpdated) { this.lastUpdated = lastUpdated; }

    public Timestamp getAlertStartDate() { return alertStartDate; }
    public void setAlertStartDate(Timestamp alertStartDate) { this.alertStartDate = alertStartDate; }

    public Timestamp getAlertExpiryDate() { return alertExpiryDate; }
    public void setAlertExpiryDate(Timestamp alertExpiryDate) { this.alertExpiryDate = alertExpiryDate; }

    public int getAlertDurationDays() { return alertDurationDays; }
    public void setAlertDurationDays(int alertDurationDays) { this.alertDurationDays = alertDurationDays; }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }

    public String getUnitName() { return unitName; }
    public void setUnitName(String unitName) { this.unitName = unitName; }

    public String getAlertLevel() { return alertLevel; }
    public void setAlertLevel(String alertLevel) { this.alertLevel = alertLevel; }

    public boolean isExpired() { return isExpired; }
    public void setExpired(boolean expired) { isExpired = expired; }

    public int getDaysUntilExpiry() { return daysUntilExpiry; }
    public void setDaysUntilExpiry(int daysUntilExpiry) { this.daysUntilExpiry = daysUntilExpiry; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getActionType() { return actionType; }
    public void setActionType(String actionType) { this.actionType = actionType; }

    public Timestamp getActionTime() { return actionTime; }
    public void setActionTime(Timestamp actionTime) { this.actionTime = actionTime; }

    public Integer getActionBy() { return actionBy; }
    public void setActionBy(Integer actionBy) { this.actionBy = actionBy; }

    public Integer getRelatedPrId() { return relatedPrId; }
    public void setRelatedPrId(Integer relatedPrId) { this.relatedPrId = relatedPrId; }

    // Helper methods
    public String getCalculatedAlertLevel() {
        if (currentStock == 0) {
            return "OUT_OF_STOCK";
        } else if (currentStock <= criticalThreshold) {
            return "CRITICAL";
        } else if (currentStock <= warningThreshold) {
            return "WARNING";
        } else {
            return "STABLE";
        }
    }

    public boolean isLowStock() {
        return currentStock <= warningThreshold && currentStock > 0;
    }

    public boolean isCriticalStock() {
        return currentStock <= criticalThreshold && currentStock > 0;
    }

    public boolean isOutOfStock() {
        return currentStock == 0;
    }

    public boolean isStable() {
        return currentStock > warningThreshold;
    }

    public boolean isApproachingExpiry() {
        if (alertExpiryDate == null) return false;
        long diffInMillies = alertExpiryDate.getTime() - System.currentTimeMillis();
        int daysLeft = (int) (diffInMillies / (1000 * 60 * 60 * 24));
        return daysLeft <= 7 && daysLeft > 0; // Sắp hết hạn trong 7 ngày
    }

    public boolean isExpiredAlert() {
        if (alertExpiryDate == null) return false;
        return System.currentTimeMillis() > alertExpiryDate.getTime();
    }

    public int calculateDaysUntilExpiry() {
        if (alertExpiryDate == null) return -1;
        long diffInMillies = alertExpiryDate.getTime() - System.currentTimeMillis();
        return (int) (diffInMillies / (1000 * 60 * 60 * 24));
    }

    // Method từ file cũ để phục vụ hiển thị màu sắc cảnh báo
    public String getAlertLevelClass() {
        switch (alertLevel) {
            case "CRITICAL":
                return "badge-danger"; // Lớp CSS cho cảnh báo CRITICAL
            case "WARNING":
                return "badge-warning"; // Lớp CSS cho cảnh báo WARNING
            case "STABLE":
                return "badge-success"; // Lớp CSS cho cảnh báo STABLE
            case "OUT_OF_STOCK":
                return "badge-dark"; // Lớp CSS cho cảnh báo OUT_OF_STOCK
            default:
                return "badge-secondary"; // Mặc định nếu không có mức độ cảnh báo
        }
    }
}