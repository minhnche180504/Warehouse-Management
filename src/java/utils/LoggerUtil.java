package utils;

// TODO: Uncomment after adding SLF4J JAR files to lib/
// import org.slf4j.Logger;
// import org.slf4j.LoggerFactory;

/**
 * Utility class for logging
 * Provides convenient methods for logging throughout the application
 * 
 * NOTE: Requires SLF4J JAR files:
 * - slf4j-api-2.0.9.jar
 * - logback-classic-1.4.14.jar
 * - logback-core-1.4.14.jar
 * 
 * After adding JAR files, uncomment imports above and use LoggerFactory.getLogger()
 */
public class LoggerUtil {
    
    /**
     * Get logger for a class
     * Temporary implementation using System.out until SLF4J is added
     */
    public static Logger getLogger(Class<?> clazz) {
        // TODO: Replace with LoggerFactory.getLogger(clazz) after adding SLF4J
        return new Logger(clazz.getName());
    }
    
    /**
     * Get logger for audit logging
     */
    public static Logger getAuditLogger() {
        // TODO: Replace with LoggerFactory.getLogger("audit") after adding SLF4J
        return new Logger("audit");
    }
    
    /**
     * Temporary Logger class until SLF4J is added
     */
    public static class Logger {
        private String name;
        
        public Logger(String name) {
            this.name = name;
        }
        
        public void debug(String message, Object... args) {
            System.out.println("[DEBUG] " + name + ": " + format(message, args));
        }
        
        public void info(String message, Object... args) {
            System.out.println("[INFO] " + name + ": " + format(message, args));
        }
        
        public void warn(String message, Object... args) {
            System.out.println("[WARN] " + name + ": " + format(message, args));
        }
        
        public void error(String message, Object... args) {
            System.err.println("[ERROR] " + name + ": " + format(message, args));
        }
        
        public void error(String message, Throwable throwable) {
            System.err.println("[ERROR] " + name + ": " + message);
            throwable.printStackTrace();
        }
        
        private String format(String message, Object... args) {
            if (args == null || args.length == 0) {
                return message;
            }
            String result = message;
            for (Object arg : args) {
                result = result.replaceFirst("\\{\\}", String.valueOf(arg));
            }
            return result;
        }
    }
}

