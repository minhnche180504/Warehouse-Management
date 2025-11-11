package model;

public class PurchaseRequestItem {
    private int prItemId;
    private int prId;
    private int productId;
    private int quantity;
    private String note;

    // Các trường để hiển thị thông tin liên quan
    private String productName;
    private String productCode;

    public PurchaseRequestItem() {
    }

    public PurchaseRequestItem(int prItemId, int prId, int productId, int quantity, String note, String productName, String productCode) {
        this.prItemId = prItemId;
        this.prId = prId;
        this.productId = productId;
        this.quantity = quantity;
        this.note = note;
        this.productName = productName;
        this.productCode = productCode;
    }

    public int getPrItemId() {
        return prItemId;
    }

    public void setPrItemId(int prItemId) {
        this.prItemId = prItemId;
    }

    public int getPrId() {
        return prId;
    }

    public void setPrId(int prId) {
        this.prId = prId;
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

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
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
