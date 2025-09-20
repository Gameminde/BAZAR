package com.bazar.marketplace.events.config;

import org.apache.kafka.clients.admin.NewTopic;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.config.TopicBuilder;
import org.springframework.kafka.core.*;
import org.springframework.kafka.listener.ContainerProperties;
import org.springframework.kafka.support.serializer.JsonDeserializer;
import org.springframework.kafka.support.serializer.JsonSerializer;

import java.util.HashMap;
import java.util.Map;

/**
 * Kafka Configuration for BAZAR Event-Driven Architecture
 * 
 * Configures Kafka producers, consumers, and topics for microservices communication
 * Includes high-throughput settings for production scalability
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Configuration
@EnableKafka
public class KafkaConfiguration {

    @Value("${spring.kafka.bootstrap-servers:localhost:9092}")
    private String bootstrapServers;

    @Value("${spring.kafka.consumer.group-id:bazar-marketplace}")
    private String consumerGroupId;

    // =================================================================
    // KAFKA TOPICS CONFIGURATION
    // =================================================================

    /**
     * User Events Topic
     */
    @Bean
    public NewTopic userEventsTopic() {
        return TopicBuilder.name("bazar.user.events")
                .partitions(6)
                .replicas(3)
                .config("retention.ms", "604800000") // 7 days
                .config("compression.type", "snappy")
                .config("cleanup.policy", "delete")
                .build();
    }

    /**
     * Product Events Topic
     */
    @Bean
    public NewTopic productEventsTopic() {
        return TopicBuilder.name("bazar.product.events")
                .partitions(12)
                .replicas(3)
                .config("retention.ms", "2592000000") // 30 days
                .config("compression.type", "snappy")
                .config("cleanup.policy", "delete")
                .build();
    }

    /**
     * Order Events Topic
     */
    @Bean
    public NewTopic orderEventsTopic() {
        return TopicBuilder.name("bazar.order.events")
                .partitions(8)
                .replicas(3)
                .config("retention.ms", "7776000000") // 90 days
                .config("compression.type", "snappy")
                .config("cleanup.policy", "delete")
                .build();
    }

    /**
     * Notification Events Topic
     */
    @Bean
    public NewTopic notificationEventsTopic() {
        return TopicBuilder.name("bazar.notification.events")
                .partitions(4)
                .replicas(3)
                .config("retention.ms", "259200000") // 3 days
                .config("compression.type", "snappy")
                .config("cleanup.policy", "delete")
                .build();
    }

    /**
     * Analytics Events Topic
     */
    @Bean
    public NewTopic analyticsEventsTopic() {
        return TopicBuilder.name("bazar.analytics.events")
                .partitions(16)
                .replicas(3)
                .config("retention.ms", "31536000000") // 365 days
                .config("compression.type", "snappy")
                .config("cleanup.policy", "compact")
                .build();
    }

    /**
     * Dead Letter Queue Topic
     */
    @Bean
    public NewTopic deadLetterTopic() {
        return TopicBuilder.name("bazar.dead.letter.queue")
                .partitions(3)
                .replicas(3)
                .config("retention.ms", "2592000000") // 30 days
                .config("compression.type", "snappy")
                .build();
    }

    // =================================================================
    // KAFKA PRODUCER CONFIGURATION
    // =================================================================

    @Bean
    public ProducerFactory<String, Object> producerFactory() {
        Map<String, Object> configProps = new HashMap<>();
        
        // Connection settings
        configProps.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        
        // Serialization
        configProps.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        configProps.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
        
        // Performance settings for high throughput
        configProps.put(ProducerConfig.ACKS_CONFIG, "all"); // Wait for all replicas
        configProps.put(ProducerConfig.RETRIES_CONFIG, 3);
        configProps.put(ProducerConfig.BATCH_SIZE_CONFIG, 32768); // 32KB batches
        configProps.put(ProducerConfig.LINGER_MS_CONFIG, 10); // Wait 10ms for batching
        configProps.put(ProducerConfig.BUFFER_MEMORY_CONFIG, 67108864); // 64MB buffer
        configProps.put(ProducerConfig.COMPRESSION_TYPE_CONFIG, "snappy");
        
        // Idempotence for exactly-once semantics
        configProps.put(ProducerConfig.ENABLE_IDEMPOTENCE_CONFIG, true);
        configProps.put(ProducerConfig.MAX_IN_FLIGHT_REQUESTS_PER_CONNECTION, 5);
        
        // Timeout settings
        configProps.put(ProducerConfig.REQUEST_TIMEOUT_MS_CONFIG, 30000);
        configProps.put(ProducerConfig.DELIVERY_TIMEOUT_MS_CONFIG, 120000);
        
        return new DefaultKafkaProducerFactory<>(configProps);
    }

    @Bean
    public KafkaTemplate<String, Object> kafkaTemplate() {
        KafkaTemplate<String, Object> template = new KafkaTemplate<>(producerFactory());
        
        // Enable transaction support
        template.setTransactionIdPrefix("bazar-tx-");
        
        return template;
    }

    // =================================================================
    // KAFKA CONSUMER CONFIGURATION
    // =================================================================

    @Bean
    public ConsumerFactory<String, Object> consumerFactory() {
        Map<String, Object> configProps = new HashMap<>();
        
        // Connection settings
        configProps.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        configProps.put(ConsumerConfig.GROUP_ID_CONFIG, consumerGroupId);
        
        // Deserialization
        configProps.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        configProps.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, JsonDeserializer.class);
        configProps.put(JsonDeserializer.TRUSTED_PACKAGES, "com.bazar.marketplace.events");
        
        // Consumer behavior
        configProps.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        configProps.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, false); // Manual commit
        configProps.put(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, 100);
        configProps.put(ConsumerConfig.MAX_POLL_INTERVAL_MS_CONFIG, 300000); // 5 minutes
        configProps.put(ConsumerConfig.SESSION_TIMEOUT_MS_CONFIG, 30000); // 30 seconds
        configProps.put(ConsumerConfig.HEARTBEAT_INTERVAL_MS_CONFIG, 10000); // 10 seconds
        
        // Performance settings
        configProps.put(ConsumerConfig.FETCH_MIN_BYTES_CONFIG, 1024); // 1KB minimum fetch
        configProps.put(ConsumerConfig.FETCH_MAX_WAIT_MS_CONFIG, 500); // Wait 500ms max
        configProps.put(ConsumerConfig.MAX_PARTITION_FETCH_BYTES_CONFIG, 1048576); // 1MB max per partition
        
        return new DefaultKafkaConsumerFactory<>(configProps);
    }

    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, Object> kafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, Object> factory = 
            new ConcurrentKafkaListenerContainerFactory<>();
        
        factory.setConsumerFactory(consumerFactory());
        
        // Concurrency settings for high throughput
        factory.setConcurrency(3); // 3 consumer threads per partition
        
        // Container properties
        ContainerProperties containerProps = factory.getContainerProperties();
        containerProps.setAckMode(ContainerProperties.AckMode.MANUAL_IMMEDIATE);
        containerProps.setSyncCommits(false); // Async commits for better performance
        containerProps.setCommitLogLevel(org.apache.kafka.clients.consumer.internals.ConsumerUtils.DEFAULT_CLOSE_TIMEOUT_MS);
        
        // Error handling
        factory.setCommonErrorHandler(new org.springframework.kafka.listener.DefaultErrorHandler());
        
        // Enable batch processing
        factory.setBatchListener(true);
        
        return factory;
    }

    // =================================================================
    // KAFKA STREAMS CONFIGURATION
    // =================================================================

    @Bean
    public org.apache.kafka.streams.StreamsConfig streamsConfig() {
        Map<String, Object> props = new HashMap<>();
        
        props.put(org.apache.kafka.streams.StreamsConfig.APPLICATION_ID_CONFIG, "bazar-streams");
        props.put(org.apache.kafka.streams.StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        
        // Serialization
        props.put(org.apache.kafka.streams.StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, 
                 org.apache.kafka.common.serialization.Serdes.String().getClass());
        props.put(org.apache.kafka.streams.StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, 
                 org.apache.kafka.common.serialization.Serdes.String().getClass());
        
        // Performance settings
        props.put(org.apache.kafka.streams.StreamsConfig.NUM_STREAM_THREADS_CONFIG, 4);
        props.put(org.apache.kafka.streams.StreamsConfig.COMMIT_INTERVAL_MS_CONFIG, 1000);
        props.put(org.apache.kafka.streams.StreamsConfig.CACHE_MAX_BYTES_BUFFERING_CONFIG, 10485760); // 10MB
        
        // State store settings
        props.put(org.apache.kafka.streams.StreamsConfig.STATE_DIR_CONFIG, "/tmp/kafka-streams");
        
        // Processing guarantee
        props.put(org.apache.kafka.streams.StreamsConfig.PROCESSING_GUARANTEE_CONFIG, 
                 org.apache.kafka.streams.StreamsConfig.EXACTLY_ONCE_V2);
        
        return new org.apache.kafka.streams.StreamsConfig(props);
    }
}
