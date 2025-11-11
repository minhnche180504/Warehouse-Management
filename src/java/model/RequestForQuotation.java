package model;

import java.sql.Date;

/**
 * RequestForQuotation class represents a request for quotation in the system
 * Maps to the Request_For_Quotation table in the database
 */
public class RequestForQuotation {
    private Integer rfqId;
    private Integer createdBy;
    private Date requestDate;
    private String status;
    private String notes;
    private String description;
    private Integer supplierId;
    private Integer warehouseId;
    private Date expectedDeliveryDate;
    
    // Additional fields for display purposes
    private String supplierName;
    private String supplierEmail;
    private String supplierPhone;
    private String createdByName;
    private String warehouseName;

    // Default constructor
    public RequestForQuotation() {
    }

    // Constructor with all fields
    public RequestForQuotation(Integer rfqId, Integer createdBy, Date requestDate, 
                              String status, String notes, String description, Integer supplierId,
                              Integer warehouseId, Date expectedDeliveryDate) {
        this.rfqId = rfqId;
        this.createdBy = createdBy;
        this.requestDate = requestDate;
        this.status = status;
        this.notes = notes;
        this.description = description;
        this.supplierId = supplierId;
        this.warehouseId = warehouseId;
        this.expectedDeliveryDate = expectedDeliveryDate;
    }

    // Getters and Setters
    public Integer getRfqId() {
        return rfqId;
    }

    public void setRfqId(Integer rfqId) {
        this.rfqId = rfqId;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Integer getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Integer supplierId) {
        this.supplierId = supplierId;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getSupplierEmail() {
        return supplierEmail;
    }

    public void setSupplierEmail(String supplierEmail) {
        this.supplierEmail = supplierEmail;
    }

    public String getSupplierPhone() {
        return supplierPhone;
    }

    public void setSupplierPhone(String supplierPhone) {
        this.supplierPhone = supplierPhone;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(Integer warehouseId) {
        this.warehouseId = warehouseId;
    }

    public Date getExpectedDeliveryDate() {
        return expectedDeliveryDate;
    }

    public void setExpectedDeliveryDate(Date expectedDeliveryDate) {
        this.expectedDeliveryDate = expectedDeliveryDate;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    @Override
    public String toString() {
        return "RequestForQuotation{" +
                "rfqId=" + rfqId +
                ", createdBy=" + createdBy +
                ", requestDate=" + requestDate +
                ", status='" + status + '\'' +
                ", notes='" + notes + '\'' +
                ", description='" + description + '\'' +
                ", supplierId=" + supplierId +
                ", warehouseId=" + warehouseId +
                ", expectedDeliveryDate=" + expectedDeliveryDate +
                ", supplierName='" + supplierName + '\'' +
                ", warehouseName='" + warehouseName + '\'' +
                '}';
    }
}