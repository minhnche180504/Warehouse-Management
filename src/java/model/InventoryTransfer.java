package model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * InventoryTransfer class represents an inventory transfer between warehouses
 * This class maps to the Inventory_Transfer table in the database
 */
public class InventoryTransfer {
    private int transferId; // it_id
    private int sourceWarehouseId;
    private String sourceWarehouseName;
    private int destinationWarehouseId;
    private String destinationWarehouseName;
    private LocalDateTime date;
    private String status;
    private String description;
    private int createdBy;
    private String creatorName;
    private Integer importRequestId;
    private List<InventoryTransferItem> items;
    
    public InventoryTransfer() {
        this.items = new ArrayList<>();
    }

    public InventoryTransfer(int transferId, int sourceWarehouseId, int destinationWarehouseId, 
                           LocalDateTime date, String status, String description, int createdBy) {
        this.transferId = transferId;
        this.sourceWarehouseId = sourceWarehouseId;
        this.destinationWarehouseId = destinationWarehouseId;
        this.date = date;
        this.status = status;
        this.description = description;
        this.createdBy = createdBy;
        this.items = new ArrayList<>();
    }

    public int getTransferId() {
        return transferId;
    }

    public void setTransferId(int transferId) {
        this.transferId = transferId;
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
        return status.toLowerCase();
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

    public Integer getImportRequestId() {
        return importRequestId;
    }

    public void setImportRequestId(Integer importRequestId) {
        this.importRequestId = importRequestId;
    }

    public List<InventoryTransferItem> getItems() {
        return items;
    }

    public void setItems(List<InventoryTransferItem> items) {
        this.items = items;
    }

    public void addItem(InventoryTransferItem item) {
        if (this.items == null) {
            this.items = new ArrayList<>();
        }
        this.items.add(item);
    }

    public void removeItem(InventoryTransferItem item) {
        if (this.items != null) {
            this.items.remove(item);
        }
    }

    public void clearItems() {
        if (this.items != null) {
            this.items.clear();
        }
    }
}
