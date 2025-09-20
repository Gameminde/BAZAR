package com.bazar.marketplace.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Configuration de sécurité Spring Boot pour BAZAR Marketplace
 * 
 * @author BAZAR Team
 * @version 1.0.0
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    /**
     * Configuration de la chaîne de filtres de sécurité
     * Permet l'accès libre aux endpoints publics pour les tests
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                // ACCÈS LIBRE COMPLET POUR DÉMONSTRATION
                .anyRequest().permitAll()
            )
            // Désactiver les headers de frame pour H2 Console
            .headers(headers -> headers
                .frameOptions().sameOrigin()
            );
            
        return http.build();
    }
}
