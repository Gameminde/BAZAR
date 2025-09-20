package com.bazar.serviceregistry.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Security Configuration for Eureka Server
 * 
 * Provides basic authentication for Eureka dashboard and REST endpoints
 * while allowing service registration without authentication
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(authz -> authz
                // Allow actuator health endpoint without authentication
                .requestMatchers("/actuator/health", "/actuator/info").permitAll()
                // Allow Eureka service registration endpoints
                .requestMatchers("/eureka/**").permitAll()
                // Require authentication for Eureka dashboard
                .requestMatchers("/").authenticated()
                .requestMatchers("/eureka/web/**").authenticated()
                // All other requests require authentication
                .anyRequest().authenticated()
            )
            .httpBasic(httpBasic -> httpBasic
                .realmName("Eureka Server")
            )
            .headers(headers -> headers
                .frameOptions().deny()
                .contentTypeOptions().and()
                .httpStrictTransportSecurity(hstsConfig -> hstsConfig
                    .maxAgeInSeconds(31536000)
                    .includeSubdomains(true)
                )
            );

        return http.build();
    }
}
