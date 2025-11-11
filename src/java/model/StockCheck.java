package model;

import java.util.Date;

public class StockCheck {
    private int checkId;
    private int warehouseId;
    private int productId;
    private int actualQuantity;
    private int userId;
    private Date date;
    private String notes;
    private String status;

    // Constructors
    public StockCheck() {}

    public StockCheck(int checkId, int warehouseId, int productId, int actualQuantity, int userId, Date date, String notes, String status) {
        this.checkId = checkId;
        this.warehouseId = warehouseId;
        this.productId = productId;
        this.actualQuantity = actualQuantity;
        this.userId = userId;
        this.date = date;
        this.notes = notes;
        this.status = status;
    }

    // Getters and Setters
    public int getCheckId() {
        return checkId;
    }

    public void setCheckId(int checkId) {
        this.checkId = checkId;
    }

    public int getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getActualQuantity() {
        return actualQuantity;
    }

    public void setActualQuantity(int actualQuantity) {
        this.actualQuantity = actualQuantity;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "StockCheck{" +
                "checkId=" + checkId +
                ", warehouseId=" + warehouseId +
                ", productId=" + productId +
                ", actualQuantity=" + actualQuantity +
                ", userId=" + userId +
                ", date=" + date +
                ", notes='" + notes + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}