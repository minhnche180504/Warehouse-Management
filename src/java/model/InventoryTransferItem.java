package model;

/**
 * InventoryTransferItem class represents an item in an inventory transfer
 * This class maps to the Inventory_Transfer_Item table in the database
 */
public class InventoryTransferItem {
    private int itemId; // it_item_id
    private int transferId; // it_id
    private int productId;
    private String productName;
    private String productCode;
    private int quantity;
    private Unit unit;
    
    public InventoryTransferItem() {
    }

    public InventoryTransferItem(int itemId, int transferId, int productId, int quantity) {
        this.itemId = itemId;
        this.transferId = transferId;
        this.productId = productId;
        this.quantity = quantity;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getTransferId() {
        return transferId;
    }

    public void setTransferId(int transferId) {
        this.transferId = transferId;
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

    public Unit getUnit() {
        return unit;
    }

    public void setUnit(Unit unit) {
        this.unit = unit;
    }

    @Override
    public String toString() {
        return "InventoryTransferItem{" +
                "itemId=" + itemId +
                ", transferId=" + transferId +
                ", productId=" + productId +
                ", productName='" + productName + '\'' +
                ", productCode='" + productCode + '\'' +
                ", quantity=" + quantity +
                ", unit=" + unit +
                '}';
    }
}
