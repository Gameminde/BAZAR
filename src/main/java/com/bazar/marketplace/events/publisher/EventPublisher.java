package com.bazar.marketplace.events.publisher;

import com.bazar.marketplace.events.model.BaseEvent;
import com.bazar.marketplace.tracing.CustomTraceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Service;
import org.springframework.util.concurrent.ListenableFutureCallback;

import java.util.concurrent.CompletableFuture;

/**
 * Event Publisher for BAZAR Event-Driven Architecture
 * 
 * Publishes domain events to Kafka topics with tracing and error handling
 * Ensures reliable event delivery across microservices
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EventPublisher {

    private final KafkaTemplate<String, Object> kafkaTemplate;
    private final CustomTraceService traceService;

    // Topic constants
    private static final String USER_EVENTS_TOPIC = "bazar.user.events";
    private static final String PRODUCT_EVENTS_TOPIC = "bazar.product.events";
    private static final String ORDER_EVENTS_TOPIC = "bazar.order.events";
    private static final String NOTIFICATION_EVENTS_TOPIC = "bazar.notification.events";
    private static final String ANALYTICS_EVENTS_TOPIC = "bazar.analytics.events";

    /**
     * Publish event to appropriate topic based on aggregate type
     */
    public CompletableFuture<SendResult<String, Object>> publishEvent(BaseEvent event) {
        String topic = determineTopicByAggregateType(event.getAggregateType());
        return publishEvent(topic, event.getAggregateId(), event);
    }

    /**
     * Publish event to specific topic
     */
    public CompletableFuture<SendResult<String, Object>> publishEvent(String topic, String key, BaseEvent event) {
        log.debug("Publishing event: type={}, aggregateId={}, topic={}", 
                 event.getEventType(), event.getAggregateId(), topic);

        // Add tracing information
        traceService.addTagsToCurrentSpan(java.util.Map.of(
            "event.type", event.getEventType(),
            "event.aggregate.id", event.getAggregateId(),
            "event.aggregate.type", event.getAggregateType(),
            "kafka.topic", topic,
            "kafka.key", key
        ));

        // Send to Kafka
        CompletableFuture<SendResult<String, Object>> future = kafkaTemplate.send(topic, key, event);

        // Add callback for success/failure handling
        future.whenComplete((result, throwable) -> {
            if (throwable == null) {
                handleEventPublishSuccess(event, topic, result);
            } else {
                handleEventPublishFailure(event, topic, throwable);
            }
        });

        return future;
    }

    /**
     * Publish user events
     */
    public CompletableFuture<SendResult<String, Object>> publishUserEvent(BaseEvent event) {
        return publishEvent(USER_EVENTS_TOPIC, event.getAggregateId(), event);
    }

    /**
     * Publish product events
     */
    public CompletableFuture<SendResult<String, Object>> publishProductEvent(BaseEvent event) {
        return publishEvent(PRODUCT_EVENTS_TOPIC, event.getAggregateId(), event);
    }

    /**
     * Publish order events
     */
    public CompletableFuture<SendResult<String, Object>> publishOrderEvent(BaseEvent event) {
        return publishEvent(ORDER_EVENTS_TOPIC, event.getAggregateId(), event);
    }

    /**
     * Publish notification events
     */
    public CompletableFuture<SendResult<String, Object>> publishNotificationEvent(BaseEvent event) {
        return publishEvent(NOTIFICATION_EVENTS_TOPIC, event.getAggregateId(), event);
    }

    /**
     * Publish analytics events
     */
    public CompletableFuture<SendResult<String, Object>> publishAnalyticsEvent(BaseEvent event) {
        return publishEvent(ANALYTICS_EVENTS_TOPIC, event.getAggregateId(), event);
    }

    /**
     * Batch publish events (for high-throughput scenarios)
     */
    public void publishEventsBatch(java.util.List<BaseEvent> events) {
        log.debug("Publishing batch of {} events", events.size());

        events.parallelStream().forEach(event -> {
            try {
                publishEvent(event);
            } catch (Exception e) {
                log.error("Failed to publish event in batch: eventId={}, eventType={}", 
                         event.getEventId(), event.getEventType(), e);
                // Continue with other events in batch
            }
        });
    }

    // Private helper methods

    private String determineTopicByAggregateType(String aggregateType) {
        return switch (aggregateType.toLowerCase()) {
            case "user" -> USER_EVENTS_TOPIC;
            case "product" -> PRODUCT_EVENTS_TOPIC;
            case "order" -> ORDER_EVENTS_TOPIC;
            case "notification" -> NOTIFICATION_EVENTS_TOPIC;
            case "analytics" -> ANALYTICS_EVENTS_TOPIC;
            default -> {
                log.warn("Unknown aggregate type: {}, defaulting to analytics topic", aggregateType);
                yield ANALYTICS_EVENTS_TOPIC;
            }
        };
    }

    private void handleEventPublishSuccess(BaseEvent event, String topic, SendResult<String, Object> result) {
        log.debug("Successfully published event: eventId={}, eventType={}, topic={}, partition={}, offset={}", 
                 event.getEventId(), event.getEventType(), topic, 
                 result.getRecordMetadata().partition(), result.getRecordMetadata().offset());

        // Add success metrics
        traceService.addTagsToCurrentSpan(java.util.Map.of(
            "kafka.publish.success", "true",
            "kafka.partition", String.valueOf(result.getRecordMetadata().partition()),
            "kafka.offset", String.valueOf(result.getRecordMetadata().offset())
        ));
    }

    private void handleEventPublishFailure(BaseEvent event, String topic, Throwable throwable) {
        log.error("Failed to publish event: eventId={}, eventType={}, topic={}", 
                 event.getEventId(), event.getEventType(), topic, throwable);

        // Add error to tracing
        traceService.addErrorToSpan(throwable);
        traceService.addTagsToCurrentSpan(java.util.Map.of(
            "kafka.publish.success", "false",
            "kafka.error.message", throwable.getMessage()
        ));

        // TODO: Implement dead letter queue logic
        // For now, we could store failed events in a database for retry
    }
}
