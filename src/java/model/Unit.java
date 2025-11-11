package model;

import java.time.LocalDateTime;

/**
 * Unit class represents a unit of measurement for products
 * 
 * This class maps to the Unit table in the database
 */
public class Unit {
    private int unitId;
    private String unitName;
    private String unitCode;
    private String description;
    private boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime lastUpdated;
    
    public Unit() {
    }
    
    public Unit(int unitId, String unitName, String unitCode, String description, boolean isActive, 
            LocalDateTime createdAt, LocalDateTime lastUpdated) {
        this.unitId = unitId;
        this.unitName = unitName;
        this.unitCode = unitCode;
        this.description = description;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.lastUpdated = lastUpdated;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
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
        return "Unit{" + "unitId=" + unitId + ", unitName=" + unitName + 
                ", unitCode=" + unitCode + ", description=" + description + 
                ", isActive=" + isActive + ", createdAt=" + createdAt + 
                ", lastUpdated=" + lastUpdated + '}';
    }
}
