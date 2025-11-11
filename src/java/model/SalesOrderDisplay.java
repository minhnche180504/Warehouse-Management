package model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.text.DecimalFormat;

/**
 * SalesOrderDisplay class cho việc hiển thị với join data
 * Kế thừa từ SalesOrder để có đầy đủ fields cơ bản
 * Thêm các fields và methods để hỗ trợ display tốt hơn
 */
public class SalesOrderDisplay extends SalesOrder {
    
    // Additional display fields for list view
    private String statusBadgeClass;
    private String statusIcon;
    private String formattedOrderDate;
    private String formattedDeliveryDate;
    private String formattedTotalAmount;
    private String shortCustomerName;
    private String shortWarehouseName;
    private int itemCount;
    private boolean canCancel;
    private boolean canEdit;
    private boolean canApprove;
    private boolean canComplete;
    
    // Enhanced display fields
    private String orderAgeDisplay;
    private String priorityLevel;
    private String statusColor;
    private String warehouseDisplayName;
    private String customerDisplayInfo;
    private BigDecimal averageItemPrice;
    private int totalQuantity;
    
    // Constructor
    public SalesOrderDisplay() {
        super();
        initializeDisplayFields();
    }
    
    public SalesOrderDisplay(SalesOrder salesOrder) {
        // Copy all fields from SalesOrder
        this.setSoId(salesOrder.getSoId());
        this.setCustomerId(salesOrder.getCustomerId());
        this.setOrderDate(salesOrder.getOrderDate());
        this.setStatus(salesOrder.getStatus());
        this.setTotalAmount(salesOrder.getTotalAmount());
        this.setUserId(salesOrder.getUserId());
        this.setOrderNumber(salesOrder.getOrderNumber());
        this.setDeliveryDate(salesOrder.getDeliveryDate());
        this.setDeliveryAddress(salesOrder.getDeliveryAddress());
        this.setNotes(salesOrder.getNotes());
        this.setWarehouseId(salesOrder.getWarehouseId());
        this.setCustomerName(salesOrder.getCustomerName());
        this.setCustomerEmail(salesOrder.getCustomerEmail());
        this.setUserName(salesOrder.getUserName());
        this.setWarehouseName(salesOrder.getWarehouseName());
        this.setWarehouseAddress(salesOrder.getWarehouseAddress());
        this.setItems(salesOrder.getItems());
        this.setCancellationReason(salesOrder.getCancellationReason());
        this.setCancelledBy(salesOrder.getCancelledBy());
        this.setCancelledByName(salesOrder.getCancelledByName());
        this.setCancelledAt(salesOrder.getCancelledAt());
        
        // Set derived display fields
        initializeDisplayFields();
        calculateDisplayFields();
    }

    /**
     * Khởi tạo các display fields với giá trị mặc định
     */
    private void initializeDisplayFields() {
        this.statusBadgeClass = determineStatusBadgeClass();
        this.statusIcon = determineStatusIcon();
        this.statusColor = determineStatusColor();
        this.canCancel = determineCanCancel();
        this.canEdit = determineCanEdit();
        this.canApprove = determineCanApprove();
        this.canComplete = determineCanComplete();
        this.priorityLevel = determinePriorityLevel();
    }

    /**
     * Tính toán và format các display fields
     */
    public void calculateDisplayFields() {
        formatDates();
        formatCurrency();
        generateShortNames();
        calculateItemStatistics();
        generateOrderAge();
        generateDisplayNames();
    }

    // ========== GETTERS AND SETTERS ==========
    
    public String getStatusBadgeClass() {
        return statusBadgeClass;
    }

    public void setStatusBadgeClass(String statusBadgeClass) {
        this.statusBadgeClass = statusBadgeClass;
    }

    public String getStatusIcon() {
        return statusIcon;
    }

    public void setStatusIcon(String statusIcon) {
        this.statusIcon = statusIcon;
    }

    public String getFormattedOrderDate() {
        return formattedOrderDate;
    }

    public void setFormattedOrderDate(String formattedOrderDate) {
        this.formattedOrderDate = formattedOrderDate;
    }

    public String getFormattedDeliveryDate() {
        return formattedDeliveryDate;
    }

    public void setFormattedDeliveryDate(String formattedDeliveryDate) {
        this.formattedDeliveryDate = formattedDeliveryDate;
    }

    public String getFormattedTotalAmount() {
        return formattedTotalAmount;
    }

    public void setFormattedTotalAmount(String formattedTotalAmount) {
        this.formattedTotalAmount = formattedTotalAmount;
    }

