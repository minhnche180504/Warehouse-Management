package model;

import java.sql.Timestamp;

/**
 * Warehouse class represents a warehouse in the system
 * Maps to the Warehouse table in the database
 */
public class Warehouse {
    private Integer warehouseId;
    private String warehouseName;
    private String address;
    private String region;
    private Integer managerId;
    private String status;
    private Timestamp createdAt;
    
    // Additional fields for display purposes
    private String managerName;

    // Default constructor
    public Warehouse() {
    }

    // Constructor with all fields
    public Warehouse(Integer warehouseId, String warehouseName, String address, 
                    String region, Integer managerId, String status, Timestamp createdAt) {
        this.warehouseId = warehouseId;
        this.warehouseName = warehouseName;
        this.address = address;
        this.region = region;
        this.managerId = managerId;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public Integer getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(Integer warehouseId) {
        this.warehouseId = warehouseId;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public Integer getManagerId() {
        return managerId;
    }

    public void setManagerId(Integer managerId) {
        this.managerId = managerId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    @Override
    public String toString() {
        return "Warehouse{" +
                "warehouseId=" + warehouseId +
                ", warehouseName='" + warehouseName + '\'' +
                ", address='" + address + '\'' +
                ", region='" + region + '\'' +
                ", managerId=" + managerId +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", managerName='" + managerName + '\'' +
                '}';
    }
}