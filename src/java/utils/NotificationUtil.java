package utils;

/**
 * Utility class for sending notifications
 * Supports both WebSocket (real-time) and email notifications
 */
public class NotificationUtil {
    
    private static final LoggerUtil.Logger logger = LoggerUtil.getLogger(NotificationUtil.class);
    
    /**
     * Send real-time notification via WebSocket
     */
    public static void sendRealtimeNotification(int userId, String message, String type) {
        try {
            String notificationJson = String.format(
                "{\"userId\":%d,\"message\":\"%s\",\"type\":\"%s\",\"timestamp\":\"%s\"}",
                userId, message, type, java.time.LocalDateTime.now().toString()
            );
            WebSocketNotification.sendToUser(String.valueOf(userId), notificationJson);
            logger.info("Real-time notification sent to user: {}", userId);
        } catch (Exception e) {
            logger.error("Error sending real-time notification", e);
        }
    }
    
    /**
     * Send notification via email
     */
    public static void sendEmailNotification(String email, String subject, String message) {
        try {
            // Use existing SendMailOK class
            String smtpServer = "smtp.gmail.com";
            String fromEmail = System.getenv("SMTP_FROM_EMAIL");
            String fromPassword = System.getenv("SMTP_FROM_PASSWORD");
            
            if (fromEmail != null && fromPassword != null) {
                model.SendMailOK.send(smtpServer, email, fromEmail, fromPassword, subject, message);
                logger.info("Email notification sent to: {}", email);
            } else {
                logger.warn("SMTP credentials not configured, skipping email notification");
            }
        } catch (Exception e) {
            logger.error("Error sending email notification", e);
        }
    }
    
    /**
     * Send notification via both WebSocket and Email
     */
    public static void sendNotification(int userId, String email, String subject, String message, String type) {
        sendRealtimeNotification(userId, message, type);
        if (email != null && !email.isEmpty()) {
            sendEmailNotification(email, subject, message);
        }
    }
}

