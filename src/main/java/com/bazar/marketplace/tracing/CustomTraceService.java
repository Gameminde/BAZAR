package com.bazar.marketplace.tracing;

import brave.Span;
import brave.Tracer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * Custom Tracing Service for Business Operations
 * 
 * Provides custom spans and tags for business-specific operations
 * Enables detailed monitoring of critical business flows
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class CustomTraceService {

    private final Tracer tracer;

    /**
     * Trace user authentication operations
     */
    public void traceUserAuthentication(String userId, String operation, boolean success) {
        Span span = tracer.nextSpan()
                .name("user.authentication")
                .tag("user.id", userId)
                .tag("operation", operation)
                .tag("success", String.valueOf(success))
                .tag("component", "user-service")
                .start();
        
        try (Tracer.SpanInScope ws = tracer.withSpanInScope(span)) {
            log.debug("Tracing user authentication: userId={}, operation={}, success={}", 
                     userId, operation, success);
            
            if (!success) {
                span.tag("error", "Authentication failed");
            }
        } finally {
            span.end();
        }
    }

    /**
     * Trace product search operations
     */
    public void traceProductSearch(String searchQuery, int resultCount, long responseTime) {
        Span span = tracer.nextSpan()
                .name("product.search")
                .tag("search.query", searchQuery)
                .tag("result.count", String.valueOf(resultCount))
                .tag("response.time.ms", String.valueOf(responseTime))
                .tag("component", "product-service")
                .start();
        
        try (Tracer.SpanInScope ws = tracer.withSpanInScope(span)) {
            log.debug("Tracing product search: query={}, results={}, responseTime={}ms", 
                     searchQuery, resultCount, responseTime);
                     
            if (responseTime > 1000) {
                span.tag("slow.query", "true");
            }
        } finally {
            span.end();
        }
    }

    /**
     * Trace order processing operations
     */
    public void traceOrderProcessing(String orderId, String status, String paymentMethod, 
                                   double amount, boolean success) {
        Span span = tracer.nextSpan()
                .name("order.processing")
                .tag("order.id", orderId)
                .tag("order.status", status)
                .tag("payment.method", paymentMethod)
                .tag("order.amount", String.valueOf(amount))
                .tag("success", String.valueOf(success))
                .tag("component", "order-service")
                .start();
        
        try (Tracer.SpanInScope ws = tracer.withSpanInScope(span)) {
            log.debug("Tracing order processing: orderId={}, status={}, amount={}, success={}", 
                     orderId, status, amount, success);
                     
            if (!success) {
                span.tag("error", "Order processing failed");
            }
            
            if (amount > 1000) {
                span.tag("high.value.order", "true");
            }
        } finally {
            span.end();
        }
    }

    /**
     * Trace notification delivery
     */
    public void traceNotificationDelivery(String notificationId, String type, 
                                         String channel, boolean delivered) {
        Span span = tracer.nextSpan()
                .name("notification.delivery")
                .tag("notification.id", notificationId)
                .tag("notification.type", type)
                .tag("delivery.channel", channel)
                .tag("delivered", String.valueOf(delivered))
                .tag("component", "notification-service")
                .start();
        
        try (Tracer.SpanInScope ws = tracer.withSpanInScope(span)) {
            log.debug("Tracing notification delivery: id={}, type={}, channel={}, delivered={}", 
                     notificationId, type, channel, delivered);
                     
            if (!delivered) {
                span.tag("error", "Notification delivery failed");
            }
        } finally {
            span.end();
        }
    }

    /**
     * Trace analytics operations
     */
    public void traceAnalyticsOperation(String operation, Map<String, String> parameters, 
                                       long processingTime) {
        Span span = tracer.nextSpan()
                .name("analytics.operation")
                .tag("operation", operation)
                .tag("processing.time.ms", String.valueOf(processingTime))
                .tag("component", "analytics-service")
                .start();
        
        // Add parameter tags
        parameters.forEach(span::tag);
        
        try (Tracer.SpanInScope ws = tracer.withSpanInScope(span)) {
            log.debug("Tracing analytics operation: operation={}, processingTime={}ms", 
                     operation, processingTime);
                     
            if (processingTime > 5000) {
                span.tag("slow.operation", "true");
            }
        } finally {
            span.end();
        }
    }

    /**
     * Trace API Gateway operations
     */
    public void traceGatewayRequest(String serviceName, String endpoint, String method, 
                                   int statusCode, long responseTime) {
        Span span = tracer.nextSpan()
                .name("gateway.request")
                .tag("target.service", serviceName)
                .tag("http.endpoint", endpoint)
                .tag("http.method", method)
                .tag("http.status.code", String.valueOf(statusCode))
                .tag("response.time.ms", String.valueOf(responseTime))
                .tag("component", "api-gateway")
                .start();
        
        try (Tracer.SpanInScope ws = tracer.withSpanInScope(span)) {
            log.debug("Tracing gateway request: service={}, endpoint={}, method={}, status={}, responseTime={}ms", 
                     serviceName, endpoint, method, statusCode, responseTime);
                     
            if (statusCode >= 400) {
                span.tag("error", "true");
            }
            
            if (responseTime > 2000) {
                span.tag("slow.request", "true");
            }
        } finally {
            span.end();
        }
    }

    /**
     * Create custom span for business operations
     */
    public Span createBusinessSpan(String operationName, String component) {
        return tracer.nextSpan()
                .name(operationName)
                .tag("component", component)
                .tag("business.operation", "true")
                .start();
    }

    /**
     * Add error information to current span
     */
    public void addErrorToSpan(Throwable throwable) {
        Span currentSpan = tracer.currentSpan();
        if (currentSpan != null) {
            currentSpan.tag("error", "true")
                      .tag("error.class", throwable.getClass().getSimpleName())
                      .tag("error.message", throwable.getMessage());
        }
    }

    /**
     * Add custom tags to current span
     */
    public void addTagsToCurrentSpan(Map<String, String> tags) {
        Span currentSpan = tracer.currentSpan();
        if (currentSpan != null) {
            tags.forEach(currentSpan::tag);
        }
    }
}
