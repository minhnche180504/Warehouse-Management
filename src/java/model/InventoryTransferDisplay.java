package model;

import java.time.LocalDateTime;

/**
 * InventoryTransferDisplay class for displaying inventory transfer information in lists and tables
 * This is a lightweight version of InventoryTransfer with additional display fields
 */
public class InventoryTransferDisplay {
    private int transferId;
    private String transferCode; // Generated display code like "IT-001"
    private int sourceWarehouseId;
    private String sourceWarehouseName;
    private int destinationWarehouseId;
    private String destinationWarehouseName;
    private LocalDateTime date;
    private String status;
    private String description;
    private int createdBy;
    private String creatorName;
    private int totalItems;
    private int totalQuantity;
    
    public InventoryTransferDisplay() {
    }

    public InventoryTransferDisplay(int transferId, int sourceWarehouseId, String sourceWarehouseName,
                                  int destinationWarehouseId, String destinationWarehouseName,
                                  LocalDateTime date, String status, String description,
                                  int createdBy, String creatorName) {
        this.transferId = transferId;
        this.sourceWarehouseId = sourceWarehouseId;
        this.sourceWarehouseName = sourceWarehouseName;
        this.destinationWarehouseId = destinationWarehouseId;
        this.destinationWarehouseName = destinationWarehouseName;
        this.date = date;
        this.status = status;
        this.description = description;
        this.createdBy = createdBy;
        this.creatorName = creatorName;
        this.transferCode = "IT-" + String.format("%03d", transferId);
    }

    public int getTransferId() {
        return transferId;
    }

    public void setTransferId(int transferId) {
        this.transferId = transferId;
        this.transferCode = "IT-" + String.format("%03d", transferId);
    }

    public String getTransferCode() {
        return transferCode;
    }

    public void setTransferCode(String transferCode) {
        this.transferCode = transferCode;
    }

    public int getSourceWarehouseId() {
        return sourceWarehouseId;
    }

    public void setSourceWarehouseId(int sourceWarehouseId) {
        this.sourceWarehouseId = sourceWarehouseId;
    }

    public String getSourceWarehouseName() {
        return sourceWarehouseName;
    }

    public void setSourceWarehouseName(String sourceWarehouseName) {
        this.sourceWarehouseName = sourceWarehouseName;
    }

    public int getDestinationWarehouseId() {
        return destinationWarehouseId;
    }

    public void setDestinationWarehouseId(int destinationWarehouseId) {
        this.destinationWarehouseId = destinationWarehouseId;
    }

    public String getDestinationWarehouseName() {
        return destinationWarehouseName;
    }

    public void setDestinationWarehouseName(String destinationWarehouseName) {
        this.destinationWarehouseName = destinationWarehouseName;
    }

    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public String getCreatorName() {
        return creatorName;
    }

    public void setCreatorName(String creatorName) {
        this.creatorName = creatorName;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    @Override
    public String toString() {
        return "InventoryTransferDisplay{" +
                "transferId=" + transferId +
                ", transferCode='" + transferCode + '\'' +
                ", sourceWarehouseName='" + sourceWarehouseName + '\'' +
                ", destinationWarehouseName='" + destinationWarehouseName + '\'' +
                ", date=" + date +
                ", status='" + status + '\'' +
                ", creatorName='" + creatorName + '\'' +
                ", totalItems=" + totalItems +
                ", totalQuantity=" + totalQuantity +
                '}';
    }
}
