package com.bazar.marketplace.health;

import com.bazar.marketplace.service.CacheService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Professional Health Check Controller
 * Provides detailed health status for all system components
 */
@RestController
@RequestMapping("/api/v1/health")
@RequiredArgsConstructor
@Slf4j
public class CustomHealthController {

    private final JdbcTemplate jdbcTemplate;
    private final RedisTemplate<String, Object> redisTemplate;
    private final CacheService cacheService;

    /**
     * Complete system health check
     */
    @GetMapping
    public ResponseEntity<Map<String, Object>> getSystemHealth() {
        Map<String, Object> health = new HashMap<>();
        boolean allHealthy = true;

        // Database health
        Map<String, Object> dbHealth = checkDatabaseHealth();
        health.put("database", dbHealth);
        if (!"UP".equals(dbHealth.get("status"))) {
            allHealthy = false;
        }

        // Redis health
        Map<String, Object> redisHealth = checkRedisHealth();
        health.put("redis", redisHealth);
        if (!"UP".equals(redisHealth.get("status"))) {
            allHealthy = false;
        }

        // Application health
        Map<String, Object> appHealth = checkApplicationHealth();
        health.put("application", appHealth);

        // Overall status
        health.put("status", allHealthy ? "UP" : "DOWN");
        health.put("timestamp", LocalDateTime.now().toString());
        health.put("version", "1.0.0");

        return allHealthy ? ResponseEntity.ok(health) : ResponseEntity.status(503).body(health);
    }

    /**
     * Database-specific health check
     */
    @GetMapping("/database")
    public ResponseEntity<Map<String, Object>> getDatabaseHealth() {
        Map<String, Object> health = checkDatabaseHealth();
        boolean isHealthy = "UP".equals(health.get("status"));
        
        return isHealthy ? ResponseEntity.ok(health) : ResponseEntity.status(503).body(health);
    }

    /**
     * Redis-specific health check
     */
    @GetMapping("/redis")
    public ResponseEntity<Map<String, Object>> getRedisHealth() {
        Map<String, Object> health = checkRedisHealth();
        boolean isHealthy = "UP".equals(health.get("status"));
        
        return isHealthy ? ResponseEntity.ok(health) : ResponseEntity.status(503).body(health);
    }

    /**
     * Cache statistics
     */
    @GetMapping("/cache")
    public ResponseEntity<Map<String, Object>> getCacheHealth() {
        Map<String, Object> health = new HashMap<>();
        
        try {
            Map<String, Object> cacheStats = cacheService.getCacheStatistics();
            boolean isHealthy = cacheService.isHealthy();
            
            health.put("status", isHealthy ? "UP" : "DOWN");
            health.put("statistics", cacheStats);
            health.put("timestamp", LocalDateTime.now().toString());
            
            return isHealthy ? ResponseEntity.ok(health) : ResponseEntity.status(503).body(health);
            
        } catch (Exception e) {
            log.error("Cache health check failed", e);
            health.put("status", "DOWN");
            health.put("error", e.getMessage());
            health.put("timestamp", LocalDateTime.now().toString());
            
            return ResponseEntity.status(503).body(health);
        }
    }

    // Private helper methods

    private Map<String, Object> checkDatabaseHealth() {
        Map<String, Object> health = new HashMap<>();
        
        try {
            long startTime = System.currentTimeMillis();
            
            // Test basic connectivity
            Integer result = jdbcTemplate.queryForObject("SELECT 1", Integer.class);
            long responseTime = System.currentTimeMillis() - startTime;
            
            if (result != null && result.equals(1)) {
                health.put("status", "UP");
                health.put("database", "PostgreSQL");
                health.put("responseTime", responseTime + "ms");
                
                // Get additional metrics
                try {
                    Integer activeConnections = jdbcTemplate.queryForObject(
                        "SELECT count(*) FROM pg_stat_activity WHERE state = 'active'", Integer.class);
                    health.put("activeConnections", activeConnections);
                } catch (DataAccessException e) {
                    health.put("activeConnections", "unavailable");
                }
                
            } else {
                health.put("status", "DOWN");
                health.put("error", "Invalid query response");
            }
            
        } catch (Exception e) {
            log.error("Database health check failed", e);
            health.put("status", "DOWN");
            health.put("database", "PostgreSQL");
            health.put("error", e.getMessage());
        }
        
        health.put("timestamp", LocalDateTime.now().toString());
        return health;
    }

