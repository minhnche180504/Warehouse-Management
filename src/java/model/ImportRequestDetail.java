package model;

public class ImportRequestDetail {
    private int detailId;
    private int requestId;
    private int productId;
    private int quantity;
    private String productName;
    private String productCode;

    public ImportRequestDetail() {
    }

    public ImportRequestDetail(int detailId, int requestId, int productId, int quantity) {
        this.detailId = detailId;
        this.requestId = requestId;
        this.productId = productId;
        this.quantity = quantity;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
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

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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
} 