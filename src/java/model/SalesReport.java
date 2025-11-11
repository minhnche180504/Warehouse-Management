/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author nguyen
 */
public class SalesReport {
    private String groupByValue; // Ngày/tháng/năm, tên sản phẩm, tên khách hàng
    private int totalOrders;
    private double totalRevenue;

    public SalesReport() {}

    public SalesReport(String groupByValue, int totalOrders, double totalRevenue) {
        this.groupByValue = groupByValue;
        this.totalOrders = totalOrders;
        this.totalRevenue = totalRevenue;
    }

    public String getGroupByValue() {
        return groupByValue;
    }

    public void setGroupByValue(String groupByValue) {
        this.groupByValue = groupByValue;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}
