package com.bazar.marketplace.gateway;

import org.springframework.cloud.gateway.filter.ratelimit.KeyResolver;
import org.springframework.cloud.gateway.filter.ratelimit.RedisRateLimiter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import reactor.core.publisher.Mono;

/**
 * Rate Limiter Configuration for API Gateway
 * 
 * Provides Redis-based rate limiting with different strategies:
 * - User-based rate limiting for authenticated requests
 * - IP-based rate limiting for public endpoints
 * - Service-specific rate limits
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Configuration
public class RateLimiterConfig {

    /**
     * Redis Rate Limiter for User Service
     * 100 requests per second, burst capacity 200
     */
    @Bean("userServiceRateLimiter")
    public RedisRateLimiter userServiceRateLimiter() {
        return new RedisRateLimiter(100, 200, 1);
    }

    /**
     * Redis Rate Limiter for Product Service
     * 200 requests per second, burst capacity 400
     */
    @Bean("productServiceRateLimiter")
    public RedisRateLimiter productServiceRateLimiter() {
        return new RedisRateLimiter(200, 400, 1);
    }

    /**
     * Redis Rate Limiter for Order Service
     * 50 requests per second, burst capacity 100
     */
    @Bean("orderServiceRateLimiter")
    public RedisRateLimiter orderServiceRateLimiter() {
        return new RedisRateLimiter(50, 100, 1);
    }

    /**
     * Redis Rate Limiter for Notification Service
     * 20 requests per second, burst capacity 50
     */
    @Bean("notificationServiceRateLimiter")
    public RedisRateLimiter notificationServiceRateLimiter() {
        return new RedisRateLimiter(20, 50, 1);
    }

    /**
     * Redis Rate Limiter for Analytics Service
     * 30 requests per second, burst capacity 60
     */
    @Bean("analyticsServiceRateLimiter")
    public RedisRateLimiter analyticsServiceRateLimiter() {
        return new RedisRateLimiter(30, 60, 1);
    }

    /**
     * User-based Key Resolver
     * Uses user ID from JWT token for authenticated requests
     */
    @Bean("userKeyResolver")
    public KeyResolver userKeyResolver() {
        return exchange -> {
            // Extract user ID from JWT token in Authorization header
            String authHeader = exchange.getRequest().getHeaders().getFirst("Authorization");
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                try {
                    // Extract user ID from JWT (simplified - in real implementation, decode JWT)
                    String token = authHeader.substring(7);
                    String userId = extractUserIdFromToken(token);
                    return Mono.just(userId != null ? "user:" + userId : "anonymous");
                } catch (Exception e) {
                    return Mono.just("anonymous");
                }
            }
            return Mono.just("anonymous");
        };
    }

    /**
     * IP-based Key Resolver
     * Uses client IP address for rate limiting
     */
    @Bean("ipKeyResolver")
    public KeyResolver ipKeyResolver() {
        return exchange -> {
            String clientIp = getClientIp(exchange);
            return Mono.just("ip:" + clientIp);
        };
    }

    /**
     * API Key Resolver
     * Uses API key for third-party integrations
     */
    @Bean("apiKeyResolver")
    public KeyResolver apiKeyResolver() {
        return exchange -> {
            String apiKey = exchange.getRequest().getHeaders().getFirst("X-API-Key");
            return Mono.just(apiKey != null ? "api:" + apiKey : "no-api-key");
        };
    }

    /**
     * Service-based Key Resolver
     * Uses service name for internal service-to-service communication
     */
    @Bean("serviceKeyResolver")
    public KeyResolver serviceKeyResolver() {
        return exchange -> {
            String serviceName = exchange.getRequest().getHeaders().getFirst("X-Service-Name");
            return Mono.just(serviceName != null ? "service:" + serviceName : "unknown-service");
        };
    }

    // Helper methods

    private String extractUserIdFromToken(String token) {
        // TODO: Implement proper JWT token parsing
        // For now, return a placeholder
        try {
            // This is a simplified implementation
            // In production, use proper JWT library to decode and extract user ID
            return "user123"; // Placeholder
        } catch (Exception e) {
            return null;
        }
    }

    private String getClientIp(org.springframework.web.server.ServerWebExchange exchange) {
        String xForwardedFor = exchange.getRequest().getHeaders().getFirst("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        
        String xRealIp = exchange.getRequest().getHeaders().getFirst("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }
        
        return exchange.getRequest().getRemoteAddress() != null 
            ? exchange.getRequest().getRemoteAddress().getAddress().getHostAddress()
            : "unknown";
    }
}