    private Map<String, Object> checkRedisHealth() {
        Map<String, Object> health = new HashMap<>();
        
        try {
            long startTime = System.currentTimeMillis();
            String testKey = "bazar:health:check:" + System.currentTimeMillis();
            String testValue = "ok";
            
            // Test Redis operations
            redisTemplate.opsForValue().set(testKey, testValue, Duration.ofSeconds(10));
            String retrievedValue = (String) redisTemplate.opsForValue().get(testKey);
            Boolean deleted = redisTemplate.delete(testKey);
            
            long responseTime = System.currentTimeMillis() - startTime;
            
            if ("ok".equals(retrievedValue)) {
                health.put("status", "UP");
                health.put("redis", "Connected");
                health.put("responseTime", responseTime + "ms");
                health.put("operations", "write/read/delete - success");
                
                // Get cache statistics
                try {
                    Map<String, Object> cacheStats = cacheService.getCacheStatistics();
                    health.put("cacheStatistics", cacheStats);
                } catch (Exception e) {
                    health.put("cacheStatistics", "unavailable");
                }
                
            } else {
                health.put("status", "DOWN");
                health.put("error", "Read operation failed");
            }
            
        } catch (Exception e) {
            log.error("Redis health check failed", e);
            health.put("status", "DOWN");
            health.put("redis", "Connection failed");
            health.put("error", e.getMessage());
        }
        
        health.put("timestamp", LocalDateTime.now().toString());
        return health;
    }

    private Map<String, Object> checkApplicationHealth() {
        Map<String, Object> health = new HashMap<>();
        
        try {
            Runtime runtime = Runtime.getRuntime();
            long maxMemory = runtime.maxMemory();
            long totalMemory = runtime.totalMemory();
            long freeMemory = runtime.freeMemory();
            long usedMemory = totalMemory - freeMemory;
            
            health.put("status", "UP");
            health.put("memory", Map.of(
                "max", formatBytes(maxMemory),
                "total", formatBytes(totalMemory),
                "used", formatBytes(usedMemory),
                "free", formatBytes(freeMemory),
                "usagePercentage", String.format("%.1f%%", (usedMemory * 100.0) / maxMemory)
            ));
            
            health.put("processors", runtime.availableProcessors());
            health.put("uptime", getUptime());
            
        } catch (Exception e) {
            log.error("Application health check failed", e);
            health.put("status", "DOWN");
            health.put("error", e.getMessage());
        }
        
        health.put("timestamp", LocalDateTime.now().toString());
        return health;
    }

    private String formatBytes(long bytes) {
        if (bytes < 1024) return bytes + " B";
        if (bytes < 1024 * 1024) return String.format("%.1f KB", bytes / 1024.0);
        if (bytes < 1024 * 1024 * 1024) return String.format("%.1f MB", bytes / (1024.0 * 1024.0));
        return String.format("%.1f GB", bytes / (1024.0 * 1024.0 * 1024.0));
    }

    private String getUptime() {
        long uptime = java.lang.management.ManagementFactory.getRuntimeMXBean().getUptime();
        long seconds = uptime / 1000;
        long minutes = seconds / 60;
        long hours = minutes / 60;
        long days = hours / 24;
        
        if (days > 0) {
            return String.format("%dd %dh %dm", days, hours % 24, minutes % 60);
        } else if (hours > 0) {
            return String.format("%dh %dm %ds", hours, minutes % 60, seconds % 60);
        } else if (minutes > 0) {
            return String.format("%dm %ds", minutes, seconds % 60);
        } else {
            return String.format("%ds", seconds);
        }
    }
}
