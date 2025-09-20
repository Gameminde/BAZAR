package com.bazar.marketplace.events.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

/**
 * Order Domain Events for BAZAR Marketplace
 * 
 * Events related to order lifecycle, payment processing, and fulfillment
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
public class OrderEvent extends BaseEvent {

    // Event Types
    public static final String ORDER_CREATED = "OrderCreated";
    public static final String ORDER_CONFIRMED = "OrderConfirmed";
    public static final String ORDER_PAID = "OrderPaid";
    public static final String ORDER_SHIPPED = "OrderShipped";
    public static final String ORDER_DELIVERED = "OrderDelivered";
    public static final String ORDER_CANCELLED = "OrderCancelled";
    public static final String ORDER_REFUNDED = "OrderRefunded";
    public static final String PAYMENT_PROCESSED = "PaymentProcessed";
    public static final String PAYMENT_FAILED = "PaymentFailed";

    @JsonProperty("orderNumber")
    private String orderNumber;

    @JsonProperty("customerId")
    private String customerId;

    @JsonProperty("customerEmail")
    private String customerEmail;

    @JsonProperty("orderStatus")
    private String orderStatus;

    @JsonProperty("paymentStatus")
    private String paymentStatus;

    @JsonProperty("paymentMethod")
    private String paymentMethod;

    @JsonProperty("totalAmount")
    private BigDecimal totalAmount;

    @JsonProperty("currency")
    private String currency;

    @JsonProperty("shippingAddress")
    private Object shippingAddress;

    @JsonProperty("billingAddress")
    private Object billingAddress;

    @JsonProperty("orderItems")
    private List<OrderItemData> orderItems;

    @JsonProperty("paymentId")
    private String paymentId;

    @JsonProperty("trackingNumber")
    private String trackingNumber;

    @JsonProperty("reason")
    private String reason;

    @Data
    @NoArgsConstructor
    public static class OrderItemData {
        @JsonProperty("productId")
        private String productId;

        @JsonProperty("productName")
        private String productName;

        @JsonProperty("quantity")
        private Integer quantity;

        @JsonProperty("unitPrice")
        private BigDecimal unitPrice;

        @JsonProperty("totalPrice")
        private BigDecimal totalPrice;
    }

    // Factory methods for specific events

    public static OrderEvent orderCreated(String orderId, String orderNumber, String customerId, 
                                        String customerEmail, BigDecimal totalAmount, String currency,
                                        List<OrderItemData> orderItems, String correlationId) {
        OrderEvent event = new OrderEvent();
        event.setEventType(ORDER_CREATED);
        event.setAggregateId(orderId);
        event.setAggregateType("Order");
        event.setSource("order-service");
        event.setUserId(customerId);
        event.setCorrelationId(correlationId);
        event.setOrderNumber(orderNumber);
        event.setCustomerId(customerId);
        event.setCustomerEmail(customerEmail);
        event.setOrderStatus("CREATED");
        event.setTotalAmount(totalAmount);
        event.setCurrency(currency);
        event.setOrderItems(orderItems);
        return event;
    }

    public static OrderEvent paymentProcessed(String orderId, String orderNumber, String paymentId,
                                            String paymentMethod, BigDecimal amount, String currency,
                                            String customerId, String correlationId) {
        OrderEvent event = new OrderEvent();
        event.setEventType(PAYMENT_PROCESSED);
        event.setAggregateId(orderId);
        event.setAggregateType("Order");
        event.setSource("order-service");
        event.setUserId(customerId);
        event.setCorrelationId(correlationId);
        event.setOrderNumber(orderNumber);
        event.setPaymentId(paymentId);
        event.setPaymentMethod(paymentMethod);
        event.setPaymentStatus("PAID");
        event.setTotalAmount(amount);
        event.setCurrency(currency);
        event.setCustomerId(customerId);
        return event;
    }

    public static OrderEvent orderShipped(String orderId, String orderNumber, String trackingNumber,
                                        String customerId, String correlationId) {
        OrderEvent event = new OrderEvent();
        event.setEventType(ORDER_SHIPPED);
        event.setAggregateId(orderId);
        event.setAggregateType("Order");
        event.setSource("order-service");
        event.setUserId(customerId);
        event.setCorrelationId(correlationId);
        event.setOrderNumber(orderNumber);
        event.setTrackingNumber(trackingNumber);
        event.setOrderStatus("SHIPPED");
        event.setCustomerId(customerId);
        return event;
    }

    public static OrderEvent orderCancelled(String orderId, String orderNumber, String reason,
                                          String customerId, String correlationId) {
        OrderEvent event = new OrderEvent();
        event.setEventType(ORDER_CANCELLED);
        event.setAggregateId(orderId);
        event.setAggregateType("Order");
        event.setSource("order-service");
        event.setUserId(customerId);
        event.setCorrelationId(correlationId);
        event.setOrderNumber(orderNumber);
        event.setReason(reason);
        event.setOrderStatus("CANCELLED");
        event.setCustomerId(customerId);
        return event;
    }
}
