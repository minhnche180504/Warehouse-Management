package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public class PurchaseRequest {
    private int prId;
    private String prNumber;
    private int requestedBy;
    private Timestamp requestDate;
    private int warehouseId;
    private Date preferredDeliveryDate;
    private String reason;
    private String status;
    private Integer confirmBy;
    private Timestamp createdAt;

    // Các trường để hiển thị thông tin liên quan
    private String requestedByName;
    private String warehouseName;
    private String confirmByName;
    private List<PurchaseRequestItem> items;

    public PurchaseRequest() {
    }

    public PurchaseRequest(int prId, String prNumber, int requestedBy, Timestamp requestDate, int warehouseId, Date preferredDeliveryDate, String reason, String status, Integer confirmBy, Timestamp createdAt, String requestedByName, String warehouseName, String confirmByName, List<PurchaseRequestItem> items) {
        this.prId = prId;
        this.prNumber = prNumber;
        this.requestedBy = requestedBy;
        this.requestDate = requestDate;
        this.warehouseId = warehouseId;
        this.preferredDeliveryDate = preferredDeliveryDate;
        this.reason = reason;
        this.status = status;
        this.confirmBy = confirmBy;
        this.createdAt = createdAt;
        this.requestedByName = requestedByName;
        this.warehouseName = warehouseName;
        this.confirmByName = confirmByName;
        this.items = items;
    }

    public int getPrId() {
        return prId;
    }

    public void setPrId(int prId) {
        this.prId = prId;
    }

    public String getPrNumber() {
        return prNumber;
    }

    public void setPrNumber(String prNumber) {
        this.prNumber = prNumber;
    }

    public int getRequestedBy() {
        return requestedBy;
    }

    public void setRequestedBy(int requestedBy) {
        this.requestedBy = requestedBy;
    }

    public Timestamp getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Timestamp requestDate) {
        this.requestDate = requestDate;
    }

    public int getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public Date getPreferredDeliveryDate() {
        return preferredDeliveryDate;
    }

    public void setPreferredDeliveryDate(Date preferredDeliveryDate) {
        this.preferredDeliveryDate = preferredDeliveryDate;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getConfirmBy() {
        return confirmBy;
    }

    public void setConfirmBy(Integer confirmBy) {
        this.confirmBy = confirmBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getRequestedByName() {
        return requestedByName;
    }

    public void setRequestedByName(String requestedByName) {
        this.requestedByName = requestedByName;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public String getConfirmByName() {
        return confirmByName;
    }

    public void setConfirmByName(String confirmByName) {
        this.confirmByName = confirmByName;
    }

    public List<PurchaseRequestItem> getItems() {
        return items;
    }

    public void setItems(List<PurchaseRequestItem> items) {
        this.items = items;
    }
}