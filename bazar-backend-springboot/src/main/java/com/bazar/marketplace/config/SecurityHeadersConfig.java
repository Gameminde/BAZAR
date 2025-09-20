package com.bazar.marketplace.config;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * Security Headers Configuration
 * Implements OWASP security headers for enterprise-grade protection
 */
@Configuration
public class SecurityHeadersConfig {

    /**
     * Security Headers Filter
     * Adds comprehensive security headers to all responses
     */
    @Bean
    public OncePerRequestFilter securityHeadersFilter() {
        return new OncePerRequestFilter() {
            @Override
            protected void doFilterInternal(HttpServletRequest request, 
                                          HttpServletResponse response, 
                                          FilterChain filterChain) throws ServletException, IOException {
                
                // Content Security Policy (CSP)
                response.setHeader("Content-Security-Policy", 
                    "default-src 'self'; " +
                    "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net https://unpkg.com; " +
                    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdn.jsdelivr.net; " +
                    "font-src 'self' https://fonts.gstatic.com; " +
                    "img-src 'self' data: https: blob:; " +
                    "connect-src 'self' https://api.bazar.dz wss://api.bazar.dz; " +
                    "frame-ancestors 'none'; " +
                    "base-uri 'self'; " +
                    "form-action 'self'");

                // X-Content-Type-Options
                response.setHeader("X-Content-Type-Options", "nosniff");

                // X-Frame-Options
                response.setHeader("X-Frame-Options", "DENY");

                // X-XSS-Protection
                response.setHeader("X-XSS-Protection", "1; mode=block");

                // Referrer Policy
                response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

                // Permissions Policy (formerly Feature Policy)
                response.setHeader("Permissions-Policy", 
                    "geolocation=(), " +
                    "microphone=(), " +
                    "camera=(), " +
                    "payment=(), " +
                    "usb=(), " +
                    "magnetometer=(), " +
                    "gyroscope=(), " +
                    "speaker=()");

                // Strict Transport Security (HSTS) - only in production
                if (isProductionEnvironment(request)) {
                    response.setHeader("Strict-Transport-Security", 
                        "max-age=31536000; includeSubDomains; preload");
                }

                // Clear Server header for security
                response.setHeader("Server", "BAZAR-API");

                // X-Powered-By removal (Spring Boot doesn't set this by default, but just in case)
                response.setHeader("X-Powered-By", "");

                // Cache Control for sensitive endpoints
                if (isSensitiveEndpoint(request)) {
                    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, private");
                    response.setHeader("Pragma", "no-cache");
                    response.setHeader("Expires", "0");
                }

                filterChain.doFilter(request, response);
            }

            private boolean isProductionEnvironment(HttpServletRequest request) {
                String serverName = request.getServerName();
                return serverName.contains("bazar.dz") || 
                       serverName.contains("marketplace.dz") ||
                       !serverName.contains("localhost");
            }

            private boolean isSensitiveEndpoint(HttpServletRequest request) {
                String uri = request.getRequestURI();
                return uri.startsWith("/api/v1/auth/") ||
                       uri.startsWith("/api/v1/users/") ||
                       uri.startsWith("/api/v1/orders/") ||
                       uri.startsWith("/api/v1/payment/");
            }
        };
    }
}
