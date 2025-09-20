package com.bazar.marketplace.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Entity Order - Commande BAZAR Marketplace
 * 
 * Représente une commande avec ses informations de facturation,
 * livraison et statut de traitement.
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Entity
@Table(name = "orders", 
       indexes = {
           @Index(name = "idx_order_user", columnList = "user_id"),
           @Index(name = "idx_order_number", columnList = "order_number", unique = true),
           @Index(name = "idx_order_status", columnList = "status"),
           @Index(name = "idx_order_created_at", columnList = "created_at"),
           @Index(name = "idx_order_email", columnList = "customer_email")
       })
@Data
@EqualsAndHashCode(callSuper = false)
@EntityListeners(AuditingEntityListener.class)
public class Order {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "order_number", unique = true, length = 50, nullable = false)
    @NotBlank(message = "Order number is required")
    @Size(max = 50, message = "Order number cannot exceed 50 characters")
    private String orderNumber;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
    
    @Column(name = "customer_email", length = 100, nullable = false)
    @NotBlank(message = "Customer email is required")
    @Email(message = "Customer email should be valid")
    @Size(max = 100, message = "Customer email cannot exceed 100 characters")
    private String customerEmail;
    
    @Column(name = "customer_first_name", length = 50, nullable = false)
    @NotBlank(message = "Customer first name is required")
    @Size(max = 50, message = "Customer first name cannot exceed 50 characters")
    private String customerFirstName;
    
    @Column(name = "customer_last_name", length = 50, nullable = false)
    @NotBlank(message = "Customer last name is required")
    @Size(max = 50, message = "Customer last name cannot exceed 50 characters")
    private String customerLastName;
    
    @Column(name = "customer_phone", length = 20)
    @Pattern(regexp = "^\\+?[1-9]\\d{1,14}$", message = "Customer phone format is invalid")
    private String customerPhone;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @NotNull(message = "Order status is required")
    private OrderStatus status = OrderStatus.PENDING;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false)
    @NotNull(message = "Payment status is required")
    private PaymentStatus paymentStatus = PaymentStatus.PENDING;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "fulfillment_status", nullable = false)
    @NotNull(message = "Fulfillment status is required")
    private FulfillmentStatus fulfillmentStatus = FulfillmentStatus.UNFULFILLED;
    
    @Column(name = "currency_code", length = 3, nullable = false)
    @NotBlank(message = "Currency code is required")
    @Size(min = 3, max = 3, message = "Currency code must be exactly 3 characters")
    @Pattern(regexp = "^[A-Z]{3}$", message = "Currency code must be uppercase letters")
    private String currencyCode = "DZD";
    
    @Column(name = "subtotal", precision = 10, scale = 2, nullable = false)
    @NotNull(message = "Subtotal is required")
    @DecimalMin(value = "0.00", message = "Subtotal cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Subtotal format is invalid")
    private BigDecimal subtotal = BigDecimal.ZERO;
    
    @Column(name = "tax_amount", precision = 10, scale = 2, nullable = false)
    @NotNull(message = "Tax amount is required")
    @DecimalMin(value = "0.00", message = "Tax amount cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Tax amount format is invalid")
    private BigDecimal taxAmount = BigDecimal.ZERO;
    
    @Column(name = "shipping_amount", precision = 10, scale = 2, nullable = false)
    @NotNull(message = "Shipping amount is required")
    @DecimalMin(value = "0.00", message = "Shipping amount cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Shipping amount format is invalid")
    private BigDecimal shippingAmount = BigDecimal.ZERO;
    
    @Column(name = "discount_amount", precision = 10, scale = 2, nullable = false)
    @NotNull(message = "Discount amount is required")
    @DecimalMin(value = "0.00", message = "Discount amount cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Discount amount format is invalid")
    private BigDecimal discountAmount = BigDecimal.ZERO;
    
    @Column(name = "total_amount", precision = 10, scale = 2, nullable = false)
    @NotNull(message = "Total amount is required")
    @DecimalMin(value = "0.00", message = "Total amount cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Total amount format is invalid")
    private BigDecimal totalAmount = BigDecimal.ZERO;
    
    @Column(name = "item_count", nullable = false)
    @Min(value = 0, message = "Item count cannot be negative")
    private Integer itemCount = 0;
    
    @Column(name = "total_quantity", nullable = false)
    @Min(value = 0, message = "Total quantity cannot be negative")
    private Integer totalQuantity = 0;
    
    @Column(name = "coupon_code", length = 50)
    @Size(max = 50, message = "Coupon code cannot exceed 50 characters")
    private String couponCode;
    
    @Column(name = "notes", length = 1000)
    @Size(max = 1000, message = "Notes cannot exceed 1000 characters")
    private String notes;
    
    @Column(name = "internal_notes", length = 1000)
    @Size(max = 1000, message = "Internal notes cannot exceed 1000 characters")
    private String internalNotes;
    
    @Column(name = "processed_at")
    private LocalDateTime processedAt;
    
    @Column(name = "shipped_at")
    private LocalDateTime shippedAt;
    
    @Column(name = "delivered_at")
    private LocalDateTime deliveredAt;
    
    @Column(name = "cancelled_at")
    private LocalDateTime cancelledAt;
    
    @Column(name = "refunded_at")
    private LocalDateTime refundedAt;
    
    @Column(name = "cancellation_reason", length = 500)
    @Size(max = 500, message = "Cancellation reason cannot exceed 500 characters")
    private String cancellationReason;
    
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    @OrderBy("createdAt ASC")
    @org.hibernate.annotations.BatchSize(size = 25)
    @org.hibernate.annotations.Fetch(org.hibernate.annotations.FetchMode.SUBSELECT)
    private Set<OrderItem> items = new HashSet<>();
    
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    private Set<OrderAddress> addresses = new HashSet<>();
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    /**
     * Vérifie si la commande peut être annulée
     * 
     * @return true si la commande peut être annulée, false sinon
     */
    public boolean canBeCancelled() {
        return status == OrderStatus.PENDING || 
               status == OrderStatus.CONFIRMED || 
               status == OrderStatus.PROCESSING;
    }
    
    /**
     * Vérifie si la commande peut être remboursée
     * 
     * @return true si la commande peut être remboursée, false sinon
     */
    public boolean canBeRefunded() {
        return paymentStatus == PaymentStatus.PAID && 
               (status == OrderStatus.DELIVERED || status == OrderStatus.SHIPPED);
    }
    
    /**
     * Vérifie si la commande est complète
     * 
     * @return true si la commande est complète, false sinon
     */
    public boolean isComplete() {
        return status == OrderStatus.DELIVERED && 
               paymentStatus == PaymentStatus.PAID;
    }
    
    /**
     * Calcule le total de la commande
     */
    public void calculateTotals() {
        if (items == null || items.isEmpty()) {
            subtotal = BigDecimal.ZERO;
            taxAmount = BigDecimal.ZERO;
            shippingAmount = BigDecimal.ZERO;
            discountAmount = BigDecimal.ZERO;
            totalAmount = BigDecimal.ZERO;
            itemCount = 0;
            totalQuantity = 0;
            return;
        }
        
        subtotal = items.stream()
            .map(OrderItem::getLineTotal)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        totalQuantity = items.stream()
            .mapToInt(OrderItem::getQuantity)
            .sum();
        
        itemCount = items.size();
        
        // Calcul du total final
        totalAmount = subtotal
            .add(taxAmount)
            .add(shippingAmount)
            .subtract(discountAmount);
    }
    
    /**
     * Annule la commande
     * 
     * @param reason la raison de l'annulation
     */
    public void cancel(String reason) {
        this.status = OrderStatus.CANCELLED;
        this.cancelledAt = LocalDateTime.now();
        this.cancellationReason = reason;
    }
    
    /**
     * Marque la commande comme remboursée
     */
    public void refund() {
        this.paymentStatus = PaymentStatus.REFUNDED;
        this.refundedAt = LocalDateTime.now();
    }
    
    /**
     * Marque la commande comme traitée
     */
    public void process() {
        this.status = OrderStatus.PROCESSING;
        this.processedAt = LocalDateTime.now();
    }
    
    /**
     * Marque la commande comme expédiée
     */
    public void ship() {
        this.status = OrderStatus.SHIPPED;
        this.fulfillmentStatus = FulfillmentStatus.FULFILLED;
        this.shippedAt = LocalDateTime.now();
    }
    
    /**
     * Marque la commande comme livrée
     */
    public void deliver() {
        this.status = OrderStatus.DELIVERED;
        this.deliveredAt = LocalDateTime.now();
    }
    
    /**
     * Statuts de commande
     */
    public enum OrderStatus {
        PENDING("Pending"),
        CONFIRMED("Confirmed"),
        PROCESSING("Processing"),
        SHIPPED("Shipped"),
        DELIVERED("Delivered"),
        CANCELLED("Cancelled"),
        RETURNED("Returned");
        
        private final String displayName;
        
        OrderStatus(String displayName) {
            this.displayName = displayName;
        }
        
        public String getDisplayName() {
            return displayName;
        }
    }
    
    /**
     * Statuts de paiement
     */
    public enum PaymentStatus {
        PENDING("Pending"),
        PAID("Paid"),
        PARTIALLY_PAID("Partially Paid"),
        REFUNDED("Refunded"),
        PARTIALLY_REFUNDED("Partially Refunded"),
        FAILED("Failed");
        
        private final String displayName;
        
        PaymentStatus(String displayName) {
            this.displayName = displayName;
        }
        
        public String getDisplayName() {
            return displayName;
        }
    }
    
    /**
     * Statuts de fulfillment
     */
    public enum FulfillmentStatus {
        UNFULFILLED("Unfulfilled"),
        PARTIALLY_FULFILLED("Partially Fulfilled"),
        FULFILLED("Fulfilled"),
        RESTOCKED("Restocked");
        
        private final String displayName;
        
        FulfillmentStatus(String displayName) {
            this.displayName = displayName;
        }
        
        public String getDisplayName() {
            return displayName;
        }
    }
}
