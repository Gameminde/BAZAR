package com.bazar.marketplace.events.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

/**
 * Base Event Model for BAZAR Event-Driven Architecture
 * 
 * All domain events extend this base class to ensure consistency
 * across the microservices architecture
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public abstract class BaseEvent {

    @JsonProperty("eventId")
    private String eventId = UUID.randomUUID().toString();

    @JsonProperty("eventType")
    private String eventType;

    @JsonProperty("aggregateId")
    private String aggregateId;

    @JsonProperty("aggregateType")
    private String aggregateType;

    @JsonProperty("version")
    private Long version = 1L;

    @JsonProperty("timestamp")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS")
    private LocalDateTime timestamp = LocalDateTime.now();

    @JsonProperty("source")
    private String source;

    @JsonProperty("correlationId")
    private String correlationId;

    @JsonProperty("causationId")
    private String causationId;

    @JsonProperty("userId")
    private String userId;

    @JsonProperty("sessionId")
    private String sessionId;

    @JsonProperty("metadata")
    private Map<String, Object> metadata;

    /**
     * Constructor with required fields
     */
    public BaseEvent(String eventType, String aggregateId, String aggregateType, String source) {
        this();
        this.eventType = eventType;
        this.aggregateId = aggregateId;
        this.aggregateType = aggregateType;
        this.source = source;
    }

    /**
     * Constructor with correlation context
     */
    public BaseEvent(String eventType, String aggregateId, String aggregateType, String source,
                    String correlationId, String userId) {
        this(eventType, aggregateId, aggregateType, source);
        this.correlationId = correlationId;
        this.userId = userId;
    }
}
