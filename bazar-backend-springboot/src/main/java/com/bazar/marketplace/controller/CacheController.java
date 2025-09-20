package com.bazar.marketplace.controller;

import com.bazar.marketplace.service.CacheService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Cache Management Controller
 * Provides cache administration endpoints for monitoring and management
 */
@RestController
@RequestMapping("/api/v1/admin/cache")
@RequiredArgsConstructor
@Slf4j
@PreAuthorize("hasRole('ADMIN')")
public class CacheController {

    private final CacheService cacheService;

    /**
     * Get cache statistics
     */
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getCacheStatistics() {
        log.debug("Getting cache statistics");
        
        Map<String, Object> stats = cacheService.getCacheStatistics();
        
        // Add health status
        stats.put("healthy", cacheService.isHealthy());
        stats.put("timestamp", System.currentTimeMillis());
        
        return ResponseEntity.ok(stats);
    }

    /**
     * Check cache health
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> getCacheHealth() {
        Map<String, Object> health = new HashMap<>();
        
        boolean isHealthy = cacheService.isHealthy();
        health.put("status", isHealthy ? "UP" : "DOWN");
        health.put("healthy", isHealthy);
        health.put("timestamp", System.currentTimeMillis());
        
        if (isHealthy) {
            return ResponseEntity.ok(health);
        } else {
            return ResponseEntity.status(503).body(health);
        }
    }

    /**
     * Warm product cache
     */
    @PostMapping("/warm/products")
    public ResponseEntity<Map<String, Object>> warmProductCache(@RequestBody List<Long> productIds) {
        log.info("Warming product cache for {} products", productIds.size());
        
        try {
            // This would typically fetch from database and cache
            // For now, we'll just acknowledge the request
            
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Product cache warming initiated");
            response.put("productCount", productIds.size());
            response.put("timestamp", System.currentTimeMillis());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Failed to warm product cache", e);
            
            Map<String, Object> response = new HashMap<>();
            response.put("error", "Failed to warm product cache");
            response.put("message", e.getMessage());
            
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * Invalidate user cache
     */
    @DeleteMapping("/users/{userId}")
    public ResponseEntity<Map<String, String>> invalidateUserCache(@PathVariable Long userId) {
        log.info("Invalidating cache for user: {}", userId);
        
        cacheService.invalidateUserCache(userId);
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "User cache invalidated successfully");
        response.put("userId", userId.toString());
        
        return ResponseEntity.ok(response);
    }

    /**
     * Invalidate product cache
     */
    @DeleteMapping("/products/{productId}")
    public ResponseEntity<Map<String, String>> invalidateProductCache(@PathVariable Long productId) {
        log.info("Invalidating cache for product: {}", productId);
        
        cacheService.invalidateProductCache(productId);
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "Product cache invalidated successfully");
        response.put("productId", productId.toString());
        
        return ResponseEntity.ok(response);
    }

    /**
     * Invalidate category cache
     */
    @DeleteMapping("/categories")
    public ResponseEntity<Map<String, String>> invalidateCategoryCache() {
        log.info("Invalidating category cache");
        
        cacheService.invalidateCategoryCache();
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "Category cache invalidated successfully");
        
        return ResponseEntity.ok(response);
    }

    /**
     * Clear all caches (DANGEROUS - use with caution)
     */
    @DeleteMapping("/all")
    public ResponseEntity<Map<String, String>> clearAllCaches() {
        log.warn("Clearing all application caches - this may impact performance");
        
        cacheService.clearAllCaches();
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "All caches cleared successfully");
        response.put("warning", "This operation may impact application performance");
        
        return ResponseEntity.ok(response);
    }

    /**
     * Cache a specific user
     */
    @PostMapping("/users/{userId}")
    public ResponseEntity<Map<String, String>> cacheUser(@PathVariable Long userId, @RequestBody Object userData) {
        log.info("Manually caching user data: {}", userId);
        
        cacheService.cacheUser(userId, userData);
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "User data cached successfully");
        response.put("userId", userId.toString());
        
        return ResponseEntity.ok(response);
    }

    /**
     * Cache a specific product
     */
    @PostMapping("/products/{productId}")
    public ResponseEntity<Map<String, String>> cacheProduct(@PathVariable Long productId, @RequestBody Object productData) {
        log.info("Manually caching product data: {}", productId);
        
        cacheService.cacheProduct(productId, productData);
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "Product data cached successfully");
        response.put("productId", productId.toString());
        
        return ResponseEntity.ok(response);
    }

    /**
     * Cache category tree
     */
    @PostMapping("/categories/tree")
    public ResponseEntity<Map<String, String>> cacheCategoryTree(@RequestBody Object categoryTree) {
        log.info("Manually caching category tree");
        
        cacheService.cacheCategoryTree(categoryTree);
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "Category tree cached successfully");
        
        return ResponseEntity.ok(response);
    }

    /**
     * Get cached user data
     */
    @GetMapping("/users/{userId}")
    public ResponseEntity<Object> getCachedUser(@PathVariable Long userId) {
        log.debug("Getting cached user data: {}", userId);
        
        return cacheService.getCachedUser(userId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Get cached product data
     */
    @GetMapping("/products/{productId}")
    public ResponseEntity<Object> getCachedProduct(@PathVariable Long productId) {
        log.debug("Getting cached product data: {}", productId);
        
        return cacheService.getCachedProduct(productId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Get cached category tree
     */
    @GetMapping("/categories/tree")
    public ResponseEntity<Object> getCachedCategoryTree() {
        log.debug("Getting cached category tree");
        
        return cacheService.getCachedCategoryTree()
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
