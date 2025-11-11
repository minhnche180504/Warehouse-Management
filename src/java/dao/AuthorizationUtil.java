package dao;

import model.User;

public class AuthorizationUtil {
    
    // Role Constants
    public static final String ROLE_ADMIN = "Admin";
    public static final String ROLE_WAREHOUSE_MANAGER = "Warehouse Manager"; 
    public static final String ROLE_SALES_STAFF = "Sales Staff";
    public static final String ROLE_WAREHOUSE_STAFF = "Warehouse Staff";
    
    // ================================ ROLE CHECKING ================================
    
    /**
     * Kiểm tra role của user với null-safe
     */
    private static boolean hasRole(User user, String roleName) {
        return user != null && user.getRole() != null && roleName.equals(user.getRole().getRoleName());
    }
    
    public static boolean isAdmin(User user) {
        return hasRole(user, ROLE_ADMIN);
    }
    
    public static boolean isWarehouseManager(User user) {
        return hasRole(user, ROLE_WAREHOUSE_MANAGER);
    }
    
    public static boolean isSalesStaff(User user) {
        return hasRole(user, ROLE_SALES_STAFF);
    }
    
    public static boolean isWarehouseStaff(User user) {
        return hasRole(user, ROLE_WAREHOUSE_STAFF);
    }
    
    // ================================ USER MANAGEMENT ================================
    
    /**
     * Quyền tạo user: Admin + Warehouse Manager
     */
    public static boolean canCreateUser(User currentUser) {
        return isAdmin(currentUser) || isWarehouseManager(currentUser);
    }
    
    /**
     * Quyền chỉnh sửa user: Admin (full), Warehouse Manager (không được edit Admin)
     */
    public static boolean canEditUser(User currentUser, User targetUser) {
        if (isAdmin(currentUser)) return true;
        if (isWarehouseManager(currentUser)) return !isAdmin(targetUser);
        return false;
    }
    
    /**
     * Quyền xóa user: tương tự edit user
     */
    public static boolean canDeleteUser(User currentUser, User targetUser) {
        return canEditUser(currentUser, targetUser);
    }
    
    /**
     * Quyền xem danh sách users: tất cả user đăng nhập
     */
    public static boolean canViewUsers(User currentUser) {
        return currentUser != null;
    }
    
    // ================================ WAREHOUSE MANAGEMENT ================================
    
    /**
     * Quyền quản lý warehouse: Admin + Warehouse Manager
     */
    public static boolean canManageWarehouse(User currentUser) {
        return isAdmin(currentUser) || isWarehouseManager(currentUser);
    }
    
    /**
     * Quyền quản lý inventory: Admin + Warehouse Manager + Warehouse Staff
     */
    public static boolean canManageInventory(User currentUser) {
        return isAdmin(currentUser) || isWarehouseManager(currentUser) || isWarehouseStaff(currentUser);
    }
    
    // ================================ SALES MANAGEMENT ================================
    
    /**
     * Quyền quản lý sales: Admin + Sales Staff
     */
    public static boolean canManageSales(User currentUser) {
        return isAdmin(currentUser) || isSalesStaff(currentUser);
    }
    
    // ================================ VIEWING PERMISSIONS ================================
    
    /**
     * Quyền xem inventory/sales: tất cả user đăng nhập
     */
    public static boolean canViewInventory(User currentUser) {
        return currentUser != null;
    }
    
    public static boolean canViewSales(User currentUser) {
        return currentUser != null;
    }
    
    /**
     * Quyền xem reports: Admin + Warehouse Manager
     */
    public static boolean canViewReports(User currentUser) {
        return isAdmin(currentUser) || isWarehouseManager(currentUser);
    }
    
    // ================================ SYSTEM ADMINISTRATION ================================
    
    /**
     * Quyền system settings: chỉ Admin
     */
    public static boolean canAccessSystemSettings(User currentUser) {
        return isAdmin(currentUser);
    }
}