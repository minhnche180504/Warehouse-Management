package model;

import java.sql.Date;
import java.util.List;

/**
 * PurchaseOrder class represents a purchase order in the warehouse management system
 * This class maps to the Purchase_Order table in the database
 */
public class PurchaseOrder {
    private Integer poId;
    private Integer supplierId;
    private String supplierName;
    private Integer userId;
    private String userName;
    private Integer warehouseId;
    private String warehouseName;
    private Date date;
    private String status;
    private Date expectedDeliveryDate;
    private List<PurchaseOrderItem> items;

    public PurchaseOrder() {
    }

    public PurchaseOrder(Integer poId, Integer supplierId, String supplierName, Integer userId, String userName, Integer warehouseId, String warehouseName, Date date, String status, Date expectedDeliveryDate, List<PurchaseOrderItem> items) {
        this.poId = poId;
        this.supplierId = supplierId;
        this.supplierName = supplierName;
        this.userId = userId;
        this.userName = userName;
        this.warehouseId = warehouseId;
        this.warehouseName = warehouseName;
        this.date = date;
        this.status = status;
        this.expectedDeliveryDate = expectedDeliveryDate;
        this.items = items;
    }

    public Integer getPoId() {
        return poId;
    }

    public void setPoId(Integer poId) {
        this.poId = poId;
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

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

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

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getExpectedDeliveryDate() {
        return expectedDeliveryDate;
    }

    public void setExpectedDeliveryDate(Date expectedDeliveryDate) {
        this.expectedDeliveryDate = expectedDeliveryDate;
    }

    public List<PurchaseOrderItem> getItems() {
        return items;
    }

    public void setItems(List<PurchaseOrderItem> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "PurchaseOrder{" +
                "poId=" + poId +
                ", supplierId=" + supplierId +
                ", supplierName='" + supplierName + '\'' +
                ", userId=" + userId +
                ", userName='" + userName + '\'' +
                ", warehouseId=" + warehouseId +
                ", warehouseName='" + warehouseName + '\'' +
                ", date=" + date +
                ", status='" + status + '\'' +
                ", expectedDeliveryDate=" + expectedDeliveryDate +
                ", items=" + items +
                '}';
    }
}