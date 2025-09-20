package com.bazar.marketplace.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * Configuration pour l'encodage des mots de passe
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Configuration
public class PasswordConfig {
    
    /**
     * Bean PasswordEncoder pour encoder les mots de passe avec BCrypt
     * 
     * @return BCryptPasswordEncoder avec strength 12
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }
}
