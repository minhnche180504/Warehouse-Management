/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import model.Role;
import model.User;
import java.sql.SQLException;

/**
 *
 * @author Nguyen Duc Thinh
 */
public class UserDAO extends DBConnect {

    private DBConnect dbConnect;

    public UserDAO() {
        this.dbConnect = new DBConnect();
    }

    private Connection getConnection() {
        return dbConnect.connection;
    }

    public User login(String username, String password) {
        String sql = "SELECT u.*, r.role_name, w.warehouse_name FROM [User] u "
                + "JOIN Role r ON u.role_id = r.role_id "
                + "LEFT JOIN Warehouse w ON u.warehouse_id = w.warehouse_id "
                + "WHERE u.username = ? AND u.password = ?";
        
        System.out.println("Attempting login for username: " + username);
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setGender(rs.getString("gender"));
                    user.setAddress(rs.getString("address"));
                    user.setEmail(rs.getString("email"));
                    user.setDateOfBirth(rs.getDate("date_of_birth"));
                    user.setProfilePic(rs.getString("profile_pic"));
                    int warehouseId = rs.getInt("warehouse_id");
                    if (!rs.wasNull()) {
                        user.setWarehouseId(warehouseId);
                    }
                    Role role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    user.setRole(role);
                    user.setWarehouseName(rs.getString("warehouse_name"));
                    
                    System.out.println("Login successful for user: " + user.getFirstName() + " " + user.getLastName());
                    return user;
                } else {
                    System.out.println("No user found with username: " + username);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in login: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    public boolean updatePasswordByEmail(String email, String newPassword) {
        String sql = "UPDATE [User] SET password = ? WHERE email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;  // true nếu có cập nhật thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Kiểm tra email có tồn tại trong database hay không
     *
     * @param email email cần kiểm tra
     * @return true nếu tồn tại, false nếu không
     */
    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM [User] WHERE email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // Nếu có dòng nào tức là email tồn tại
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Lỗi hoặc không tìm thấy
    }

    public boolean existsUsername(String username) {
        String sql = "SELECT 1 FROM [User] WHERE username = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // Nếu có dòng nào => tồn tại
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thêm user mới vào database
     *
     * @param user
     * @return true nếu insert thành công, false nếu lỗi
     */
    public boolean insertUser(User user) {
        String sql = "INSERT INTO [User] (username, password, first_name, last_name, role_id, gender, address, email, date_of_birth, profile_pic) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getFirstName());
            stmt.setString(4, user.getLastName());
            stmt.setInt(5, user.getRoleId());
            stmt.setString(6, user.getGender());
            stmt.setString(7, user.getAddress());
            stmt.setString(8, user.getEmail());
            if (user.getDateOfBirth() != null) {
                stmt.setDate(9, new java.sql.Date(user.getDateOfBirth().getTime()));
            } else {
                stmt.setDate(9, null);
            }
            stmt.setString(10, user.getProfilePic());

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name, w.warehouse_name FROM [User] u "
                + "JOIN Role r ON u.role_id = r.role_id "
                + "LEFT JOIN Warehouse w ON u.warehouse_id = w.warehouse_id "
                + "ORDER BY u.username ASC";

        try (PreparedStatement ps = getConnection().prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setRoleId(rs.getInt("role_id"));
                user.setGender(rs.getString("gender"));
                user.setAddress(rs.getString("address"));
                user.setEmail(rs.getString("email"));
                user.setDateOfBirth(rs.getDate("date_of_birth"));
                user.setProfilePic(rs.getString("profile_pic"));
                int warehouseId = rs.getInt("warehouse_id");
                if (!rs.wasNull()) {
                    user.setWarehouseId(warehouseId);
                }
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                user.setRole(role);
                user.setWarehouseName(rs.getString("warehouse_name"));

                userList.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all users: " + e.getMessage());
            e.printStackTrace();
        }

        return userList;
    }

    public User getUserById(Integer userId) {
        String sql = "SELECT u.user_id, u.username, u.password, u.first_name, u.last_name, u.role_id, u.gender, u.address, u.email, u.date_of_birth, u.profile_pic, r.role_name "
                + "FROM dbo.[User] u "
                + "JOIN dbo.Role r ON u.role_id = r.role_id "
                + "WHERE u.user_id = ?";

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setGender(rs.getString("gender"));
                    user.setAddress(rs.getString("address"));
                    user.setEmail(rs.getString("email"));
                    user.setDateOfBirth(rs.getDate("date_of_birth"));
                    user.setProfilePic(rs.getString("profile_pic"));

                    Role role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    user.setRole(role);

                    return user;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting user by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public static void main(String[] args) {
        // Thiết lập kết nối cơ sở dữ liệu

        UserDAO userDAO = new UserDAO();
        // Test case 1: Đăng nhập thành công
        System.out.println("Test case 1: Đăng nhập với username=john_doe, password=password123");
        User user = userDAO.login("admin01", "admin123");
        if (user != null) {
            System.out.println("Đăng nhập thành công!");
            System.out.println("Thông tin user: " + user);
        } else {
            System.out.println("Đăng nhập thất bại: Username hoặc password không đúng");
        }
        // Test case 2: Đăng nhập thất bại (password sai)
        System.out.println("\nTest case 2: Đăng nhập với username=john_doe, password=wrongpassword");
        user = userDAO.login("john_doe", "wrongpassword");
        if (user != null) {
            System.out.println("Đăng nhập thành công!");
            System.out.println("Thông tin user: " + user);
        } else {
            System.out.println("Đăng nhập thất bại: Username hoặc password không đúng");
        }
        // Test case 3: Đăng nhập thất bại (username không tồn tại)
        System.out.println("\nTest case 3: Đăng nhập với username=non_existent, password=password123");
        user = userDAO.login("non_existent", "password123");
        if (user != null) {
            System.out.println("Đăng nhập thành công!");
            System.out.println("Thông tin user: " + user);
        } else {
            System.out.println("Đăng nhập thất bại: Username hoặc password không đúng");
        }
    }
}
