/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author nguyen
 */
public class CustomerQuoteItem {
    private int quotationItemId;
    private int quotationId;
    private int productId;
    private int quantity;
    private double unitPrice;
    private double totalPrice;
    private String productName;
    private String unitName;

    // Getters and Setters
    public int getQuotationItemId() {
        return quotationItemId;
    }
    public void setQuotationItemId(int quotationItemId) {
        this.quotationItemId = quotationItemId;
    }
    public int getQuotationId() {
        return quotationId;
    }
    public void setQuotationId(int quotationId) {
        this.quotationId = quotationId;
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
    public double getUnitPrice() {
        return unitPrice;
    }
    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }
    public double getTotalPrice() {
        return totalPrice;
    }
    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }
    public String getProductName() {
        return productName;
    }
    public void setProductName(String productName) {
        this.productName = productName;
    }
    public String getUnitName() {
        return unitName;
    }
    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }
}