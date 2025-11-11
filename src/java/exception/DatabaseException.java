package exception;

/**
 * Exception for database-related errors
 */
public class DatabaseException extends BusinessException {
    
    public DatabaseException(String message) {
        super(message);
    }
    
    public DatabaseException(String message, Throwable cause) {
        super(message, cause);
    }
    
    public DatabaseException(String errorCode, String message, Throwable cause) {
        super(errorCode, message, cause);
    }
}

