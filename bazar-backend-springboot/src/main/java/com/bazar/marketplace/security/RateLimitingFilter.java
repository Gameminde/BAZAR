package com.bazar.marketplace.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.time.Instant;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * Redis-based Rate Limiting Filter
 * Implements sliding window rate limiting with different limits for authenticated/anonymous users
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class RateLimitingFilter extends OncePerRequestFilter {

    private final RedisTemplate<String, String> redisTemplate;
    private final ObjectMapper objectMapper;

    @Value("${bazar.security.rate-limit.authenticated.requests:1000}")
    private int authenticatedUserLimit;

    @Value("${bazar.security.rate-limit.authenticated.window:60}")
    private int authenticatedWindowSeconds;

    @Value("${bazar.security.rate-limit.anonymous.requests:100}")
    private int anonymousUserLimit;

    @Value("${bazar.security.rate-limit.anonymous.window:60}")
    private int anonymousWindowSeconds;

    @Value("${bazar.security.rate-limit.login.requests:5}")
    private int loginAttemptLimit;

    @Value("${bazar.security.rate-limit.login.window:900}")
    private int loginWindowSeconds;

    // Redis Lua script for atomic rate limiting
    private static final String RATE_LIMIT_SCRIPT = 
        "local key = KEYS[1] " +
        "local window = tonumber(ARGV[1]) " +
        "local limit = tonumber(ARGV[2]) " +
        "local current_time = tonumber(ARGV[3]) " +
        "local window_start = current_time - window " +
        
        // Remove expired entries
        "redis.call('ZREMRANGEBYSCORE', key, 0, window_start) " +
        
        // Count current requests in window
        "local current_requests = redis.call('ZCARD', key) " +
        
        // Check if limit exceeded
        "if current_requests < limit then " +
        "  redis.call('ZADD', key, current_time, current_time) " +
        "  redis.call('EXPIRE', key, window) " +
        "  return {0, limit - current_requests - 1} " +
        "else " +
        "  local oldest_request = redis.call('ZRANGE', key, 0, 0, 'WITHSCORES') " +
        "  local reset_time = 0 " +
        "  if next(oldest_request) ~= nil then " +
        "    reset_time = oldest_request[2] + window " +
        "  end " +
        "  return {1, 0, reset_time} " +
        "end";

    private final DefaultRedisScript<Object> rateLimitScript = new DefaultRedisScript<>(RATE_LIMIT_SCRIPT, Object.class);

    @Override
    protected void doFilterInternal(HttpServletRequest request, 
                                  HttpServletResponse response, 
                                  FilterChain filterChain) throws ServletException, IOException {
        
        String clientId = getClientIdentifier(request);
        String endpoint = getEndpointKey(request);
        
        // Apply rate limiting
        RateLimitResult result = checkRateLimit(clientId, endpoint, request);
        
        if (result.isLimited()) {
            handleRateLimitExceeded(response, result);
            return;
        }

        // Add rate limit headers
        addRateLimitHeaders(response, result);
        
        filterChain.doFilter(request, response);
    }

    /**
     * Check rate limit using Redis sliding window
     */
    private RateLimitResult checkRateLimit(String clientId, String endpoint, HttpServletRequest request) {
        try {
            int limit;
            int windowSeconds;
            
            // Determine limits based on authentication and endpoint
            if (isLoginEndpoint(request)) {
                limit = loginAttemptLimit;
                windowSeconds = loginWindowSeconds;
            } else if (isAuthenticated()) {
                limit = authenticatedUserLimit;
                windowSeconds = authenticatedWindowSeconds;
            } else {
                limit = anonymousUserLimit;
                windowSeconds = anonymousWindowSeconds;
            }

            String key = "rate_limit:" + endpoint + ":" + clientId;
            long currentTime = Instant.now().getEpochSecond();

            @SuppressWarnings("unchecked")
            java.util.List<Object> result = (java.util.List<Object>) redisTemplate.execute(
                rateLimitScript,
                Arrays.asList(key),
                String.valueOf(windowSeconds),
                String.valueOf(limit),
                String.valueOf(currentTime)
            );

            boolean isLimited = ((Long) result.get(0)) == 1;
            long remaining = (Long) result.get(1);
            long resetTime = result.size() > 2 ? (Long) result.get(2) : currentTime + windowSeconds;

            return new RateLimitResult(isLimited, remaining, resetTime, limit);

        } catch (Exception e) {
            log.error("Rate limiting check failed for client: {}", clientId, e);
            // Fail open - allow request if Redis is unavailable
            return new RateLimitResult(false, authenticatedUserLimit, 0, authenticatedUserLimit);
        }
    }

    /**
     * Get client identifier for rate limiting
     */
    private String getClientIdentifier(HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof UserPrincipal) {
            UserPrincipal user = (UserPrincipal) auth.getPrincipal();
            return "user:" + user.getId();
        }
        
        // For anonymous users, use IP address
        String clientIp = getClientIpAddress(request);
        return "ip:" + clientIp;
    }

    /**
     * Get client IP address considering proxies
     */
    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }
        
        return request.getRemoteAddr();
    }

    /**
     * Get endpoint key for rate limiting
     */
    private String getEndpointKey(HttpServletRequest request) {
        String method = request.getMethod();
        String path = request.getRequestURI();
        
        // Group similar endpoints
        if (path.startsWith("/api/v1/auth/")) {
            return "auth";
        } else if (path.startsWith("/api/v1/products/")) {
            return "products";
        } else if (path.startsWith("/api/v1/orders/")) {
            return "orders";
        } else if (path.startsWith("/api/v1/cart/")) {
            return "cart";
        } else {
            return "general";
        }
    }

    /**
     * Check if current user is authenticated
     */
    private boolean isAuthenticated() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof UserPrincipal;
    }

    /**
     * Check if request is to login endpoint
     */
    private boolean isLoginEndpoint(HttpServletRequest request) {
        return request.getRequestURI().contains("/auth/login") || 
               request.getRequestURI().contains("/auth/register");
    }

    /**
     * Handle rate limit exceeded
     */
    private void handleRateLimitExceeded(HttpServletResponse response, RateLimitResult result) throws IOException {
        response.setStatus(HttpStatus.TOO_MANY_REQUESTS.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("error", "Rate limit exceeded");
        errorResponse.put("message", "Too many requests. Please try again later.");
        errorResponse.put("retryAfter", result.getResetTime());
        
        // Add rate limit headers
        addRateLimitHeaders(response, result);
        
        response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
        
        log.warn("Rate limit exceeded for client. Reset time: {}", result.getResetTime());
    }

    /**
     * Add rate limit headers to response
     */
    private void addRateLimitHeaders(HttpServletResponse response, RateLimitResult result) {
        response.setHeader("X-RateLimit-Limit", String.valueOf(result.getLimit()));
        response.setHeader("X-RateLimit-Remaining", String.valueOf(result.getRemaining()));
        response.setHeader("X-RateLimit-Reset", String.valueOf(result.getResetTime()));
    }

    /**
     * Skip rate limiting for certain paths
     */
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        
        // Skip rate limiting for health checks and static resources
        return path.startsWith("/actuator/health") ||
               path.startsWith("/favicon.ico") ||
               path.startsWith("/static/");
    }

    /**
     * Rate limit result container
     */
    private static class RateLimitResult {
        private final boolean limited;
        private final long remaining;
        private final long resetTime;
        private final int limit;

        public RateLimitResult(boolean limited, long remaining, long resetTime, int limit) {
            this.limited = limited;
            this.remaining = remaining;
            this.resetTime = resetTime;
            this.limit = limit;
        }

        public boolean isLimited() { return limited; }
        public long getRemaining() { return remaining; }
        public long getResetTime() { return resetTime; }
        public int getLimit() { return limit; }
    }
}
