package com.bazar.serviceregistry;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

/**
 * BAZAR Service Registry Application
 * 
 * Eureka Server for service discovery and registration
 * Supports high-availability clustering for production
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 * @since 2025-01-20
 */
@SpringBootApplication
@EnableEurekaServer
public class ServiceRegistryApplication {

    public static void main(String[] args) {
        SpringApplication.run(ServiceRegistryApplication.class, args);
    }
}
