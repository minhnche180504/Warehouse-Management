package model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class SalesOrder {
    private int soId;
    private int customerId;
    private Date orderDate;
    private String status;
    private BigDecimal totalAmount;
    private int userId;
    private String orderNumber;
    private Date deliveryDate;
    private String deliveryAddress;
    private String notes;
    private int warehouseId; // Thêm warehouse ID
    
    // Cancellation fields
    private String cancellationReason;
    private Integer cancelledBy;
    private Date cancelledAt;
    
    // Discount fields
    private Integer discountCodeId;
    private Integer specialRequestId; 
    private BigDecimal discountAmount = BigDecimal.ZERO;
    private BigDecimal totalBeforeDiscount = BigDecimal.ZERO;
    
    // Related information for display
    private String customerName;
    private String customerEmail;
    private String userName;
    private String cancelledByName;
    private String warehouseName; // Thêm warehouse name
    private String warehouseAddress; // Thêm warehouse address
    
    // Order items
    private List<SalesOrderItem> items;

    // Constructors
    public SalesOrder() {}

    public SalesOrder(int customerId, int userId, Date orderDate, String status, 
                     String orderNumber, BigDecimal totalAmount, int warehouseId) {
        this.customerId = customerId;
        this.userId = userId;
        this.orderDate = orderDate;
        this.status = status;
        this.orderNumber = orderNumber;
        this.totalAmount = totalAmount;
        this.warehouseId = warehouseId;
    }

    // Getters and Setters
    public int getSoId() { return soId; }
    public void setSoId(int soId) { this.soId = soId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getOrderNumber() { return orderNumber; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }

    public Date getDeliveryDate() { return deliveryDate; }
    public void setDeliveryDate(Date deliveryDate) { this.deliveryDate = deliveryDate; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public int getWarehouseId() { return warehouseId; }
    public void setWarehouseId(int warehouseId) { this.warehouseId = warehouseId; }

    public String getCancellationReason() { return cancellationReason; }
    public void setCancellationReason(String cancellationReason) { this.cancellationReason = cancellationReason; }

    public Integer getCancelledBy() { return cancelledBy; }
    public void setCancelledBy(Integer cancelledBy) { this.cancelledBy = cancelledBy; }

    public Date getCancelledAt() { return cancelledAt; }
    public void setCancelledAt(Date cancelledAt) { this.cancelledAt = cancelledAt; }

    // Discount getters and setters
    public Integer getDiscountCodeId() { 
        return discountCodeId; 
    }
    public void setDiscountCodeId(Integer discountCodeId) { 
        this.discountCodeId = discountCodeId; 
    }

    public Integer getSpecialRequestId() { 
        return specialRequestId; 
    }
    public void setSpecialRequestId(Integer specialRequestId) { 
        this.specialRequestId = specialRequestId; 
    }

    public BigDecimal getDiscountAmount() { 
        return discountAmount != null ? discountAmount : BigDecimal.ZERO; 
    }
    public void setDiscountAmount(BigDecimal discountAmount) { 
        this.discountAmount = discountAmount; 
    }
    public void setDiscountAmount(double discountAmount) { 
        this.discountAmount = BigDecimal.valueOf(discountAmount); 
    }

    public BigDecimal getTotalBeforeDiscount() { 
        return totalBeforeDiscount != null ? totalBeforeDiscount : BigDecimal.ZERO; 
    }
    public void setTotalBeforeDiscount(BigDecimal totalBeforeDiscount) { 
        this.totalBeforeDiscount = totalBeforeDiscount; 
    }
    public void setTotalBeforeDiscount(double totalBeforeDiscount) { 
        this.totalBeforeDiscount = BigDecimal.valueOf(totalBeforeDiscount); 
    }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getCancelledByName() { return cancelledByName; }
    public void setCancelledByName(String cancelledByName) { this.cancelledByName = cancelledByName; }

    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }

    public String getWarehouseAddress() { return warehouseAddress; }
    public void setWarehouseAddress(String warehouseAddress) { this.warehouseAddress = warehouseAddress; }

    public List<SalesOrderItem> getItems() { return items; }
    public void setItems(List<SalesOrderItem> items) { this.items = items; }

    // Status utility methods
    public boolean isPending() {
        return "Pending".equals(status);
    }

    public boolean isProcessing() {
        return "Processing".equals(status);
    }

    public boolean isCompleted() {
        return "Completed".equals(status);
    }

    public boolean isCancelled() {
        return "Cancelled".equals(status);
    }

    public boolean canEdit() {
        return isPending();
    }

    public boolean canCancel() {
        return !isCancelled() && !isCompleted();
    }

    public boolean canApprove() {
        return isPending();
    }

    public boolean canComplete() {
        return isProcessing();
    }

    public boolean isReturning() {
        return "returning".equals(status);
    }

    public boolean isReturned() {
        return "returned".equals(status);
    }

    public boolean canReturn() {
        return isCompleted();
    }

    // Utility methods cho discount
    public boolean hasDiscount() {
        return discountAmount != null && discountAmount.compareTo(BigDecimal.ZERO) > 0;
    }

    public String getFormattedDiscountAmount() {
        if (discountAmount == null) return "0 ₫";
        return String.format("%,.0f ₫", discountAmount);
    }

    public String getFormattedTotalBeforeDiscount() {
        if (totalBeforeDiscount == null) return "0 ₫";
        return String.format("%,.0f ₫", totalBeforeDiscount);
    }

    // Get status badge class for UI
    public String getStatusBadgeClass() {
        if (status == null) return "badge-secondary";
        
        switch (status.toLowerCase()) {
            case "pending":
                return "badge-warning"; // Vàng cho pending
            case "processing":
                return "badge-info"; // Xanh dương cho processing
            case "completed":
                return "badge-success"; // Xanh lá cho completed
            case "cancelled":
                return "badge-danger"; // Đỏ cho cancelled
            case "returning":
                return "badge-warning"; // Vàng cho returning
            case "returned":
                return "badge-secondary"; // Xám cho returned
            default:
                return "badge-secondary";
        }
    }

    // Get status display with icon
    public String getStatusDisplay() {
        if (status == null) return "Unknown";
        
        switch (status.toLowerCase()) {
            case "pending":
                return "<i class=\"fas fa-clock me-1 text-warning\"></i>Pending";
            case "processing":
                return "<i class=\"fas fa-shipping-fast me-1 text-info\"></i>Processing";
            case "completed":
                return "<i class=\"fas fa-check-circle me-1 text-success\"></i>Completed";
            case "cancelled":
                return "<i class=\"fas fa-times-circle me-1 text-danger\"></i>Cancelled";
            case "returning":
                return "<i class=\"fas fa-undo me-1 text-warning\"></i>Returning";
            case "returned":
                return "<i class=\"fas fa-check-double me-1 text-secondary\"></i>Returned";
            default:
                return status;
        }
    }

    @Override
    public String toString() {
        return "SalesOrder{" +
                "soId=" + soId +
                ", orderNumber='" + orderNumber + '\'' +
                ", customerName='" + customerName + '\'' +
                ", status='" + status + '\'' +
                ", totalAmount=" + totalAmount +
                ", discountAmount=" + discountAmount +
                ", warehouseName='" + warehouseName + '\'' +
                '}';
    }
}