    public String getShortCustomerName() {
        return shortCustomerName;
    }

    public void setShortCustomerName(String shortCustomerName) {
        this.shortCustomerName = shortCustomerName;
    }

    public String getShortWarehouseName() {
        return shortWarehouseName;
    }

    public void setShortWarehouseName(String shortWarehouseName) {
        this.shortWarehouseName = shortWarehouseName;
    }

    public int getItemCount() {
        return itemCount;
    }

    public void setItemCount(int itemCount) {
        this.itemCount = itemCount;
    }

    public boolean isCanCancel() {
        return canCancel;
    }

    public void setCanCancel(boolean canCancel) {
        this.canCancel = canCancel;
    }

    public boolean isCanEdit() {
        return canEdit;
    }

    public void setCanEdit(boolean canEdit) {
        this.canEdit = canEdit;
    }

    public boolean isCanApprove() {
        return canApprove;
    }

    public void setCanApprove(boolean canApprove) {
        this.canApprove = canApprove;
    }

    public boolean isCanComplete() {
        return canComplete;
    }

    public void setCanComplete(boolean canComplete) {
        this.canComplete = canComplete;
    }

    public String getOrderAgeDisplay() {
        return orderAgeDisplay;
    }

    public void setOrderAgeDisplay(String orderAgeDisplay) {
        this.orderAgeDisplay = orderAgeDisplay;
    }

    public String getPriorityLevel() {
        return priorityLevel;
    }

    public void setPriorityLevel(String priorityLevel) {
        this.priorityLevel = priorityLevel;
    }

    public String getStatusColor() {
        return statusColor;
    }

    public void setStatusColor(String statusColor) {
        this.statusColor = statusColor;
    }

    public String getWarehouseDisplayName() {
        return warehouseDisplayName;
    }

    public void setWarehouseDisplayName(String warehouseDisplayName) {
        this.warehouseDisplayName = warehouseDisplayName;
    }

    public String getCustomerDisplayInfo() {
        return customerDisplayInfo;
    }

    public void setCustomerDisplayInfo(String customerDisplayInfo) {
        this.customerDisplayInfo = customerDisplayInfo;
    }

    public BigDecimal getAverageItemPrice() {
        return averageItemPrice;
    }

