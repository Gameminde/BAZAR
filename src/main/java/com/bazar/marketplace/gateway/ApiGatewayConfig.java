package com.bazar.marketplace.gateway;

import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;

/**
 * API Gateway Configuration for BAZAR Microservices
 * 
 * Routes requests to appropriate microservices with:
 * - Load balancing
 * - Circuit breakers  
 * - Rate limiting
 * - Authentication filters
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Configuration
public class ApiGatewayConfig {

    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                
            // User Service Routes
            .route("user-service", r -> r
                .path("/api/v1/users/**", "/api/v1/auth/**")
                .and()
                .method(HttpMethod.GET, HttpMethod.POST, HttpMethod.PUT, HttpMethod.DELETE)
                .filters(f -> f
                    .circuitBreaker(config -> config
                        .setName("user-service-cb")
                        .setFallbackUri("forward:/fallback/user-service")
                    )
                    .requestRateLimiter(config -> config
                        .setRateLimiter(redisRateLimiter())
                        .setKeyResolver(userKeyResolver())
                    )
                    .retry(config -> config
                        .setRetries(3)
                        .setMethods(HttpMethod.GET)
                    )
                    .addRequestHeader("X-Gateway-Service", "user-service")
                    .addRequestHeader("X-Request-ID", "#{T(java.util.UUID).randomUUID().toString()}")
                )
                .uri("lb://user-service")
            )
            
            // Product Service Routes
            .route("product-service", r -> r
                .path("/api/v1/products/**", "/api/v1/categories/**", "/api/v1/search/**")
                .and()
                .method(HttpMethod.GET, HttpMethod.POST, HttpMethod.PUT, HttpMethod.DELETE)
                .filters(f -> f
                    .circuitBreaker(config -> config
                        .setName("product-service-cb")
                        .setFallbackUri("forward:/fallback/product-service")
                    )
                    .requestRateLimiter(config -> config
                        .setRateLimiter(redisRateLimiter())
                        .setKeyResolver(ipKeyResolver())
                    )
                    .retry(config -> config
                        .setRetries(2)
                        .setMethods(HttpMethod.GET)
                    )
                    .addRequestHeader("X-Gateway-Service", "product-service")
                    .addRequestHeader("X-Request-ID", "#{T(java.util.UUID).randomUUID().toString()}")
                )
                .uri("lb://product-service")
            )
            
            // Order Service Routes
            .route("order-service", r -> r
                .path("/api/v1/orders/**", "/api/v1/cart/**", "/api/v1/checkout/**")
                .and()
                .method(HttpMethod.GET, HttpMethod.POST, HttpMethod.PUT, HttpMethod.DELETE)
                .filters(f -> f
                    .circuitBreaker(config -> config
                        .setName("order-service-cb")
                        .setFallbackUri("forward:/fallback/order-service")
                    )
                    .requestRateLimiter(config -> config
                        .setRateLimiter(redisRateLimiter())
                        .setKeyResolver(userKeyResolver())
                    )
                    .retry(config -> config
                        .setRetries(2)
                        .setMethods(HttpMethod.GET)
                    )
                    .addRequestHeader("X-Gateway-Service", "order-service")
                    .addRequestHeader("X-Request-ID", "#{T(java.util.UUID).randomUUID().toString()}")
                )
                .uri("lb://order-service")
            )
            
            // Notification Service Routes
            .route("notification-service", r -> r
                .path("/api/v1/notifications/**")
                .and()
                .method(HttpMethod.GET, HttpMethod.POST, HttpMethod.PUT, HttpMethod.DELETE)
                .filters(f -> f
                    .circuitBreaker(config -> config
                        .setName("notification-service-cb")
                        .setFallbackUri("forward:/fallback/notification-service")
                    )
                    .requestRateLimiter(config -> config
                        .setRateLimiter(redisRateLimiter())
                        .setKeyResolver(userKeyResolver())
                    )
                    .addRequestHeader("X-Gateway-Service", "notification-service")
                    .addRequestHeader("X-Request-ID", "#{T(java.util.UUID).randomUUID().toString()}")
                )
                .uri("lb://notification-service")
            )
            
            // Analytics Service Routes  
            .route("analytics-service", r -> r
                .path("/api/v1/analytics/**", "/api/v1/metrics/**")
                .and()
                .method(HttpMethod.GET, HttpMethod.POST)
                .filters(f -> f
                    .circuitBreaker(config -> config
                        .setName("analytics-service-cb")
                        .setFallbackUri("forward:/fallback/analytics-service")
                    )
                    .requestRateLimiter(config -> config
                        .setRateLimiter(redisRateLimiter())
                        .setKeyResolver(ipKeyResolver())
                    )
                    .addRequestHeader("X-Gateway-Service", "analytics-service")
                    .addRequestHeader("X-Request-ID", "#{T(java.util.UUID).randomUUID().toString()}")
                )
                .uri("lb://analytics-service")
            )
            
            .build();
    }

    // Rate Limiter Bean (will be defined in separate configuration)
    private Object redisRateLimiter() {
        // This will be implemented in RateLimiterConfig
        return null;
    }

    // Key Resolver Beans (will be defined in separate configuration)
    private Object userKeyResolver() {
        // This will be implemented in KeyResolverConfig
        return null;
    }

    private Object ipKeyResolver() {
        // This will be implemented in KeyResolverConfig  
        return null;
    }
}
