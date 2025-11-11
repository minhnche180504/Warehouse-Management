package model;

import java.sql.Date;        
import java.sql.Timestamp;  
import java.util.List;
import java.util.ArrayList;

public class StockCheckReport {
    private int reportId;
    private String reportCode;
    private int warehouseId;
    private String warehouseName; 
    private Date reportDate;      
    private int createdBy;
    private String createdByName; 
    private Timestamp createdAt;  
    private String status;
    private String notes;
    private Integer approvedBy;   
    private String approvedByName; 
    private Timestamp approvedAt; 
    private String managerNotes;
    private List<StockCheckReportItem> items;

    // Constructors
    public StockCheckReport() {
        this.items = new ArrayList<>(); 
    }

    // Getters and Setters
    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public String getReportCode() {
        return reportCode;
    }

    public void setReportCode(String reportCode) {
        this.reportCode = reportCode;
    }

    public int getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public Date getReportDate() {
        return reportDate;
    }

    public void setReportDate(Date reportDate) {
        this.reportDate = reportDate;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
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

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public String getApprovedByName() {
        return approvedByName;
    }

    public void setApprovedByName(String approvedByName) {
        this.approvedByName = approvedByName;
    }

    public Timestamp getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(Timestamp approvedAt) {
        this.approvedAt = approvedAt;
    }

    public String getManagerNotes() {
        return managerNotes;
    }

    public void setManagerNotes(String managerNotes) {
        this.managerNotes = managerNotes;
    }

    public List<StockCheckReportItem> getItems() {
        return items;
    }

    public void setItems(List<StockCheckReportItem> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "StockCheckReport{" +
                "reportId=" + reportId +
                ", reportCode='" + reportCode + '\'' +
                ", warehouseId=" + warehouseId +
                ", warehouseName='" + warehouseName + '\'' +
                ", reportDate=" + reportDate +
                ", createdBy=" + createdBy +
                ", createdByName='" + createdByName + '\'' +
                ", createdAt=" + createdAt +
                ", status='" + status + '\'' +
                ", notes='" + (notes != null ? notes.substring(0, Math.min(notes.length(), 20)) + "..." : "null") + '\'' +
                ", approvedBy=" + approvedBy +
                ", approvedByName='" + approvedByName + '\'' +
                ", approvedAt=" + approvedAt +
                ", managerNotes='" + (managerNotes != null ? managerNotes.substring(0, Math.min(managerNotes.length(), 20)) + "..." : "null") + '\'' +
                ", itemsCount=" + (items != null ? items.size() : 0) +
                '}';
    }
}
