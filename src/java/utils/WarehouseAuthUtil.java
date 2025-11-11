package utils;

import model.User;

/**
 * Utility class để xử lý phân quyền theo warehouse
 * Đảm bảo user chỉ được truy cập dữ liệu của kho được phân công
 */
public class WarehouseAuthUtil {
    
    /**
     * Lấy warehouse_id mà user được phép truy cập
     * @param currentUser User hiện tại
     * @return warehouse_id nếu user bị giới hạn theo kho, null nếu có toàn quyền
     */
    public static Integer getUserWarehouseId(User currentUser) {
        if (currentUser == null) {
            return null;
        }
        
        // Admin có thể truy cập tất cả warehouse
        if (isAdmin(currentUser)) {
            return null; // null = no restriction
        }
        
        // Các role khác chỉ được truy cập warehouse được gán
        return currentUser.getWarehouseId();
    }
    
    /**
     * Kiểm tra user có quyền truy cập warehouse cụ thể không
     * @param currentUser User hiện tại
     * @param warehouseId ID warehouse cần kiểm tra
     * @return true nếu được phép truy cập
     */
    public static boolean canAccessWarehouse(User currentUser, Integer warehouseId) {
        if (currentUser == null || warehouseId == null) {
            return false;
        }
        
        // Admin có thể truy cập tất cả
        if (isAdmin(currentUser)) {
            return true;
        }
        
        // User khác chỉ truy cập được warehouse được gán
        Integer userWarehouseId = currentUser.getWarehouseId();
        return userWarehouseId != null && userWarehouseId.equals(warehouseId);
    }
    
    /**
     * Tạo WHERE clause cho SQL query để filter theo warehouse
     * @param currentUser User hiện tại
     * @param tableAlias Alias của table trong SQL (ví dụ: "so", "i")
     * @return String WHERE clause (không bao gồm WHERE keyword)
     */
    public static String getWarehouseWhereClause(User currentUser, String tableAlias) {
        Integer warehouseId = getUserWarehouseId(currentUser);
        if (warehouseId == null) {
            return ""; // Admin - không filter
        }
        
        String columnName = tableAlias != null && !tableAlias.isEmpty() 
            ? tableAlias + ".warehouse_id" 
            : "warehouse_id";
            
        return columnName + " = " + warehouseId;
    }
    
    /**
     * Kiểm tra user có phải Admin không
     */
    private static boolean isAdmin(User user) {
        return user != null && user.getRole() != null && 
               "Admin".equals(user.getRole().getRoleName());
    }
    
    /**
     * Lấy warehouse_id để insert vào các bảng mới
     * @param currentUser User hiện tại
     * @return warehouse_id để sử dụng, null nếu chưa xác định
     */
    public static Integer getDefaultWarehouseId(User currentUser) {
        if (currentUser == null) {
            return null;
        }
        
        // Trả về warehouse được gán cho user
        return currentUser.getWarehouseId();
    }
    
    /**
     * Filter danh sách warehouse mà user được phép chọn
     * @param currentUser User hiện tại
     * @param allWarehouses Danh sách tất cả warehouse
     * @return Danh sách warehouse được phép truy cập
     */
    public static java.util.List<model.WarehouseDisplay> filterAllowedWarehouses(
            User currentUser, java.util.List<model.WarehouseDisplay> allWarehouses) {
        
        if (currentUser == null || allWarehouses == null) {
            return new java.util.ArrayList<>();
        }
        
        // Admin có thể thấy tất cả warehouse
        if (isAdmin(currentUser)) {
            return allWarehouses;
        }
        
        // User khác chỉ thấy warehouse được gán
        Integer userWarehouseId = currentUser.getWarehouseId();
        if (userWarehouseId == null) {
            return new java.util.ArrayList<>();
        }
        
        return allWarehouses.stream()
            .filter(w -> w.getWarehouseId() == userWarehouseId.intValue())
            .collect(java.util.stream.Collectors.toList());
    }
}