/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.Customer;

/**
 * CustomerDAO class for managing customer data operations
 */
public class CustomerDAO extends DBConnect {

    /**
     * Lấy tất cả customers chưa bị xóa
     */
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT customer_id, customer_name, address, phone, email, is_delete " +
                     "FROM Customer WHERE is_delete = 0 ORDER BY customer_name";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setCustomerName(rs.getString("customer_name"));
                customer.setAddress(rs.getString("address"));
                customer.setPhone(rs.getString("phone"));
                customer.setEmail(rs.getString("email"));
                customer.setIsDelete(rs.getInt("is_delete"));
                customers.add(customer);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all customers: " + e.getMessage());
            e.printStackTrace();
        }
        return customers;
    }
    
    /**
     * Lấy tất cả customers với pagination
     */
    public List<Customer> getAllCustomers(int page, int pageSize) {
        List<Customer> customers = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT customer_id, customer_name, address, phone, email, is_delete " +
                     "FROM Customer WHERE is_delete = 0 ORDER BY customer_name " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Customer customer = new Customer();
                    customer.setCustomerId(rs.getInt("customer_id"));
                    customer.setCustomerName(rs.getString("customer_name"));
                    customer.setAddress(rs.getString("address"));
                    customer.setPhone(rs.getString("phone"));
                    customer.setEmail(rs.getString("email"));
                    customer.setIsDelete(rs.getInt("is_delete"));
                    customers.add(customer);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting customers with pagination: " + e.getMessage());
            e.printStackTrace();
        }
        return customers;
    }
    
    /**
     * Lấy tổng số customers
     */
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM Customer WHERE is_delete = 0";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy customer theo ID - METHOD MỚI THÊM CHO SALES ORDER
     */
    public Customer getCustomerById(int customerId) {
        String sql = "SELECT customer_id, customer_name, address, phone, email, is_delete " +
                     "FROM Customer WHERE customer_id = ? AND is_delete = 0";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer customer = new Customer();
                    customer.setCustomerId(rs.getInt("customer_id"));
                    customer.setCustomerName(rs.getString("customer_name"));
                    customer.setAddress(rs.getString("address"));
                    customer.setPhone(rs.getString("phone"));
                    customer.setEmail(rs.getString("email"));
                    customer.setIsDelete(rs.getInt("is_delete"));
                    return customer;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting customer by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Tìm kiếm customers theo tên
     */
    public List<Customer> searchCustomers(String searchTerm) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT customer_id, customer_name, address, phone, email, is_delete " +
                     "FROM Customer WHERE is_delete = 0 AND customer_name LIKE ? ORDER BY customer_name";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + searchTerm + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Customer customer = new Customer();
                    customer.setCustomerId(rs.getInt("customer_id"));
                    customer.setCustomerName(rs.getString("customer_name"));
                    customer.setAddress(rs.getString("address"));
                    customer.setPhone(rs.getString("phone"));
                    customer.setEmail(rs.getString("email"));
                    customer.setIsDelete(rs.getInt("is_delete"));
                    customers.add(customer);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching customers: " + e.getMessage());
            e.printStackTrace();
        }
        return customers;
    }
    
    /**
     * Tìm kiếm customers theo tên với pagination
     */
    public List<Customer> searchCustomers(String searchTerm, int page, int pageSize) {
        List<Customer> customers = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT customer_id, customer_name, address, phone, email, is_delete " +
                     "FROM Customer WHERE is_delete = 0 AND customer_name LIKE ? ORDER BY customer_name " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + searchTerm + "%");
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Customer customer = new Customer();
                    customer.setCustomerId(rs.getInt("customer_id"));
                    customer.setCustomerName(rs.getString("customer_name"));
                    customer.setAddress(rs.getString("address"));
                    customer.setPhone(rs.getString("phone"));
                    customer.setEmail(rs.getString("email"));
                    customer.setIsDelete(rs.getInt("is_delete"));
                    customers.add(customer);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching customers with pagination: " + e.getMessage());
            e.printStackTrace();
        }
        return customers;
    }
    
    /**
     * Lấy tổng số customers theo search term
     */
    public int getSearchCount(String searchTerm) {
        String sql = "SELECT COUNT(*) FROM Customer WHERE is_delete = 0 AND customer_name LIKE ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + searchTerm + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting search count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Thêm customer mới
     */
    public boolean addCustomer(Customer customer) {
        String sql = "INSERT INTO Customer (customer_name, address, phone, email, is_delete) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, customer.getCustomerName());
            ps.setString(2, customer.getAddress());
            ps.setString(3, customer.getPhone());
            ps.setString(4, customer.getEmail());
            ps.setInt(5, customer.getIsDelete());
            
            int rows = ps.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding customer: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật customer
     */
    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE Customer SET customer_name = ?, address = ?, phone = ?, email = ? WHERE customer_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, customer.getCustomerName());
            ps.setString(2, customer.getAddress());
            ps.setString(3, customer.getPhone());
            ps.setString(4, customer.getEmail());
            ps.setInt(5, customer.getCustomerId());
            
            int rows = ps.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating customer: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa customer (soft delete)
     */
    public boolean deleteCustomer(int customerId) {
        String sql = "UPDATE Customer SET is_delete = 1 WHERE customer_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            
            int rows = ps.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting customer: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra tên customer có tồn tại không
     */
    public boolean isNameExists(String customerName, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM Customer WHERE customer_name = ? AND is_delete = 0";
        if (excludeId != null) {
            sql += " AND customer_id != ?";
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, customerName);
            if (excludeId != null) {
                ps.setInt(2, excludeId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking name exists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra phone có tồn tại không
     */
    public boolean isPhoneExists(String phone, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM Customer WHERE phone = ? AND is_delete = 0";
        if (excludeId != null) {
            sql += " AND customer_id != ?";
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone);
            if (excludeId != null) {
                ps.setInt(2, excludeId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking phone exists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra email có tồn tại không
     */
    public boolean isEmailExists(String email, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM Customer WHERE email = ? AND is_delete = 0";
        if (excludeId != null) {
            sql += " AND customer_id != ?";
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            if (excludeId != null) {
                ps.setInt(2, excludeId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking email exists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra address có tồn tại không
     */
    public boolean isAddressExists(String address, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM Customer WHERE address = ? AND is_delete = 0";
        if (excludeId != null) {
            sql += " AND customer_id != ?";
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, address);
            if (excludeId != null) {
                ps.setInt(2, excludeId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking address exists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}