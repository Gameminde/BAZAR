package com.bazar.marketplace.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * Advanced Cache Service
 * Provides enterprise-grade caching strategies and operations
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class CacheService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final RedisTemplate<String, String> stringRedisTemplate;

    // Cache key prefixes
    private static final String USER_CACHE_PREFIX = "bazar:user:";
    private static final String PRODUCT_CACHE_PREFIX = "bazar:product:";
    private static final String CATEGORY_CACHE_PREFIX = "bazar:category:";
    private static final String CART_CACHE_PREFIX = "bazar:cart:";
    private static final String SESSION_CACHE_PREFIX = "bazar:session:";
    private static final String SEARCH_CACHE_PREFIX = "bazar:search:";

    // Lua script for atomic operations
    private static final String CACHE_WITH_LOCK_SCRIPT = 
        "local key = KEYS[1] " +
        "local lock_key = KEYS[2] " +
        "local value = ARGV[1] " +
        "local ttl = tonumber(ARGV[2]) " +
        "local lock_ttl = tonumber(ARGV[3]) " +
        
        // Try to acquire lock
        "if redis.call('SET', lock_key, '1', 'NX', 'EX', lock_ttl) then " +
        "  redis.call('SETEX', key, ttl, value) " +
        "  redis.call('DEL', lock_key) " +
        "  return 1 " +
        "else " +
        "  return 0 " +
        "end";

    private final DefaultRedisScript<Long> cacheWithLockScript = 
        new DefaultRedisScript<>(CACHE_WITH_LOCK_SCRIPT, Long.class);

    /**
     * Cache user data with optimized TTL
     */
    public void cacheUser(Long userId, Object userData) {
        String key = USER_CACHE_PREFIX + userId;
        redisTemplate.opsForValue().set(key, userData, Duration.ofHours(1));
        log.debug("Cached user data: {}", userId);
    }

    /**
     * Get cached user data
     */
    public Optional<Object> getCachedUser(Long userId) {
        String key = USER_CACHE_PREFIX + userId;
        Object cachedData = redisTemplate.opsForValue().get(key);
        
        if (cachedData != null) {
            // Refresh TTL on access (sliding expiration)
            redisTemplate.expire(key, Duration.ofHours(1));
            log.debug("Cache hit for user: {}", userId);
        } else {
            log.debug("Cache miss for user: {}", userId);
        }
        
        return Optional.ofNullable(cachedData);
    }

    /**
     * Cache product data with smart invalidation
     */
    public void cacheProduct(Long productId, Object productData) {
        String key = PRODUCT_CACHE_PREFIX + productId;
        
        // Cache for 30 minutes with background refresh
        redisTemplate.opsForValue().set(key, productData, Duration.ofMinutes(30));
        
        // Add to product index for bulk operations
        String indexKey = "bazar:product_index";
        redisTemplate.opsForSet().add(indexKey, productId.toString());
        redisTemplate.expire(indexKey, Duration.ofHours(1));
        
        log.debug("Cached product data: {}", productId);
    }

    /**
     * Get cached product with fallback
     */
    public Optional<Object> getCachedProduct(Long productId) {
        String key = PRODUCT_CACHE_PREFIX + productId;
        Object cachedData = redisTemplate.opsForValue().get(key);
        
        if (cachedData != null) {
            log.debug("Cache hit for product: {}", productId);
            
            // Update access statistics
            String statsKey = "bazar:product_stats:" + productId;
            redisTemplate.opsForValue().increment(statsKey);
            redisTemplate.expire(statsKey, Duration.ofDays(1));
        }
        
        return Optional.ofNullable(cachedData);
    }

    /**
     * Cache category hierarchy with smart updates
     */
    public void cacheCategoryTree(Object categoryTree) {
        String key = CATEGORY_CACHE_PREFIX + "tree";
        
        // Long TTL for category tree (6 hours)
        redisTemplate.opsForValue().set(key, categoryTree, Duration.ofHours(6));
        
        // Set last update timestamp
        String timestampKey = CATEGORY_CACHE_PREFIX + "tree:updated";
        redisTemplate.opsForValue().set(timestampKey, System.currentTimeMillis(), Duration.ofDays(1));
        
        log.info("Cached category tree");
    }

    /**
     * Get cached category tree
     */
    public Optional<Object> getCachedCategoryTree() {
        String key = CATEGORY_CACHE_PREFIX + "tree";
        return Optional.ofNullable(redisTemplate.opsForValue().get(key));
    }

    /**
     * Cache search results with query-based keys
     */
    public void cacheSearchResults(String query, Map<String, Object> filters, Object results) {
        String key = generateSearchKey(query, filters);
        
        // Short TTL for search results (15 minutes)
        redisTemplate.opsForValue().set(key, results, Duration.ofMinutes(15));
        
        // Track popular searches
        String popularKey = "bazar:popular_searches";
        redisTemplate.opsForZSet().incrementScore(popularKey, query, 1);
        redisTemplate.expire(popularKey, Duration.ofDays(7));
        
        log.debug("Cached search results for query: {}", query);
    }

    /**
     * Get cached search results
     */
    public Optional<Object> getCachedSearchResults(String query, Map<String, Object> filters) {
        String key = generateSearchKey(query, filters);
        return Optional.ofNullable(redisTemplate.opsForValue().get(key));
    }

    /**
     * Cache user cart with persistence
     */
    public void cacheCart(Long userId, Object cartData) {
        String key = CART_CACHE_PREFIX + userId;
        
        // Long TTL for cart (30 days)
        redisTemplate.opsForValue().set(key, cartData, Duration.ofDays(30));
        
        // Also persist in database asynchronously
        // TODO: Implement async cart persistence
        
        log.debug("Cached cart for user: {}", userId);
    }

    /**
     * Get cached cart
     */
    public Optional<Object> getCachedCart(Long userId) {
        String key = CART_CACHE_PREFIX + userId;
        return Optional.ofNullable(redisTemplate.opsForValue().get(key));
    }

    /**
     * Cache user session data
     */
    public void cacheSession(String sessionId, Object sessionData) {
        String key = SESSION_CACHE_PREFIX + sessionId;
        redisTemplate.opsForValue().set(key, sessionData, Duration.ofHours(24));
        log.debug("Cached session: {}", sessionId);
    }

    /**
     * Get cached session
     */
    public Optional<Object> getCachedSession(String sessionId) {
        String key = SESSION_CACHE_PREFIX + sessionId;
        return Optional.ofNullable(redisTemplate.opsForValue().get(key));
    }

    /**
     * Invalidate user-related caches
     */
    public void invalidateUserCache(Long userId) {
        Set<String> keys = Set.of(
            USER_CACHE_PREFIX + userId,
            CART_CACHE_PREFIX + userId
        );
        
        redisTemplate.delete(keys);
        log.info("Invalidated user cache: {}", userId);
    }

    /**
     * Invalidate product-related caches
     */
    public void invalidateProductCache(Long productId) {
        Set<String> keys = new HashSet<>();
        keys.add(PRODUCT_CACHE_PREFIX + productId);
        
        // Invalidate search caches that might contain this product
        Set<String> searchKeys = redisTemplate.keys(SEARCH_CACHE_PREFIX + "*");
        if (searchKeys != null) {
            keys.addAll(searchKeys);
        }
        
        redisTemplate.delete(keys);
        log.info("Invalidated product cache: {}", productId);
    }

    /**
     * Invalidate category caches
     */
    public void invalidateCategoryCache() {
        Set<String> keys = redisTemplate.keys(CATEGORY_CACHE_PREFIX + "*");
        if (keys != null && !keys.isEmpty()) {
            redisTemplate.delete(keys);
        }
        log.info("Invalidated category cache");
    }

    /**
     * Bulk cache warming for products
     */
    public void warmProductCache(List<Long> productIds, Map<Long, Object> productData) {
        Map<String, Object> cacheData = new HashMap<>();
        
        for (Long productId : productIds) {
            if (productData.containsKey(productId)) {
                String key = PRODUCT_CACHE_PREFIX + productId;
                cacheData.put(key, productData.get(productId));
            }
        }
        
        if (!cacheData.isEmpty()) {
            redisTemplate.opsForValue().multiSet(cacheData);
            
            // Set TTL for all keys
            for (String key : cacheData.keySet()) {
                redisTemplate.expire(key, Duration.ofMinutes(30));
            }
            
            log.info("Warmed cache for {} products", cacheData.size());
        }
    }

    /**
     * Get cache statistics
     */
    public Map<String, Object> getCacheStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        // Count keys by prefix
        stats.put("users", countKeysByPattern(USER_CACHE_PREFIX + "*"));
        stats.put("products", countKeysByPattern(PRODUCT_CACHE_PREFIX + "*"));
        stats.put("categories", countKeysByPattern(CATEGORY_CACHE_PREFIX + "*"));
        stats.put("carts", countKeysByPattern(CART_CACHE_PREFIX + "*"));
        stats.put("sessions", countKeysByPattern(SESSION_CACHE_PREFIX + "*"));
        stats.put("searches", countKeysByPattern(SEARCH_CACHE_PREFIX + "*"));
        
        // Get popular searches
        Set<Object> popularSearches = redisTemplate.opsForZSet()
            .reverseRange("bazar:popular_searches", 0, 9);
        stats.put("popularSearches", popularSearches);
        
        // Memory usage (approximation)
        stats.put("estimatedMemoryUsage", estimateMemoryUsage());
        
        return stats;
    }

    /**
     * Clear all application caches
     */
    public void clearAllCaches() {
        Set<String> keys = redisTemplate.keys("bazar:*");
        if (keys != null && !keys.isEmpty()) {
            redisTemplate.delete(keys);
            log.warn("Cleared all application caches ({} keys)", keys.size());
        }
    }

    /**
     * Health check for Redis connectivity
     */
    public boolean isHealthy() {
        try {
            String testKey = "bazar:health_check";
            stringRedisTemplate.opsForValue().set(testKey, "ok", Duration.ofSeconds(10));
            String result = stringRedisTemplate.opsForValue().get(testKey);
            stringRedisTemplate.delete(testKey);
            return "ok".equals(result);
        } catch (Exception e) {
            log.error("Redis health check failed", e);
            return false;
        }
    }

    // Private helper methods

    private String generateSearchKey(String query, Map<String, Object> filters) {
        StringBuilder keyBuilder = new StringBuilder(SEARCH_CACHE_PREFIX);
        keyBuilder.append(query.hashCode());
        
        if (filters != null && !filters.isEmpty()) {
            keyBuilder.append(":");
            keyBuilder.append(filters.hashCode());
        }
        
        return keyBuilder.toString();
    }

    private long countKeysByPattern(String pattern) {
        try {
            Set<String> keys = redisTemplate.keys(pattern);
            return keys != null ? keys.size() : 0;
        } catch (Exception e) {
            log.warn("Failed to count keys for pattern: {}", pattern, e);
            return 0;
        }
    }

    private String estimateMemoryUsage() {
        try {
            // This is a rough estimation
            long totalKeys = countKeysByPattern("bazar:*");
            long estimatedBytes = totalKeys * 1024; // Rough estimate: 1KB per key
            
            if (estimatedBytes < 1024) {
                return estimatedBytes + " bytes";
            } else if (estimatedBytes < 1024 * 1024) {
                return String.format("%.2f KB", estimatedBytes / 1024.0);
            } else {
                return String.format("%.2f MB", estimatedBytes / (1024.0 * 1024.0));
            }
        } catch (Exception e) {
            return "Unknown";
        }
    }
}
