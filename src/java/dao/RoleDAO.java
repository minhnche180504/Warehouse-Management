package dao;

import model.Role;
import utils.LoggerUtil;
import utils.CacheManager;
import exception.DatabaseException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for Role with caching support
 */
public class RoleDAO extends DBConnect {
    
    private static final LoggerUtil.Logger logger = LoggerUtil.getLogger(RoleDAO.class);
    private static final String CACHE_KEY_ALL_ROLES = "roles.all";
    private static final long CACHE_TTL = 3600; // 1 hour
    
    /**
     * Get all roles with caching
     */
    public List<Role> getAllRoles() {
        // Try cache first
        List<Role> cachedRoles = CacheManager.get(CACHE_KEY_ALL_ROLES);
        if (cachedRoles != null) {
            logger.debug("Roles retrieved from cache");
            return cachedRoles;
        }
        
        // If not in cache, query database
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM Role ORDER BY role_id";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                roles.add(role);
            }
            
            // Cache the result
            CacheManager.put(CACHE_KEY_ALL_ROLES, roles, CACHE_TTL);
            logger.info("Retrieved {} roles from database and cached", roles.size());
            
        } catch (SQLException e) {
            logger.error("Error getting all roles", e);
            throw new DatabaseException("Error getting all roles", e);
        }
        
        return roles;
    }
    
    /**
     * Get role by ID
     */
    public Role getRoleById(int roleId) {
        String cacheKey = "role." + roleId;
        Role cachedRole = CacheManager.get(cacheKey);
        if (cachedRole != null) {
            logger.debug("Role {} retrieved from cache", roleId);
            return cachedRole;
        }
        
        String sql = "SELECT * FROM Role WHERE role_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Role role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    
                    CacheManager.put(cacheKey, role, CACHE_TTL);
                    return role;
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting role by ID: {}", roleId, e);
            throw new DatabaseException("Error getting role by ID", e);
        }
        
        return null;
    }
    
    /**
     * Clear role cache (call this when roles are updated)
     */
    public static void clearCache() {
        CacheManager.remove(CACHE_KEY_ALL_ROLES);
        logger.info("Role cache cleared");
    }
}
