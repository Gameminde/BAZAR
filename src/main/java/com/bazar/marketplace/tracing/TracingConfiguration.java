package com.bazar.marketplace.tracing;

import brave.sampler.Sampler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

/**
 * Distributed Tracing Configuration for BAZAR Microservices
 * 
 * Configures Jaeger tracing with appropriate sampling rates
 * for different environments (dev, staging, production)
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Configuration
public class TracingConfiguration {

    /**
     * Development sampling - trace everything for debugging
     */
    @Bean
    @Profile("dev")
    public Sampler developmentSampler() {
        return Sampler.create(1.0f); // 100% sampling for development
    }

    /**
     * Staging sampling - high sampling for testing
     */
    @Bean
    @Profile("staging")
    public Sampler stagingSampler() {
        return Sampler.create(0.5f); // 50% sampling for staging
    }

    /**
     * Production sampling - optimized for performance
     */
    @Bean
    @Profile("production")
    public Sampler productionSampler() {
        return Sampler.create(0.1f); // 10% sampling for production
    }

    /**
     * Default sampling for other profiles
     */
    @Bean
    @Profile("!dev & !staging & !production")
    public Sampler defaultSampler() {
        return Sampler.create(0.2f); // 20% sampling for other environments
    }
}
