package model;

import java.util.Date;
import java.sql.Timestamp;
import java.util.List;

public class ImportRequest {

    private int requestId;
    private int productId;
    private String productName;
    private String productCode;
    private int quantity;
    private Timestamp requestDate;
    private int createdBy;
    private String createdByName;
    private String reason;
    private String status;
    private String productDetails;
    private List<ImportRequestDetail> details;
    private String rejectionReason;
    private String type;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public ImportRequest() {
    }

    public ImportRequest(int requestId, int productId, String productName, String productCode,
            int quantity, Timestamp requestDate, int createdBy, String createdByName,
            String reason, String status) {
        this.requestId = requestId;
        this.productId = productId;
        this.productName = productName;
        this.productCode = productCode;
        this.quantity = quantity;
        this.requestDate = requestDate;
        this.createdBy = createdBy;
        this.createdByName = createdByName;
        this.reason = reason;
        this.status = status;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
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

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Timestamp getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Timestamp requestDate) {
        this.requestDate = requestDate;
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

    public String getProductDetails() {
        return productDetails;
    }

    public void setProductDetails(String productDetails) {
        this.productDetails = productDetails;
    }

    public List<ImportRequestDetail> getDetails() {
        return details;
    }

    public void setDetails(List<ImportRequestDetail> details) {
        this.details = details;
    }

    @Override
    public String toString() {
        return "ImportRequest{" + "requestId=" + requestId + ", productId=" + productId
                + ", productName=" + productName + ", productCode=" + productCode
                + ", quantity=" + quantity + ", requestDate=" + requestDate
                + ", createdBy=" + createdBy + ", createdByName=" + createdByName
                + ", reason=" + reason + ", status=" + status + '}';
    }
}
