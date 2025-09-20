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
 * Entity Product - Produit du catalogue BAZAR Marketplace
 * 
 * Représente un produit avec ses informations détaillées,
 * prix, stock et relations avec les catégories.
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Entity
@Table(name = "products", 
       indexes = {
           @Index(name = "idx_product_name", columnList = "name"),
           @Index(name = "idx_product_sku", columnList = "sku", unique = true),
           @Index(name = "idx_product_category", columnList = "category_id"),
           @Index(name = "idx_product_price", columnList = "price"),
           @Index(name = "idx_product_active", columnList = "active"),
           @Index(name = "idx_product_created_at", columnList = "created_at")
       })
@org.hibernate.annotations.Cache(usage = org.hibernate.annotations.CacheConcurrencyStrategy.READ_WRITE)
@Data
@EqualsAndHashCode(callSuper = false)
@EntityListeners(AuditingEntityListener.class)
public class Product {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 255)
    @NotBlank(message = "Product name is required")
    @Size(min = 2, max = 255, message = "Product name must be between 2 and 255 characters")
    private String name;
    
    @Column(unique = true, length = 100)
    @NotBlank(message = "SKU is required")
    @Size(max = 100, message = "SKU cannot exceed 100 characters")
    @Pattern(regexp = "^[A-Z0-9-_]+$", message = "SKU must contain only uppercase letters, numbers, hyphens and underscores")
    private String sku;
    
    @Column(columnDefinition = "TEXT")
    @Size(max = 5000, message = "Description cannot exceed 5000 characters")
    private String description;
    
    @Column(columnDefinition = "TEXT")
    @Size(max = 10000, message = "Long description cannot exceed 10000 characters")
    private String longDescription;
    
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
    
    @Column(name = "stock_quantity", nullable = false)
    @Min(value = 0, message = "Stock quantity cannot be negative")
    private Integer stockQuantity = 0;
    
    @Column(name = "low_stock_threshold")
    @Min(value = 0, message = "Low stock threshold cannot be negative")
    private Integer lowStockThreshold = 5;
    
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
    
    @Column(name = "image_url", length = 500)
    @Size(max = 500, message = "Image URL cannot exceed 500 characters")
    private String imageUrl;
    
    @ElementCollection
    @CollectionTable(name = "product_images", joinColumns = @JoinColumn(name = "product_id"))
    @Column(name = "image_url", length = 500)
    private Set<String> additionalImages = new HashSet<>();
    
    @Column(nullable = false)
    private Boolean active = true;
    
    @Column(name = "featured", nullable = false)
    private Boolean featured = false;
    
    @Column(name = "digital", nullable = false)
    private Boolean digital = false;
    
    @Column(name = "downloadable", nullable = false)
    private Boolean downloadable = false;
    
    @Column(name = "virtual", nullable = false)
    private Boolean virtual = false;
    
    @Column(name = "requires_shipping", nullable = false)
    private Boolean requiresShipping = true;
    
    @Column(name = "track_quantity", nullable = false)
    private Boolean trackQuantity = true;
    
    @Column(name = "allow_backorder", nullable = false)
    private Boolean allowBackorder = false;
    
    @Column(name = "meta_title", length = 255)
    @Size(max = 255, message = "Meta title cannot exceed 255 characters")
    private String metaTitle;
    
    @Column(name = "meta_description", length = 500)
    @Size(max = 500, message = "Meta description cannot exceed 500 characters")
    private String metaDescription;
    
    @Column(name = "meta_keywords", length = 1000)
    @Size(max = 1000, message = "Meta keywords cannot exceed 1000 characters")
    private String metaKeywords;
    
    @Column(name = "view_count", nullable = false)
    private Long viewCount = 0L;
    
    @Column(name = "sold_count", nullable = false)
    private Long soldCount = 0L;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    @NotNull(message = "Category is required")
    private Category category;
    
    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<CartItem> cartItems = new HashSet<>();
    
    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<OrderItem> orderItems = new HashSet<>();
    
    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<WishlistItem> wishlistItems = new HashSet<>();
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    /**
     * Vérifie si le produit est en stock
     * 
     * @return true si le produit est en stock, false sinon
     */
    public boolean isInStock() {
        return active && (stockQuantity > 0 || allowBackorder);
    }
    
    /**
     * Vérifie si le stock est faible
     * 
     * @return true si le stock est faible, false sinon
     */
    public boolean isLowStock() {
        return trackQuantity && stockQuantity <= lowStockThreshold;
    }
    
    /**
     * Calcule le pourcentage de réduction
     * 
     * @return le pourcentage de réduction ou 0 si pas de prix de comparaison
     */
    public BigDecimal getDiscountPercentage() {
        if (compareAtPrice == null || compareAtPrice.compareTo(price) <= 0) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal discount = compareAtPrice.subtract(price);
        return discount.divide(compareAtPrice, 4, BigDecimal.ROUND_HALF_UP)
                      .multiply(BigDecimal.valueOf(100));
    }
    
    /**
     * Incrémente le compteur de vues
     */
    public void incrementViewCount() {
        this.viewCount++;
    }
    
    /**
     * Incrémente le compteur de ventes
     * 
     * @param quantity la quantité vendue
     */
    public void incrementSoldCount(int quantity) {
        this.soldCount += quantity;
    }
}
