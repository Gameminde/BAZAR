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
 * Entity Cart - Panier d'achat BAZAR Marketplace
 * 
 * Représente un panier d'achat avec ses articles et calculs
 * de prix pour un utilisateur donné.
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Entity
@Table(name = "carts", 
       indexes = {
           @Index(name = "idx_cart_user", columnList = "user_id"),
           @Index(name = "idx_cart_session", columnList = "session_id"),
           @Index(name = "idx_cart_created_at", columnList = "created_at")
       })
@Data
@EqualsAndHashCode(callSuper = false)
@EntityListeners(AuditingEntityListener.class)
public class Cart {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
    
    @Column(name = "session_id", length = 100)
    @Size(max = 100, message = "Session ID cannot exceed 100 characters")
    private String sessionId;
    
    @Column(name = "guest_email", length = 100)
    @Email(message = "Guest email should be valid")
    @Size(max = 100, message = "Guest email cannot exceed 100 characters")
    private String guestEmail;
    
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
    
    @Column(name = "expires_at")
    private LocalDateTime expiresAt;
    
    @Column(name = "abandoned", nullable = false)
    private Boolean abandoned = false;
    
    @Column(name = "abandoned_at")
    private LocalDateTime abandonedAt;
    
    @OneToMany(mappedBy = "cart", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    @OrderBy("createdAt ASC")
    @org.hibernate.annotations.BatchSize(size = 25)
    @org.hibernate.annotations.Fetch(org.hibernate.annotations.FetchMode.SUBSELECT)
    private Set<CartItem> items = new HashSet<>();
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    /**
     * Vérifie si le panier est vide
     * 
     * @return true si le panier est vide, false sinon
     */
    public boolean isEmpty() {
        return items == null || items.isEmpty();
    }
    
    /**
     * Vérifie si le panier a expiré
     * 
     * @return true si le panier a expiré, false sinon
     */
    public boolean isExpired() {
        return expiresAt != null && expiresAt.isBefore(LocalDateTime.now());
    }
    
    /**
     * Vérifie si le panier est valide pour checkout
     * 
     * @return true si le panier est valide, false sinon
     */
    public boolean isValidForCheckout() {
        return !isEmpty() && !isExpired() && !abandoned;
    }
    
    /**
     * Calcule le total du panier
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
            .map(CartItem::getLineTotal)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        totalQuantity = items.stream()
            .mapToInt(CartItem::getQuantity)
            .sum();
        
        itemCount = items.size();
        
        // Calcul du total final
        totalAmount = subtotal
            .add(taxAmount)
            .add(shippingAmount)
            .subtract(discountAmount);
    }
    
    /**
     * Ajoute un article au panier
     * 
     * @param product le produit à ajouter
     * @param quantity la quantité
     * @return l'article ajouté ou mis à jour
     */
    public CartItem addItem(Product product, int quantity) {
        if (items == null) {
            items = new HashSet<>();
        }
        
        // Vérifier si l'article existe déjà
        CartItem existingItem = items.stream()
            .filter(item -> item.getProduct().getId().equals(product.getId()))
            .findFirst()
            .orElse(null);
        
        if (existingItem != null) {
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
            return existingItem;
        }
        
        // Créer un nouvel article
        CartItem newItem = new CartItem();
        newItem.setCart(this);
        newItem.setProduct(product);
        newItem.setQuantity(quantity);
        newItem.setPrice(product.getPrice());
        
        items.add(newItem);
        return newItem;
    }
    
    /**
     * Supprime un article du panier
     * 
     * @param productId l'ID du produit à supprimer
     * @return true si l'article a été supprimé, false sinon
     */
    public boolean removeItem(Long productId) {
        if (items == null) {
            return false;
        }
        
        return items.removeIf(item -> item.getProduct().getId().equals(productId));
    }
    
    /**
     * Vide le panier
     */
    public void clear() {
        if (items != null) {
            items.clear();
        }
        calculateTotals();
    }
    
    /**
     * Marque le panier comme abandonné
     */
    public void markAsAbandoned() {
        this.abandoned = true;
        this.abandonedAt = LocalDateTime.now();
    }
    
    /**
     * Obtient un article par ID de produit
     * 
     * @param productId l'ID du produit
     * @return l'article ou null si non trouvé
     */
    public CartItem getItemByProductId(Long productId) {
        if (items == null) {
            return null;
        }
        
        return items.stream()
            .filter(item -> item.getProduct().getId().equals(productId))
            .findFirst()
            .orElse(null);
    }
}
