package com.bazar.marketplace;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * BAZAR Marketplace - Application Principale Spring Boot
 * 
 * Plateforme e-commerce enterprise pour 5 millions d'utilisateurs
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 * @since 2025-01-20
 */
@SpringBootApplication
@EnableCaching
@EnableJpaAuditing
@EnableAsync
@EnableScheduling
@EnableTransactionManagement
@EnableEurekaClient
public class BazarMarketplaceApplication {

    /**
     * Point d'entrée principal de l'application BAZAR Marketplace
     * 
     * @param args Arguments de ligne de commande
     */
    public static void main(String[] args) {
        System.setProperty("spring.profiles.active", 
            System.getProperty("spring.profiles.active", "dev"));
        
        SpringApplication.run(BazarMarketplaceApplication.class, args);
    }
}
