package utils;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Simple in-memory cache manager
 * For caching static data like roles, units, warehouses
 */
public class CacheManager {
    
    private static final LoggerUtil.Logger logger = LoggerUtil.getLogger(CacheManager.class);
    private static final Map<String, CacheEntry> cache = new ConcurrentHashMap<>();
    private static final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
    private static final long DEFAULT_TTL = 3600; // 1 hour in seconds
    
    static {
        // Cleanup expired entries every 5 minutes
        scheduler.scheduleAtFixedRate(CacheManager::cleanup, 5, 5, TimeUnit.MINUTES);
    }
    
    /**
     * Cache entry with expiration time
     */
    private static class CacheEntry {
        private final Object value;
        private final long expirationTime;
        
        public CacheEntry(Object value, long ttlSeconds) {
            this.value = value;
            this.expirationTime = System.currentTimeMillis() + (ttlSeconds * 1000);
        }
        
        public boolean isExpired() {
            return System.currentTimeMillis() > expirationTime;
        }
        
        public Object getValue() {
            return value;
        }
    }
    
    /**
     * Put value in cache with default TTL
     */
    public static void put(String key, Object value) {
        put(key, value, DEFAULT_TTL);
    }
    
    /**
     * Put value in cache with custom TTL (in seconds)
     */
    public static void put(String key, Object value, long ttlSeconds) {
        cache.put(key, new CacheEntry(value, ttlSeconds));
        logger.debug("Cached: {} (TTL: {}s)", key, ttlSeconds);
    }
    
    /**
     * Get value from cache
     */
    @SuppressWarnings("unchecked")
    public static <T> T get(String key) {
        CacheEntry entry = cache.get(key);
        if (entry == null) {
            logger.debug("Cache miss: {}", key);
            return null;
        }
        
        if (entry.isExpired()) {
            cache.remove(key);
            logger.debug("Cache expired: {}", key);
            return null;
        }
        
        logger.debug("Cache hit: {}", key);
        return (T) entry.getValue();
    }
    
    /**
     * Remove value from cache
     */
    public static void remove(String key) {
        cache.remove(key);
        logger.debug("Cache removed: {}", key);
    }
    
    /**
     * Clear all cache
     */
    public static void clear() {
        cache.clear();
        logger.info("Cache cleared");
    }
    
    /**
     * Remove expired entries
     */
    private static void cleanup() {
        cache.entrySet().removeIf(entry -> entry.getValue().isExpired());
    }
    
    /**
     * Get cache size
     */
    public static int size() {
        return cache.size();
    }
    
    /**
     * Check if key exists and is not expired
     */
    public static boolean contains(String key) {
        CacheEntry entry = cache.get(key);
        return entry != null && !entry.isExpired();
    }
}

