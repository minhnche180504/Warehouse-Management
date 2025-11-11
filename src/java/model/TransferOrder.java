package model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * TransferOrder class represents a transfer order in the warehouse management system
 * This class maps to the Transfer_Order table in the database
 */
public class TransferOrder {
    private int transferId;
    private int sourceWarehouseId;
    private String sourceWarehouseName;
    private Integer destinationWarehouseId;
    private String destinationWarehouseName;
    private Integer documentRefId;
    private String documentRefType;
    private String transferType;
    private String status;
    private String description;
    private Integer approvedBy;
    private String approverName;
    private int createdBy;
    private String creatorName;
    private List<TransferOrderItem> items;
    private LocalDateTime transferDate;
    private LocalDateTime createdDate;    public TransferOrder() {
        this.items = new ArrayList<>();
    }

    public TransferOrder(int transferId, int sourceWarehouseId, Integer destinationWarehouseId, Integer documentRefId,
                         String documentRefType, String transferType, String status, String description, Integer approvedBy, int createdBy,
                         LocalDateTime transferDate, LocalDateTime createdDate) {
        this.transferId = transferId;
        this.sourceWarehouseId = sourceWarehouseId;
        this.destinationWarehouseId = destinationWarehouseId;
        this.documentRefId = documentRefId;
        this.documentRefType = documentRefType;
        this.transferType = transferType;
        this.status = status;
        this.description = description;
        this.approvedBy = approvedBy;
        this.createdBy = createdBy;
        this.transferDate = transferDate;
        this.createdDate = createdDate;
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

    public Integer getDestinationWarehouseId() {
        return destinationWarehouseId;
    }

    public void setDestinationWarehouseId(Integer destinationWarehouseId) {
        this.destinationWarehouseId = destinationWarehouseId;
    }

    public String getDestinationWarehouseName() {
        return destinationWarehouseName;
    }

    public void setDestinationWarehouseName(String destinationWarehouseName) {
        this.destinationWarehouseName = destinationWarehouseName;
    }

    public Integer getDocumentRefId() {
        return documentRefId;
    }

    public void setDocumentRefId(Integer documentRefId) {
        this.documentRefId = documentRefId;
    }

    public String getDocumentRefType() {
        return documentRefType;
    }

    public void setDocumentRefType(String documentRefType) {
        this.documentRefType = documentRefType;
    }

    public String getDocumentRefIdString() {
        if (documentRefType != null && documentRefId != null) {
            return documentRefType + "-" + documentRefId;
        }
        return null;
    }

    public String getTransferType() {
        return transferType;
    }

    public void setTransferType(String transferType) {
        this.transferType = transferType;
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

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public String getApproverName() {
        return approverName;
    }

    public void setApproverName(String approverName) {
        this.approverName = approverName;
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

    public LocalDateTime getTransferDate() {
        return transferDate;
    }

    public void setTransferDate(LocalDateTime transferDate) {
        this.transferDate = transferDate;
    }    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }
    
    public List<TransferOrderItem> getItems() {
        return items;
    }
    
    public void setItems(List<TransferOrderItem> items) {
        this.items = items;
    }
    
    public void addItem(TransferOrderItem item) {
        if (this.items == null) {
            this.items = new ArrayList<>();
        }
        this.items.add(item);
    }
}
