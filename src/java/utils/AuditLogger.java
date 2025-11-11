package utils;

import utils.LoggerUtil;
import model.User;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Utility class for audit logging
 * Logs all important actions in the system for compliance and security
 */
public class AuditLogger {
    
    private static final LoggerUtil.Logger auditLogger = LoggerUtil.getAuditLogger();
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    
    /**
     * Log user login
     */
    public static void logLogin(User user, String ipAddress) {
        auditLogger.info("LOGIN|User: {}|Email: {}|Role: {}|IP: {}|Time: {}", 
            user.getUsername(), 
            user.getEmail(), 
            user.getRole() != null ? user.getRole().getRoleName() : "N/A",
            ipAddress,
            LocalDateTime.now().format(formatter));
    }
    
    /**
     * Log user logout
     */
    public static void logLogout(User user, String ipAddress) {
        auditLogger.info("LOGOUT|User: {}|Email: {}|IP: {}|Time: {}", 
            user.getUsername(), 
            user.getEmail(),
            ipAddress,
            LocalDateTime.now().format(formatter));
    }
    
    /**
     * Log data creation
     */
    public static void logCreate(String entityType, int entityId, User user, String details) {
        auditLogger.info("CREATE|Entity: {}|ID: {}|User: {}|Details: {}|Time: {}", 
            entityType, 
            entityId, 
            user.getUsername(),
            details,
            LocalDateTime.now().format(formatter));
    }
    
    /**
     * Log data update
     */
    public static void logUpdate(String entityType, int entityId, User user, String details) {
        auditLogger.info("UPDATE|Entity: {}|ID: {}|User: {}|Details: {}|Time: {}", 
            entityType, 
            entityId, 
            user.getUsername(),
            details,
            LocalDateTime.now().format(formatter));
    }
    
    /**
     * Log data deletion
     */
    public static void logDelete(String entityType, int entityId, User user, String details) {
        auditLogger.warn("DELETE|Entity: {}|ID: {}|User: {}|Details: {}|Time: {}", 
            entityType, 
            entityId, 
            user.getUsername(),
            details,
            LocalDateTime.now().format(formatter));
    }
    
    /**
     * Log sensitive operations
     */
    public static void logSensitiveOperation(String operation, User user, String details) {
        auditLogger.warn("SENSITIVE|Operation: {}|User: {}|Details: {}|Time: {}", 
            operation, 
            user.getUsername(),
            details,
            LocalDateTime.now().format(formatter));
    }
    
    /**
     * Log access denied
     */
    public static void logAccessDenied(User user, String resource, String reason) {
        auditLogger.warn("ACCESS_DENIED|User: {}|Resource: {}|Reason: {}|Time: {}", 
            user.getUsername(), 
            resource,
            reason,
            LocalDateTime.now().format(formatter));
    }
    
    /**
     * Log custom audit event
     */
    public static void logEvent(String eventType, User user, String details) {
        auditLogger.info("EVENT|Type: {}|User: {}|Details: {}|Time: {}", 
            eventType, 
            user.getUsername(),
            details,
            LocalDateTime.now().format(formatter));
    }
}

