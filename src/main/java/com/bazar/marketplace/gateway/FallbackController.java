package com.bazar.marketplace.gateway;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Fallback Controller for Circuit Breaker
 * 
 * Provides fallback responses when microservices are unavailable
 * Includes service-specific fallback logic and error handling
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@RestController
@RequestMapping("/fallback")
@Slf4j
public class FallbackController {

    /**
     * User Service Fallback
     */
    @GetMapping("/user-service")
    public ResponseEntity<Map<String, Object>> userServiceFallback() {
        log.warn("User service is currently unavailable, returning fallback response");
        
        Map<String, Object> fallbackResponse = createFallbackResponse(
            "user-service",
            "User service is temporarily unavailable. Please try again later.",
            "Authentication and user management features may be limited."
        );
        
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(fallbackResponse);
    }

    /**
     * Product Service Fallback
     */
    @GetMapping("/product-service")
    public ResponseEntity<Map<String, Object>> productServiceFallback() {
        log.warn("Product service is currently unavailable, returning fallback response");
        
        Map<String, Object> fallbackResponse = createFallbackResponse(
            "product-service",
            "Product service is temporarily unavailable. Please try again later.",
            "Product catalog and search features may be limited."
        );
        
        // Add cached product data if available
        fallbackResponse.put("cachedProducts", getCachedProductData());
        
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(fallbackResponse);
    }

    /**
     * Order Service Fallback
     */
    @GetMapping("/order-service")
    public ResponseEntity<Map<String, Object>> orderServiceFallback() {
        log.warn("Order service is currently unavailable, returning fallback response");
        
        Map<String, Object> fallbackResponse = createFallbackResponse(
            "order-service",
            "Order service is temporarily unavailable. Please try again later.",
            "Order processing and cart features may be limited."
        );
        
        // Add important order-related information
        fallbackResponse.put("emergencyContact", "support@bazar.com");
        fallbackResponse.put("alternativeOrderMethod", "Please call +213-XXX-XXXX to place orders");
        
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(fallbackResponse);
    }

    /**
     * Notification Service Fallback
     */
    @GetMapping("/notification-service")
    public ResponseEntity<Map<String, Object>> notificationServiceFallback() {
        log.warn("Notification service is currently unavailable, returning fallback response");
        
        Map<String, Object> fallbackResponse = createFallbackResponse(
            "notification-service",
            "Notification service is temporarily unavailable.",
            "Notifications may be delayed. Important updates will be sent via email."
        );
        
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(fallbackResponse);
    }

    /**
     * Analytics Service Fallback
     */
    @GetMapping("/analytics-service")
    public ResponseEntity<Map<String, Object>> analyticsServiceFallback() {
        log.warn("Analytics service is currently unavailable, returning fallback response");
        
        Map<String, Object> fallbackResponse = createFallbackResponse(
            "analytics-service",
            "Analytics service is temporarily unavailable.",
            "Analytics and reporting features may be limited."
        );
        
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(fallbackResponse);
    }

    /**
     * Generic Service Unavailable Fallback
     */
    @GetMapping("/generic")
    public ResponseEntity<Map<String, Object>> genericFallback() {
        log.warn("Generic service fallback triggered");
        
        Map<String, Object> fallbackResponse = createFallbackResponse(
            "unknown-service",
            "Service is temporarily unavailable. Please try again later.",
            "Some features may be limited during maintenance."
        );
        
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(fallbackResponse);
    }

    // Helper methods

    private Map<String, Object> createFallbackResponse(String serviceName, String message, String details) {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "SERVICE_UNAVAILABLE");
        response.put("service", serviceName);
        response.put("message", message);
        response.put("details", details);
        response.put("timestamp", LocalDateTime.now().toString());
        response.put("fallback", true);
        response.put("retryAfter", "30 seconds");
        
        // Add system status information
        response.put("systemStatus", getSystemStatus());
        
        return response;
    }

    private Map<String, Object> getSystemStatus() {
        Map<String, Object> systemStatus = new HashMap<>();
        systemStatus.put("overallHealth", "DEGRADED");
        systemStatus.put("maintenanceMode", false);
        systemStatus.put("estimatedRecoveryTime", "5-10 minutes");
        systemStatus.put("statusPageUrl", "https://status.bazar.com");
        
        return systemStatus;
    }

    private Object getCachedProductData() {
        // In a real implementation, this would fetch cached product data
        Map<String, Object> cachedData = new HashMap<>();
        cachedData.put("message", "Cached product data not available");
        cachedData.put("suggestion", "Please check our mobile app for offline product browsing");
        
        return cachedData;
    }
}
