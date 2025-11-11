package dao;

import model.Role;
import model.User;
import dao.DBConnect;
import utils.LoggerUtil;
import exception.DatabaseException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO2 {
    private static final LoggerUtil.Logger logger = LoggerUtil.getLogger(UserDAO2.class);
    private DBConnect dbConnect;
    
    public UserDAO2() {
        dbConnect = new DBConnect();
    }
    
    /**
     * Find user by username and password regardless of status
     */
    public User findUserByUsernameAndPassword(String username, String password) {
        String sql = "SELECT u.*, r.role_name, w.warehouse_name FROM [User] u "
                + "JOIN Role r ON u.role_id = r.role_id "
                + "LEFT JOIN Warehouse w ON u.warehouse_id = w.warehouse_id "
                + "WHERE u.username = ? AND u.password = ?";
        
        logger.debug("Attempting to find user for username: {}", username);
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = mapResultSetToUser(rs);
                    logger.info("User found: {} (ID: {})", user.getFullName(), user.getUserId());
                    return user;
                } else {
                    logger.warn("User not found: {}", username);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding user: {}", username, e);
            throw new DatabaseException("Error finding user", e);
        }
        
        return null;
    }
    
    /**
     * Find user by username OR email and password
     */
    public User findUserByUsernameOrEmailAndPassword(String usernameOrEmail, String password) {
        String sql = "SELECT u.*, r.role_name, w.warehouse_name FROM [User] u "
                + "JOIN Role r ON u.role_id = r.role_id "
                + "LEFT JOIN Warehouse w ON u.warehouse_id = w.warehouse_id "
                + "WHERE (u.username = ? OR u.email = ?) AND u.password = ?";
        
        logger.debug("Attempting to find user for username/email: {}", usernameOrEmail);
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql)) {
            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            ps.setString(3, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = mapResultSetToUser(rs);
                    logger.info("User found: {} (ID: {})", user.getFullName(), user.getUserId());
                    return user;
                } else {
                    logger.warn("User not found: {}", usernameOrEmail);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding user: {}", usernameOrEmail, e);
            throw new DatabaseException("Error finding user", e);
        }
        
        return null;
    }
    
    /**
     * Find user by email
     */
    public User findUserByEmail(String email) {
        String sql = "SELECT u.*, r.role_name, w.warehouse_name FROM [User] u "
                + "JOIN Role r ON u.role_id = r.role_id "
                + "LEFT JOIN Warehouse w ON u.warehouse_id = w.warehouse_id "
                + "WHERE u.email = ?";
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql)) {
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error finding user by email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Login method - Only allow active users to login
     */
    public User login(String username, String password) {
        User user = findUserByUsernameAndPassword(username, password);
        if (user != null && "Active".equalsIgnoreCase(user.getStatus())) {
            System.out.println("Login successful for user: " + user.getFullName());
            return user;
        }
        System.out.println("Login failed - user not active or not found: " + username);
        return null;
    }
    
    /**
     * Get all users (both active and inactive) for admin view
     */
    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name, w.warehouse_name FROM [User] u "
                + "JOIN Role r ON u.role_id = r.role_id "
                + "LEFT JOIN Warehouse w ON u.warehouse_id = w.warehouse_id "
                + "ORDER BY CASE WHEN u.status = 'Active' THEN 1 ELSE 0 END DESC, u.username ASC";
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                userList.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all users: " + e.getMessage());
        }
        
        return userList;
    }
    
    /**
     * Get only active users
     */
    public List<User> getActiveUsers() {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name, w.warehouse_name FROM [User] u "
                + "JOIN Role r ON u.role_id = r.role_id "
                + "LEFT JOIN Warehouse w ON u.warehouse_id = w.warehouse_id "
                + "WHERE u.status = 'Active' "
                + "ORDER BY u.username ASC";
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                userList.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error getting active users: " + e.getMessage());
        }
        
        return userList;
    }
    
    /**
     * Get user by ID (regardless of active status)
     */
    public User getUserById(int userId) {
        String sql = "SELECT u.*, r.role_name, w.warehouse_name FROM [User] u "
                + "JOIN Role r ON u.role_id = r.role_id "
                + "LEFT JOIN Warehouse w ON u.warehouse_id = w.warehouse_id "
                + "WHERE u.user_id = ?";
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting user by ID: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Add new user (always active by default) - FIXED: Now includes warehouse_id
     */
    public boolean addUser(User user) {
        String sql = "INSERT INTO [User] (username, password, first_name, last_name, role_id, gender, address, email, date_of_birth, profile_pic, status, warehouse_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Active', ?)";
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFirstName());
            ps.setString(4, user.getLastName());
            ps.setInt(5, user.getRoleId());
            ps.setString(6, user.getGender());
            ps.setString(7, user.getAddress());
            ps.setString(8, user.getEmail());
            ps.setDate(9, user.getDateOfBirth());
            ps.setString(10, user.getProfilePic());
            
            // NEW: Handle warehouse_id (can be null)
            if (user.getWarehouseId() != null) {
                ps.setInt(11, user.getWarehouseId());
            } else {
                ps.setNull(11, java.sql.Types.INTEGER);
            }
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("User added successfully: " + user.getUsername() + 
                             (user.getWarehouseId() != null ? " with warehouse_id: " + user.getWarehouseId() : " without warehouse"));
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("Error adding user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update user information (FIXED: Now properly handles warehouse_id)
     */
    public boolean changeUser(User user) {
        String sql = "UPDATE [User] SET first_name = ?, last_name = ?, gender = ?, email = ?, "
                   + "date_of_birth = ?, address = ?, profile_pic = ?, warehouse_id = ? WHERE user_id = ?";

        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql)) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getGender());
            ps.setString(4, user.getEmail());
            ps.setDate(5, user.getDateOfBirth());
            ps.setString(6, user.getAddress());
            ps.setString(7, user.getProfilePic());
            
            // Handle warehouse_id (can be null)
            if (user.getWarehouseId() != null) {
                ps.setInt(8, user.getWarehouseId());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }
            
            ps.setInt(9, user.getUserId());

            int rowsAffected = ps.executeUpdate();
            System.out.println("User updated successfully: " + user.getUserId() + 
                             (user.getWarehouseId() != null ? " with warehouse_id: " + user.getWarehouseId() : " warehouse cleared"));
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * SOFT DELETE: Deactivate user instead of deleting
     */
    public boolean deactivateUser(int userId) {
        String sql = "UPDATE [User] SET status = 'Deactive' WHERE user_id = ?";
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("User deactivated successfully: " + userId);
                return true;
            }
            
        } catch (SQLException e) {
            System.out.println("Error deactivating user: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * ACTIVATE: Reactivate user
     */
    public boolean activateUser(int userId) {
        String sql = "UPDATE [User] SET status = 'Active' WHERE user_id = ?";
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("User activated successfully: " + userId);
                return true;
            }
            
        } catch (SQLException e) {
            System.out.println("Error activating user: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Toggle user status (active <-> inactive)
     */
    public boolean toggleUserStatus(int userId) {
        String sql = "UPDATE [User] SET status = CASE WHEN status = 'Active' THEN 'Deactive' ELSE 'Active' END WHERE user_id = ?";
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("User status toggled successfully: " + userId);
                return true;
            }
            
        } catch (SQLException e) {
            System.out.println("Error toggling user status: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Check if user is active
     */
    public boolean isUserActive(int userId) {
        String sql = "SELECT status FROM [User] WHERE user_id = ?";
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return "Active".equals(rs.getString("status"));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error checking user active status: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Change password (only for active users)
     */
    public boolean changePassword(int userId, String newPassword) {
        String sql = "UPDATE [User] SET password = ? WHERE user_id = ? AND status = 'Active'";
        try (PreparedStatement st = dbConnect.connection.prepareStatement(sql)) {
            st.setString(1, newPassword);
            st.setInt(2, userId);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating password: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * DEPRECATED: Keep for backward compatibility but mark as deprecated
     * @deprecated Use deactivateUser() instead for soft delete
     */
    @Deprecated
    public boolean deleteUser(int userId) {
        System.out.println("Warning: deleteUser() is deprecated. Using deactivateUser() instead.");
        return deactivateUser(userId);
    }
    
    /**
     * Helper method to map ResultSet to User object
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
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
        user.setStatus(rs.getString("status")); // Map status field
        
        // Map Role information
        Role role = new Role();
        role.setRoleId(rs.getInt("role_id"));
        role.setRoleName(rs.getString("role_name"));
        user.setRole(role);
        
        // Map warehouse_id and warehouse_name (FIXED: Handle NULL values properly)
        // Dùng getObject để xử lý trường hợp warehouse_id có thể là NULL
        Object warehouseIdObj = rs.getObject("warehouse_id");
        if (warehouseIdObj != null) {
            user.setWarehouseId((Integer) warehouseIdObj);
        } else {
            user.setWarehouseId(null);
        }
        
        // Handle warehouse_name (can be null if user has no warehouse assigned)
        String warehouseName = rs.getString("warehouse_name");
        user.setWarehouseName(warehouseName);
        
        return user;
    }
}