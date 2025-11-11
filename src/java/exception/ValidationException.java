package exception;

/**
 * Exception for validation errors
 */
public class ValidationException extends BusinessException {
    
    private String fieldName;
    
    public ValidationException(String message) {
        super(message);
    }
    
    public ValidationException(String fieldName, String message) {
        super(message);
        this.fieldName = fieldName;
    }
    
    public ValidationException(String fieldName, String message, Throwable cause) {
        super(message, cause);
        this.fieldName = fieldName;
    }
    
    public String getFieldName() {
        return fieldName;
    }
}