    public void setAverageItemPrice(BigDecimal averageItemPrice) {
        this.averageItemPrice = averageItemPrice;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    // ========== HELPER METHODS ==========

    /**
     * Xác định CSS class cho status badge với màu sắc mới
     */
    private String determineStatusBadgeClass() {
        if (getStatus() == null) return "badge bg-secondary";
        
        switch (getStatus().toLowerCase()) {
            case "pending":
                return "badge bg-warning text-dark"; // Vàng cho pending
            case "processing":
                return "badge bg-info text-white"; // Xanh dương cho processing (delivery)
            case "completed":
                return "badge bg-success text-white"; // Xanh lá cho completed
            case "cancelled":
                return "badge bg-danger text-white"; // Đỏ cho cancelled
            default:
                return "badge bg-secondary text-white";
        }
    }

    /**
     * Xác định icon cho từng status
     */
    private String determineStatusIcon() {
        if (getStatus() == null) return "fas fa-question";
        
        switch (getStatus().toLowerCase()) {
            case "pending":
                return "fas fa-clock";
            case "processing":
                return "fas fa-shipping-fast";
            case "completed":
                return "fas fa-check-circle";
            case "cancelled":
                return "fas fa-times-circle";
            default:
                return "fas fa-info-circle";
        }
    }

    /**
     * Xác định màu cho status
     */
    private String determineStatusColor() {
        if (getStatus() == null) return "#6c757d";
        
        switch (getStatus().toLowerCase()) {
            case "pending":
                return "#ffc107"; // Vàng
            case "processing":
                return "#17a2b8"; // Xanh dương
            case "completed":
                return "#28a745"; // Xanh lá
            case "cancelled":
                return "#dc3545"; // Đỏ
            default:
                return "#6c757d"; // Xám
        }
    }

    /**
     * Xác định có thể cancel không
     */
    private boolean determineCanCancel() {
        String status = getStatus();
        return status != null && 
               !status.equals("Cancelled") && 
               !status.equals("Completed");
    }

    /**
     * Xác định có thể edit không
     */
    private boolean determineCanEdit() {
        String status = getStatus();
        return status != null && 
               status.equals("Pending");
    }

    /**
     * Xác định có thể approve không
     */
    private boolean determineCanApprove() {
        String status = getStatus();
        return status != null && 
               status.equals("Pending");
    }

    /**
     * Xác định có thể complete không
     */
    private boolean determineCanComplete() {
        String status = getStatus();
        return status != null && 
               status.equals("Processing");
    }

    /**
     * Xác định mức độ ưu tiên của order
     */
    private String determinePriorityLevel() {
        if (getTotalAmount() == null) return "Normal";
        
        double amount = getTotalAmount().doubleValue();
        if (amount >= 100000000) { // >= 100 triệu
            return "High";
        } else if (amount >= 50000000) { // >= 50 triệu
            return "Medium";
        } else {
            return "Normal";
        }
    }

    /**
     * Format dates cho display
     */
    private void formatDates() {
        DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter dateTimeFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        
        if (getOrderDate() != null) {
            // Convert Date to LocalDateTime
            LocalDateTime orderDateTime = getOrderDate().toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDateTime();
            this.formattedOrderDate = orderDateTime.format(dateTimeFormat);
        }
        
        if (getDeliveryDate() != null) {
            // Convert Date to LocalDate
            LocalDate deliveryLocalDate = getDeliveryDate().toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();
            this.formattedDeliveryDate = deliveryLocalDate.format(dateFormat);
        }
    }

    /**
     * Format currency cho display
     */
    private void formatCurrency() {
        if (getTotalAmount() != null) {
            DecimalFormat formatter = new DecimalFormat("#,###");
            this.formattedTotalAmount = formatter.format(getTotalAmount()) + " ₫";
        }
    }

    /**
     * Tạo short names cho display trong table
     */
    private void generateShortNames() {
        // Short customer name
        String fullName = getCustomerName();
        if (fullName != null && fullName.length() > 25) {
            this.shortCustomerName = fullName.substring(0, 22) + "...";
        } else {
            this.shortCustomerName = fullName;
        }
        
        // Short warehouse name
        String warehouseName = getWarehouseName();
        if (warehouseName != null && warehouseName.length() > 20) {
            this.shortWarehouseName = warehouseName.substring(0, 17) + "...";
        } else {
            this.shortWarehouseName = warehouseName;
        }
    }

    /**
     * Tính toán thống kê về items
     */
    private void calculateItemStatistics() {
        List<SalesOrderItem> items = getItems();
        if (items != null && !items.isEmpty()) {
            this.itemCount = items.size();
            
            // Tính tổng quantity
            int totalQty = 0;
            BigDecimal totalValue = BigDecimal.ZERO;
            
            for (SalesOrderItem item : items) {
                totalQty += item.getQuantity();
                if (item.getTotalPrice() != null) {
                    totalValue = totalValue.add(item.getTotalPrice());
                }
            }
            
            this.totalQuantity = totalQty;
            
            // Tính average price per item
            if (this.itemCount > 0 && totalValue.compareTo(BigDecimal.ZERO) > 0) {
                this.averageItemPrice = totalValue.divide(BigDecimal.valueOf(this.itemCount), 2, RoundingMode.HALF_UP);
            } else {
                this.averageItemPrice = BigDecimal.ZERO;
            }
        } else {
            this.itemCount = 0;
            this.totalQuantity = 0;
            this.averageItemPrice = BigDecimal.ZERO;
        }
    }

    /**
     * Tính toán tuổi của order
     */
    private void generateOrderAge() {
        if (getOrderDate() != null) {
            LocalDateTime orderDateTime = getOrderDate().toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDateTime();
            LocalDate orderDate = orderDateTime.toLocalDate();
            LocalDate now = LocalDate.now();
            
            long diffInDays = java.time.temporal.ChronoUnit.DAYS.between(orderDate, now);
            
            if (diffInDays == 0) {
                this.orderAgeDisplay = "Today";
            } else if (diffInDays == 1) {
                this.orderAgeDisplay = "1 day ago";
            } else if (diffInDays < 7) {
                this.orderAgeDisplay = diffInDays + " days ago";
            } else if (diffInDays < 30) {
                long weeks = diffInDays / 7;
                this.orderAgeDisplay = weeks + " week" + (weeks > 1 ? "s" : "") + " ago";
            } else {
                long months = diffInDays / 30;
                this.orderAgeDisplay = months + " month" + (months > 1 ? "s" : "") + " ago";
            }
        }
    }

    /**
     * Tạo display names cho warehouse và customer
     */
    private void generateDisplayNames() {
        // Warehouse display name
        if (getWarehouseName() != null && !getWarehouseName().trim().isEmpty()) {
            this.warehouseDisplayName = getWarehouseName();
        } else {
            this.warehouseDisplayName = "Warehouse " + getWarehouseId();
        }
        
        // Customer display info
        StringBuilder customerInfo = new StringBuilder();
        if (getCustomerName() != null) {
            customerInfo.append(getCustomerName());
        }
        if (getCustomerEmail() != null && !getCustomerEmail().trim().isEmpty()) {
            if (customerInfo.length() > 0) {
                customerInfo.append(" (").append(getCustomerEmail()).append(")");
            } else {
                customerInfo.append(getCustomerEmail());
            }
        }
        this.customerDisplayInfo = customerInfo.toString();
    }

    /**
     * Get display status với icon và màu sắc mới
     */
    public String getDisplayStatus() {
        String status = getStatus();
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
            default:
                return "<i class=\"fas fa-info-circle me-1 text-secondary\"></i>" + status;
        }
    }

