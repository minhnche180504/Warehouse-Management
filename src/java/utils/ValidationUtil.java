package utils;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Utility class for input validation
 */
public class ValidationUtil {
    
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    );
    
    private static final Pattern PHONE_PATTERN = Pattern.compile(
        "^0[0-9]{9}$"
    );
    
    private static final Pattern USERNAME_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9_]{3,20}$"
    );
    
    /**
     * Validate email format
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }
    
    /**
     * Validate phone number (Vietnamese format: 10 digits starting with 0)
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        // Remove all non-digit characters
        String digitsOnly = phone.replaceAll("[^0-9]", "");
        return PHONE_PATTERN.matcher(digitsOnly).matches();
    }
    
    /**
     * Validate username
     */
    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        return USERNAME_PATTERN.matcher(username.trim()).matches();
    }
    
    /**
     * Validate required field
     */
    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }
    
    /**
     * Validate string length
     */
    public static boolean isValidLength(String value, int min, int max) {
        if (value == null) return false;
        int length = value.trim().length();
        return length >= min && length <= max;
    }
    
    /**
     * Validate number range
     */
    public static boolean isInRange(int value, int min, int max) {
        return value >= min && value <= max;
    }
    
    /**
     * Validate positive number
     */
    public static boolean isPositive(int value) {
        return value > 0;
    }
    
    /**
     * Validate positive number (double)
     */
    public static boolean isPositive(double value) {
        return value > 0;
    }
    
    /**
     * Sanitize string to prevent XSS
     */
    public static String sanitize(String input) {
        if (input == null) return null;
        return input.trim()
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#x27;")
                   .replace("/", "&#x2F;");
    }
    
    /**
     * Validate multiple fields and return list of errors
     */
    public static class ValidationResult {
        private List<String> errors = new ArrayList<>();
        
        public void addError(String field, String message) {
            errors.add(field + ": " + message);
        }
        
        public void addError(String message) {
            errors.add(message);
        }
        
        public boolean isValid() {
            return errors.isEmpty();
        }
        
        public List<String> getErrors() {
            return new ArrayList<>(errors);
        }
        
        public String getErrorMessage() {
            return String.join(", ", errors);
        }
    }
}

