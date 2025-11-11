package model;

public class StockCheckReportItem {
    private int reportItemId;
    private int reportId; // Khóa ngoại trỏ tới StockCheckReport
    private int productId;
    private String productName; // Để hiển thị tên sản phẩm
    private String productCode; // Để hiển thị mã sản phẩm
    private int systemQuantity;
    private int countedQuantity;
    private int discrepancy; 
    private String reason;

    // Constructors
    public StockCheckReportItem() {
    }

    // Getters and Setters
    public int getReportItemId() {
        return reportItemId;
    }

    public void setReportItemId(int reportItemId) {
        this.reportItemId = reportItemId;
    }

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public int getSystemQuantity() {
        return systemQuantity;
    }

    public void setSystemQuantity(int systemQuantity) {
        this.systemQuantity = systemQuantity;
    }

    public int getCountedQuantity() {
        return countedQuantity;
    }

    public void setCountedQuantity(int countedQuantity) {
        this.countedQuantity = countedQuantity;
    }

    public int getDiscrepancy() {
        return discrepancy;
    }

    public void setDiscrepancy(int discrepancy) {
        // Giá trị này được tính toán bởi DB hoặc có thể tính trong Java nếu cần
        this.discrepancy = discrepancy;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    @Override
    public String toString() {
        return "StockCheckReportItem{" +
                "reportItemId=" + reportItemId +
                ", reportId=" + reportId +
                ", productId=" + productId +
                ", productName='" + productName + '\'' +
                ", systemQuantity=" + systemQuantity +
                ", countedQuantity=" + countedQuantity +
                ", discrepancy=" + discrepancy +
                ", reason='" + reason + '\'' +
                '}';
    }
}
