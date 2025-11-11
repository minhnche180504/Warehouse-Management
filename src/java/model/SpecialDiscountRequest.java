package model;

import java.sql.Timestamp;

public class SpecialDiscountRequest {
    private int requestId;
    private int customerId;
    private int requestedBy;
    private String discountType;
    private double discountValue;
    private String reason;
    private Double estimatedOrderValue;
    private String status; // "Pending", "Approved", "Rejected"
    private Integer approvedBy;
    private Timestamp approvedAt;
    private String rejectionReason;
    private String generatedCode;
    private Timestamp expiryDate;
    private Timestamp createdAt;
    
    // Additional fields for display
    private String customerName;
    private String requestedByName;
    private String approvedByName;
    
    // Constructor
    public SpecialDiscountRequest() {}
    
    public SpecialDiscountRequest(int customerId, int requestedBy, String discountType, 
                                double discountValue, String reason, Double estimatedOrderValue) {
        this.customerId = customerId;
        this.requestedBy = requestedBy;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.reason = reason;
        this.estimatedOrderValue = estimatedOrderValue;
        this.status = "Pending";
    }
    
    // Utility methods
    public boolean isPending() {
        return "Pending".equals(status);
    }
    
    public boolean isApproved() {
        return "Approved".equals(status);
    }
    
    public boolean isRejected() {
        return "Rejected".equals(status);
    }
    
    public String getStatusColor() {
        switch (status) {
            case "Pending": return "warning";
            case "Approved": return "success";
            case "Rejected": return "danger";
            default: return "secondary";
        }
    }
    
    // Getters and Setters
    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }
    
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    
    public int getRequestedBy() { return requestedBy; }
    public void setRequestedBy(int requestedBy) { this.requestedBy = requestedBy; }
    
    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }
    
    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    
    public Double getEstimatedOrderValue() { return estimatedOrderValue; }
    public void setEstimatedOrderValue(Double estimatedOrderValue) { this.estimatedOrderValue = estimatedOrderValue; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Integer getApprovedBy() { return approvedBy; }
    public void setApprovedBy(Integer approvedBy) { this.approvedBy = approvedBy; }
    
    public Timestamp getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }
    
    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }
    
    public String getGeneratedCode() { return generatedCode; }
    public void setGeneratedCode(String generatedCode) { this.generatedCode = generatedCode; }
    
    public Timestamp getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Timestamp expiryDate) { this.expiryDate = expiryDate; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    
    public String getRequestedByName() { return requestedByName; }
    public void setRequestedByName(String requestedByName) { this.requestedByName = requestedByName; }
    
    public String getApprovedByName() { return approvedByName; }
    public void setApprovedByName(String approvedByName) { this.approvedByName = approvedByName; }
    
    @Override
    public String toString() {
        return "SpecialDiscountRequest{" +
                "requestId=" + requestId +
                ", customerId=" + customerId +
                ", discountType='" + discountType + '\'' +
                ", discountValue=" + discountValue +
                ", status='" + status + '\'' +
                '}';
    }
}