    /**
     * Get display status chỉ với text và emoji
     */
    public String getDisplayStatusSimple() {
        String status = getStatus();
        if (status == null) return "❓ Unknown";
        
        switch (status.toLowerCase()) {
            case "pending":
                return "⏳ Pending";
            case "processing":
                return "🚚 Processing";
            case "completed":
                return "✅ Completed";
            case "cancelled":
                return "❌ Cancelled";
            default:
                return "ℹ️ " + status;
        }
    }

    /**
     * Get priority badge class
     */
    public String getPriorityBadgeClass() {
        switch (getPriorityLevel().toLowerCase()) {
            case "high":
                return "badge bg-danger";
            case "medium":
                return "badge bg-warning text-dark";
            case "normal":
            default:
                return "badge bg-secondary";
        }
    }

    /**
     * Check if order is overdue
     */
    public boolean isOverdue() {
        if (getDeliveryDate() == null || isCompleted() || isCancelled()) {
            return false;
        }
        
        LocalDate deliveryLocalDate = getDeliveryDate().toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
        LocalDate now = LocalDate.now();
        return now.isAfter(deliveryLocalDate);
    }

    /**
     * Get overdue days
     */
    public int getOverdueDays() {
        if (!isOverdue()) {
            return 0;
        }
        
        LocalDate deliveryLocalDate = getDeliveryDate().toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
        LocalDate now = LocalDate.now();
        return (int) java.time.temporal.ChronoUnit.DAYS.between(deliveryLocalDate, now);
    }

    /**
     * Format total amount với format đẹp hơn
     */
    public String getFormattedTotalAmountWithSymbol() {
        if (getTotalAmount() == null) {
            return "0 ₫";
        }
        
        DecimalFormat formatter = new DecimalFormat("#,###");
        return formatter.format(getTotalAmount()) + " ₫";
    }

    /**
     * Get order summary cho tooltip hoặc popup
     */
    public String getOrderSummary() {
        StringBuilder summary = new StringBuilder();
        summary.append("Order: ").append(getOrderNumber()).append("\n");
        summary.append("Customer: ").append(getCustomerName()).append("\n");
        summary.append("Warehouse: ").append(getWarehouseDisplayName()).append("\n");
        summary.append("Status: ").append(getStatus()).append("\n");
        summary.append("Items: ").append(getItemCount()).append("\n");
        summary.append("Total: ").append(getFormattedTotalAmountWithSymbol()).append("\n");
        if (getOrderAgeDisplay() != null) {
            summary.append("Age: ").append(getOrderAgeDisplay());
        }
        return summary.toString();
    }

    /**
     * Check if order needs attention (overdue hoặc high priority)
     */
    public boolean needsAttention() {
        return isOverdue() || "High".equals(getPriorityLevel());
    }

    /**
     * Get CSS class cho row highlighting
     */
    public String getRowClass() {
        if (isOverdue()) {
            return "table-danger";
        } else if ("High".equals(getPriorityLevel())) {
            return "table-warning";
        } else if (isCompleted()) {
            return "table-success";
        } else if (isCancelled()) {
            return "table-secondary";
        }
        return "";
    }

    @Override
    public String toString() {
        return "SalesOrderDisplay{" +
                "soId=" + getSoId() +
                ", orderNumber='" + getOrderNumber() + '\'' +
                ", customerName='" + getShortCustomerName() + '\'' +
                ", warehouseName='" + getShortWarehouseName() + '\'' +
                ", status='" + getStatus() + '\'' +
                ", itemCount=" + itemCount +
                ", totalAmount=" + getFormattedTotalAmount() +
                ", orderAge='" + orderAgeDisplay + '\'' +
                ", priority='" + priorityLevel + '\'' +
                '}';
    }
}