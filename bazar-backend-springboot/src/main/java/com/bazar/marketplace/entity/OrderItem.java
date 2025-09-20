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
 * Entity OrderItem - Article de commande BAZAR Marketplace
 * 
 * Représente un article individuel dans une commande avec
 * sa quantité, prix et calculs de ligne.
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Entity
@Table(name = "order_items", 
       indexes = {
           @Index(name = "idx_order_item_order", columnList = "order_id"),
           @Index(name = "idx_order_item_product", columnList = "product_id"),
           @Index(name = "idx_order_item_created_at", columnList = "created_at")
       })
@Data
@EqualsAndHashCode(callSuper = false)
@EntityListeners(AuditingEntityListener.class)
public class OrderItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    @NotNull(message = "Order is required")
    private Order order;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    @NotNull(message = "Product is required")
    private Product product;
    
    @Column(name = "product_name", length = 255, nullable = false)
    @NotBlank(message = "Product name is required")
    @Size(max = 255, message = "Product name cannot exceed 255 characters")
    private String productName;
    
    @Column(name = "product_sku", length = 100)
    @Size(max = 100, message = "Product SKU cannot exceed 100 characters")
    private String productSku;
    
    @Column(columnDefinition = "TEXT")
    @Size(max = 2000, message = "Product description cannot exceed 2000 characters")
    private String productDescription;
    
    @Column(name = "product_image_url", length = 500)
    @Size(max = 500, message = "Product image URL cannot exceed 500 characters")
    private String productImageUrl;
    
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
    
    @Column(name = "cost_price", precision = 10, scale = 2)
    @DecimalMin(value = "0.00", message = "Cost price cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Cost price format is invalid")
    private BigDecimal costPrice;
    
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
    
    @Column(name = "weight", precision = 8, scale = 3)
    @DecimalMin(value = "0.000", message = "Weight cannot be negative")
    private BigDecimal weight;
    
    @Column(name = "length", precision = 8, scale = 2)
    @DecimalMin(value = "0.00", message = "Length cannot be negative")
    private BigDecimal length;
    
    @Column(name = "width", precision = 8, scale = 2)
    @DecimalMin(value = "0.00", message = "Width cannot be negative")
    private BigDecimal width;
    
    @Column(name = "height", precision = 8, scale = 2)
    @DecimalMin(value = "0.00", message = "Height cannot be negative")
    private BigDecimal height;
    
    @Column(name = "requires_shipping", nullable = false)
    private Boolean requiresShipping = true;
    
    @Column(name = "is_digital", nullable = false)
    private Boolean isDigital = false;
    
    @Column(name = "is_downloadable", nullable = false)
    private Boolean isDownloadable = false;
    
    @Column(name = "is_virtual", nullable = false)
    private Boolean isVirtual = false;
    
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
     * Obtient le pourcentage de réduction par rapport au prix de comparaison
     * 
     * @return le pourcentage de réduction ou 0 si pas de prix de comparaison
     */
    public BigDecimal getSavingsPercentage() {
        if (compareAtPrice == null || compareAtPrice.compareTo(price) <= 0) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal savings = compareAtPrice.subtract(price);
        return savings.divide(compareAtPrice, 4, BigDecimal.ROUND_HALF_UP)
                     .multiply(BigDecimal.valueOf(100));
    }
    
    /**
     * Obtient le montant des économies par rapport au prix de comparaison
     * 
     * @return le montant des économies
     */
    public BigDecimal getSavingsAmount() {
        if (compareAtPrice == null || compareAtPrice.compareTo(price) <= 0) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal savingsPerUnit = compareAtPrice.subtract(price);
        return savingsPerUnit.multiply(BigDecimal.valueOf(quantity));
    }
    
    /**
     * Obtient le volume total de l'article
     * 
     * @return le volume total (longueur × largeur × hauteur × quantité)
     */
    public BigDecimal getTotalVolume() {
        if (length == null || width == null || height == null || quantity == null) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal volumePerUnit = length.multiply(width).multiply(height);
        return volumePerUnit.multiply(BigDecimal.valueOf(quantity));
    }
    
    /**
     * Obtient le poids total de l'article
     * 
     * @return le poids total (poids unitaire × quantité)
     */
    public BigDecimal getTotalWeight() {
        if (weight == null || quantity == null) {
            return BigDecimal.ZERO;
        }
        
        return weight.multiply(BigDecimal.valueOf(quantity));
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
    
    /**
     * Vérifie si l'article nécessite une expédition
     * 
     * @return true si l'article nécessite une expédition, false sinon
     */
    public boolean needsShipping() {
        return requiresShipping && !isDigital && !isVirtual;
    }
}
