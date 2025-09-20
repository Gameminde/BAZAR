package com.bazar.marketplace.config;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsontype.impl.LaissezFaireSubTypeValidator;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.connection.lettuce.LettucePoolingClientConfiguration;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.apache.commons.pool2.impl.GenericObjectPoolConfig;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

/**
 * Redis Configuration for Enterprise Caching
 * Supports multiple cache regions with different TTL settings
 */
@Configuration
@EnableCaching
@Slf4j
public class RedisConfig {

    @Value("${spring.data.redis.host:localhost}")
    private String redisHost;

    @Value("${spring.data.redis.port:6379}")
    private int redisPort;

    @Value("${spring.data.redis.password:}")
    private String redisPassword;

    @Value("${spring.data.redis.database:0}")
    private int redisDatabase;

    @Value("${spring.data.redis.timeout:2000ms}")
    private Duration redisTimeout;

    /**
     * Redis Connection Factory with Connection Pooling
     */
    @Bean
    public RedisConnectionFactory redisConnectionFactory() {
        RedisStandaloneConfiguration redisConfig = new RedisStandaloneConfiguration();
        redisConfig.setHostName(redisHost);
        redisConfig.setPort(redisPort);
        redisConfig.setDatabase(redisDatabase);
        
        if (!redisPassword.isEmpty()) {
            redisConfig.setPassword(redisPassword);
        }

        // Connection Pool Configuration
        GenericObjectPoolConfig<?> poolConfig = new GenericObjectPoolConfig<>();
        poolConfig.setMaxTotal(50);
        poolConfig.setMaxIdle(10);
        poolConfig.setMinIdle(5);
        poolConfig.setMaxWait(Duration.ofMillis(2000));
        poolConfig.setTestOnBorrow(true);
        poolConfig.setTestOnReturn(true);
        poolConfig.setTestWhileIdle(true);

        LettucePoolingClientConfiguration clientConfig = LettucePoolingClientConfiguration.builder()
                .commandTimeout(redisTimeout)
                .poolConfig(poolConfig)
                .build();

        LettuceConnectionFactory factory = new LettuceConnectionFactory(redisConfig, clientConfig);
        factory.setValidateConnection(true);
        
        log.info("Redis connection configured: {}:{} DB:{}", redisHost, redisPort, redisDatabase);
        return factory;
    }

    /**
     * Redis Template with JSON Serialization
     */
    @Bean
    @Primary
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);

        // JSON Serializer Configuration
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        objectMapper.activateDefaultTyping(LaissezFaireSubTypeValidator.instance, ObjectMapper.DefaultTyping.NON_FINAL);
        objectMapper.registerModule(new JavaTimeModule());

        Jackson2JsonRedisSerializer<Object> jackson2JsonRedisSerializer = 
            new Jackson2JsonRedisSerializer<>(objectMapper, Object.class);

        // String serializer for keys
        StringRedisSerializer stringRedisSerializer = new StringRedisSerializer();

        // Set serializers
        template.setKeySerializer(stringRedisSerializer);
        template.setHashKeySerializer(stringRedisSerializer);
        template.setValueSerializer(jackson2JsonRedisSerializer);
        template.setHashValueSerializer(jackson2JsonRedisSerializer);
        
        template.setEnableTransactionSupport(true);
        template.afterPropertiesSet();
        
        log.info("RedisTemplate configured with JSON serialization");
        return template;
    }

    /**
     * String Redis Template for simple operations
     */
    @Bean
    public RedisTemplate<String, String> stringRedisTemplate(RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, String> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);
        
        StringRedisSerializer stringSerializer = new StringRedisSerializer();
        template.setKeySerializer(stringSerializer);
        template.setValueSerializer(stringSerializer);
        template.setHashKeySerializer(stringSerializer);
        template.setHashValueSerializer(stringSerializer);
        
        template.afterPropertiesSet();
        return template;
    }

    /**
     * Cache Manager with Multiple Cache Configurations
     */
    @Bean
    @Primary
    public CacheManager cacheManager(RedisConnectionFactory connectionFactory) {
        // Default cache configuration
        RedisCacheConfiguration defaultConfig = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofHours(1))
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer()))
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(new GenericJackson2JsonRedisSerializer()))
                .disableCachingNullValues();

        // Cache-specific configurations
        Map<String, RedisCacheConfiguration> cacheConfigurations = new HashMap<>();
        
        // User cache - 1 hour TTL
        cacheConfigurations.put("users", defaultConfig
                .entryTtl(Duration.ofHours(1))
                .prefixCacheNameWith("bazar:users:"));

        // Product cache - 30 minutes TTL
        cacheConfigurations.put("products", defaultConfig
                .entryTtl(Duration.ofMinutes(30))
                .prefixCacheNameWith("bazar:products:"));

        // Category cache - 6 hours TTL (changes less frequently)
        cacheConfigurations.put("categories", defaultConfig
                .entryTtl(Duration.ofHours(6))
                .prefixCacheNameWith("bazar:categories:"));

        // Cart cache - 30 days TTL
        cacheConfigurations.put("carts", defaultConfig
                .entryTtl(Duration.ofDays(30))
                .prefixCacheNameWith("bazar:carts:"));

        // Session cache - 24 hours TTL
        cacheConfigurations.put("sessions", defaultConfig
                .entryTtl(Duration.ofHours(24))
                .prefixCacheNameWith("bazar:sessions:"));

        // Search cache - 15 minutes TTL (for search results)
        cacheConfigurations.put("search", defaultConfig
                .entryTtl(Duration.ofMinutes(15))
                .prefixCacheNameWith("bazar:search:"));

        // Flash sale cache - 5 minutes TTL (real-time inventory)
        cacheConfigurations.put("flashsales", defaultConfig
                .entryTtl(Duration.ofMinutes(5))
                .prefixCacheNameWith("bazar:flashsales:"));

        RedisCacheManager cacheManager = RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(defaultConfig)
                .withInitialCacheConfigurations(cacheConfigurations)
                .transactionAware()
                .build();

        log.info("RedisCacheManager configured with {} cache regions", cacheConfigurations.size());
        return cacheManager;
    }

    /**
     * Cache configuration for different environments
     */
    @Bean
    public CacheConfigurationProperties cacheConfigurationProperties() {
        return new CacheConfigurationProperties();
    }

    /**
     * Configuration properties for cache settings
     */
    public static class CacheConfigurationProperties {
        private final Map<String, Duration> cacheTtl = new HashMap<>();

        public CacheConfigurationProperties() {
            // Default TTL values
            cacheTtl.put("users", Duration.ofHours(1));
            cacheTtl.put("products", Duration.ofMinutes(30));
            cacheTtl.put("categories", Duration.ofHours(6));
            cacheTtl.put("carts", Duration.ofDays(30));
            cacheTtl.put("sessions", Duration.ofHours(24));
            cacheTtl.put("search", Duration.ofMinutes(15));
            cacheTtl.put("flashsales", Duration.ofMinutes(5));
        }

        public Duration getTtl(String cacheName) {
            return cacheTtl.getOrDefault(cacheName, Duration.ofHours(1));
        }

        public void setTtl(String cacheName, Duration ttl) {
            cacheTtl.put(cacheName, ttl);
        }

        public Map<String, Duration> getAllTtl() {
            return new HashMap<>(cacheTtl);
        }
    }
}
