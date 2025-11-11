/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.CustomerQuote;
import model.CustomerQuoteItem;

/**
 *
 * @author nguyen
 */
public class CustomerQuoteDAO extends DBConnect {

    public boolean addCustomerQuote(CustomerQuote quote, List<CustomerQuoteItem> items) {
        String insertQuote = "INSERT INTO Quotation (customer_id, user_id, created_at, valid_until, total_amount, notes) VALUES (?, ?, GETDATE(), ?, ?, ?)";
        String insertItem = "INSERT INTO Quotation_Item (quotation_id, product_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement psQuote = null;
        PreparedStatement psItem = null;
        ResultSet rs = null;
        try {
            connection.setAutoCommit(false);
            psQuote = connection.prepareStatement(insertQuote, Statement.RETURN_GENERATED_KEYS);
            psQuote.setInt(1, quote.getCustomerId());
            psQuote.setInt(2, quote.getUserId());
            psQuote.setDate(3, new java.sql.Date(quote.getValidUntil().getTime()));
            psQuote.setDouble(4, quote.getTotalAmount());
            psQuote.setString(5, quote.getNotes());
            int affectedRows = psQuote.executeUpdate();
            if (affectedRows == 0) {
                connection.rollback();
                return false;
            }
            rs = psQuote.getGeneratedKeys();
            int quotationId = -1;
            if (rs.next()) {
                quotationId = rs.getInt(1);
            } else {
                connection.rollback();
                return false;
            }
            psItem = connection.prepareStatement(insertItem);
            for (CustomerQuoteItem item : items) {
                psItem.setInt(1, quotationId);
                psItem.setInt(2, item.getProductId());
                psItem.setInt(3, item.getQuantity());
                psItem.setDouble(4, item.getUnitPrice());
                psItem.setDouble(5, item.getTotalPrice());
                psItem.addBatch();
            }
            int[] itemResults = psItem.executeBatch();
            for (int res : itemResults) {
                if (res == Statement.EXECUTE_FAILED) {
                    connection.rollback();
                    return false;
                }
            }
            connection.commit();
            return true;
        } catch (Exception ex) {
            try { connection.rollback(); } catch (Exception e) {}
            ex.printStackTrace();
            return false;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (psQuote != null) psQuote.close(); } catch (Exception e) {}
            try { if (psItem != null) psItem.close(); } catch (Exception e) {}
            try { connection.setAutoCommit(true); } catch (Exception e) {}
        }
    }

    // Lấy danh sách báo giá
    public List<CustomerQuote> getAllCustomerQuotes() {
        List<CustomerQuote> list = new ArrayList<>();
        String sql = "SELECT q.*, c.customer_name FROM Quotation q JOIN Customer c ON q.customer_id = c.customer_id ORDER BY q.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CustomerQuote q = new CustomerQuote();
                q.setQuotationId(rs.getInt("quotation_id"));
                q.setCustomerId(rs.getInt("customer_id"));
                q.setUserId(rs.getInt("user_id"));
                q.setCreatedAt(rs.getTimestamp("created_at"));
                q.setValidUntil(rs.getDate("valid_until"));
                q.setTotalAmount(rs.getDouble("total_amount"));
                q.setNotes(rs.getString("notes"));
                q.setCustomerName(rs.getString("customer_name"));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

   // Lấy chi tiết báo giá theo ID (bao gồm tên khách hàng)
    public CustomerQuote getCustomerQuoteById(int id) {
        String sql = "SELECT q.*, c.customer_name FROM Quotation q JOIN Customer c ON q.customer_id = c.customer_id WHERE q.quotation_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CustomerQuote q = new CustomerQuote();
                q.setQuotationId(rs.getInt("quotation_id"));
                q.setCustomerId(rs.getInt("customer_id"));
                q.setUserId(rs.getInt("user_id"));
                q.setCreatedAt(rs.getTimestamp("created_at"));
                q.setValidUntil(rs.getDate("valid_until"));
                q.setTotalAmount(rs.getDouble("total_amount"));
                q.setNotes(rs.getString("notes"));
                q.setCustomerName(rs.getString("customer_name"));
                return q;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy danh sách item của một báo giá (bao gồm tên sản phẩm, đơn vị)
    public List<CustomerQuoteItem> getItemsByQuoteId(int quotationId) {
        List<CustomerQuoteItem> list = new ArrayList<>();
        String sql = "SELECT qi.*, p.name as product_name, u.unit_name FROM Quotation_Item qi " +
                     "JOIN Product p ON qi.product_id = p.product_id " +
                     "LEFT JOIN Unit u ON p.unit_id = u.unit_id " +
                     "WHERE qi.quotation_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quotationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomerQuoteItem item = new CustomerQuoteItem();
                item.setQuotationItemId(rs.getInt("quotation_item_id"));
                item.setQuotationId(rs.getInt("quotation_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnitPrice(rs.getDouble("unit_price"));
                item.setTotalPrice(rs.getDouble("total_price"));
                item.setProductName(rs.getString("product_name"));
                item.setUnitName(rs.getString("unit_name"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

   

    // Tìm kiếm báo giá theo tên khách hàng và ngày tạo
    public List<CustomerQuote> searchCustomerQuotes(String customerName, String createdAt) {
        List<CustomerQuote> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT q.*, c.customer_name FROM Quotation q JOIN Customer c ON q.customer_id = c.customer_id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (customerName != null && !customerName.trim().isEmpty()) {
            sql.append(" AND c.customer_name LIKE ?");
            params.add("%" + customerName.trim() + "%");
        }
        if (createdAt != null && !createdAt.trim().isEmpty()) {
            sql.append(" AND CONVERT(date, q.created_at) = ?");
            params.add(createdAt);
        }
        sql.append(" ORDER BY q.created_at DESC");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomerQuote q = new CustomerQuote();
                q.setQuotationId(rs.getInt("quotation_id"));
                q.setCustomerId(rs.getInt("customer_id"));
                q.setUserId(rs.getInt("user_id"));
                q.setCreatedAt(rs.getTimestamp("created_at"));
                q.setValidUntil(rs.getDate("valid_until"));
                q.setTotalAmount(rs.getDouble("total_amount"));
                q.setNotes(rs.getString("notes"));
                q.setCustomerName(rs.getString("customer_name"));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
