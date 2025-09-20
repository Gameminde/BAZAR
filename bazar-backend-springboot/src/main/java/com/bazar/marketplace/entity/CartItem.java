package com.bazar.marketplace.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.CreationTimestamp;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entity CartItem - Article du panier BAZAR Marketplace
 * 
 * Représente un article individuel dans un panier avec
 * sa quantité, prix et calculs de ligne.
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Entity
@Table(name = "cart_items", 
       indexes = {
           @Index(name = "idx_cart_item_cart", columnList = "cart_id"),
           @Index(name = "idx_cart_item_product", columnList = "product_id"),
           @Index(name = "idx_cart_item_created_at", columnList = "created_at")
       })
@Data
@EqualsAndHashCode(callSuper = false)
@EntityListeners(AuditingEntityListener.class)
public class CartItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cart_id", nullable = false)
    @NotNull(message = "Cart is required")
    private Cart cart;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    @NotNull(message = "Product is required")
    private Product product;
    
    @Column(nullable = false)
    @NotNull(message = "Quantity is required")
    @Min(value = 1, message = "Quantity must be at least 1")
    @Max(value = 999, message = "Quantity cannot exceed 999")
    private Integer quantity;
    
    @Column(nullable = false, precision = 10, scale = 2)
    @NotNull(message = "Price is required")
    @DecimalMin(value = "0.01", message = "Price must be greater than 0")
    @Digits(integer = 8, fraction = 2, message = "Price format is invalid")
    private BigDecimal price;
    
    @Column(name = "compare_at_price", precision = 10, scale = 2)
    @DecimalMin(value = "0.01", message = "Compare at price must be greater than 0")
    @Digits(integer = 8, fraction = 2, message = "Compare at price format is invalid")
    private BigDecimal compareAtPrice;
    
    @Column(name = "discount_amount", precision = 10, scale = 2, nullable = false)
    @NotNull(message = "Discount amount is required")
    @DecimalMin(value = "0.00", message = "Discount amount cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Discount amount format is invalid")
    private BigDecimal discountAmount = BigDecimal.ZERO;
    
    @Column(name = "tax_amount", precision = 10, scale = 2, nullable = false)
    @NotNull(message = "Tax amount is required")
    @DecimalMin(value = "0.00", message = "Tax amount cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Tax amount format is invalid")
    private BigDecimal taxAmount = BigDecimal.ZERO;
    
    @Column(name = "line_total", precision = 10, scale = 2, nullable = false)
    @NotNull(message = "Line total is required")
    @DecimalMin(value = "0.00", message = "Line total cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Line total format is invalid")
    private BigDecimal lineTotal = BigDecimal.ZERO;
    
    @Column(name = "notes", length = 500)
    @Size(max = 500, message = "Notes cannot exceed 500 characters")
    private String notes;
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    /**
     * Calcule le total de la ligne
     */
    public void calculateLineTotal() {
        if (quantity == null || price == null) {
            lineTotal = BigDecimal.ZERO;
            return;
        }
        
        BigDecimal subtotal = price.multiply(BigDecimal.valueOf(quantity));
        lineTotal = subtotal.add(taxAmount).subtract(discountAmount);
    }
    
    /**
     * Met à jour la quantité et recalcule le total
     * 
     * @param newQuantity la nouvelle quantité
     */
    public void updateQuantity(int newQuantity) {
        this.quantity = newQuantity;
        calculateLineTotal();
    }
    
    /**
     * Met à jour le prix et recalcule le total
     * 
     * @param newPrice le nouveau prix
     */
    public void updatePrice(BigDecimal newPrice) {
        this.price = newPrice;
        calculateLineTotal();
    }
    
    /**
     * Applique une remise et recalcule le total
     * 
     * @param discountPercent le pourcentage de remise (0-100)
     */
    public void applyDiscount(BigDecimal discountPercent) {
        if (discountPercent == null || discountPercent.compareTo(BigDecimal.ZERO) <= 0) {
            this.discountAmount = BigDecimal.ZERO;
        } else {
            BigDecimal subtotal = price.multiply(BigDecimal.valueOf(quantity));
            this.discountAmount = subtotal.multiply(discountPercent.divide(BigDecimal.valueOf(100)));
        }
        calculateLineTotal();
    }
    
    /**
     * Applique une remise fixe et recalcule le total
     * 
     * @param fixedDiscount le montant de remise fixe
     */
    public void applyFixedDiscount(BigDecimal fixedDiscount) {
        if (fixedDiscount == null || fixedDiscount.compareTo(BigDecimal.ZERO) <= 0) {
            this.discountAmount = BigDecimal.ZERO;
        } else {
            this.discountAmount = fixedDiscount;
        }
        calculateLineTotal();
    }
    
    /**
     * Applique une taxe et recalcule le total
     * 
     * @param taxPercent le pourcentage de taxe (0-100)
     */
    public void applyTax(BigDecimal taxPercent) {
        if (taxPercent == null || taxPercent.compareTo(BigDecimal.ZERO) <= 0) {
            this.taxAmount = BigDecimal.ZERO;
        } else {
            BigDecimal subtotal = price.multiply(BigDecimal.valueOf(quantity));
            this.taxAmount = subtotal.multiply(taxPercent.divide(BigDecimal.valueOf(100)));
        }
        calculateLineTotal();
    }
    
    /**
     * Obtient le pourcentage de remise
     * 
     * @return le pourcentage de remise ou 0 si pas de remise
     */
    public BigDecimal getDiscountPercentage() {
        if (discountAmount == null || discountAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal subtotal = price.multiply(BigDecimal.valueOf(quantity));
        if (subtotal.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        
        return discountAmount.divide(subtotal, 4, BigDecimal.ROUND_HALF_UP)
                           .multiply(BigDecimal.valueOf(100));
    }
    
    /**
     * Obtient le pourcentage de taxe
     * 
     * @return le pourcentage de taxe ou 0 si pas de taxe
     */
    public BigDecimal getTaxPercentage() {
        if (taxAmount == null || taxAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal subtotal = price.multiply(BigDecimal.valueOf(quantity));
        if (subtotal.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        
        return taxAmount.divide(subtotal, 4, BigDecimal.ROUND_HALF_UP)
                       .multiply(BigDecimal.valueOf(100));
    }
    
    /**
     * Vérifie si l'article a une remise
     * 
     * @return true si l'article a une remise, false sinon
     */
    public boolean hasDiscount() {
        return discountAmount != null && discountAmount.compareTo(BigDecimal.ZERO) > 0;
    }
    
    /**
     * Vérifie si l'article a une taxe
     * 
     * @return true si l'article a une taxe, false sinon
     */
    public boolean hasTax() {
        return taxAmount != null && taxAmount.compareTo(BigDecimal.ZERO) > 0;
    }
}
