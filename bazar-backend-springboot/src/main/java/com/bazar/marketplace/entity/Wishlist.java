package com.bazar.marketplace.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Entity Wishlist - Liste de souhaits BAZAR Marketplace
 * 
 * Représente une liste de souhaits d'un utilisateur avec
 * ses articles favoris.
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Entity
@Table(name = "wishlists", 
       indexes = {
           @Index(name = "idx_wishlist_user", columnList = "user_id"),
           @Index(name = "idx_wishlist_name", columnList = "name"),
           @Index(name = "idx_wishlist_created_at", columnList = "created_at")
       })
@Data
@EqualsAndHashCode(callSuper = false)
@EntityListeners(AuditingEntityListener.class)
public class Wishlist {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @NotNull(message = "User is required")
    private User user;
    
    @Column(nullable = false, length = 255)
    @NotBlank(message = "Wishlist name is required")
    @Size(min = 2, max = 255, message = "Wishlist name must be between 2 and 255 characters")
    private String name;
    
    @Column(columnDefinition = "TEXT")
    @Size(max = 1000, message = "Description cannot exceed 1000 characters")
    private String description;
    
    @Column(name = "is_public", nullable = false)
    private Boolean isPublic = false;
    
    @Column(name = "is_default", nullable = false)
    private Boolean isDefault = false;
    
    @Column(name = "item_count", nullable = false)
    @Min(value = 0, message = "Item count cannot be negative")
    private Integer itemCount = 0;
    
    @OneToMany(mappedBy = "wishlist", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    @OrderBy("createdAt ASC")
    private Set<WishlistItem> items = new HashSet<>();
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    /**
     * Vérifie si la liste de souhaits est vide
     * 
     * @return true si la liste est vide, false sinon
     */
    public boolean isEmpty() {
        return items == null || items.isEmpty();
    }
    
    /**
     * Met à jour le compteur d'articles
     */
    public void updateItemCount() {
        this.itemCount = items != null ? items.size() : 0;
    }
    
    /**
     * Ajoute un produit à la liste de souhaits
     * 
     * @param product le produit à ajouter
     * @return l'article ajouté
     */
    public WishlistItem addProduct(Product product) {
        if (items == null) {
            items = new HashSet<>();
        }
        
        // Vérifier si le produit existe déjà
        WishlistItem existingItem = items.stream()
            .filter(item -> item.getProduct().getId().equals(product.getId()))
            .findFirst()
            .orElse(null);
        
        if (existingItem != null) {
            return existingItem;
        }
        
        // Créer un nouvel article
        WishlistItem newItem = new WishlistItem();
        newItem.setWishlist(this);
        newItem.setProduct(product);
        
        items.add(newItem);
        updateItemCount();
        return newItem;
    }
    
    /**
     * Supprime un produit de la liste de souhaits
     * 
     * @param productId l'ID du produit à supprimer
     * @return true si le produit a été supprimé, false sinon
     */
    public boolean removeProduct(Long productId) {
        if (items == null) {
            return false;
        }
        
        boolean removed = items.removeIf(item -> item.getProduct().getId().equals(productId));
        if (removed) {
            updateItemCount();
        }
        return removed;
    }
    
    /**
     * Vide la liste de souhaits
     */
    public void clear() {
        if (items != null) {
            items.clear();
        }
        updateItemCount();
    }
    
    /**
     * Vérifie si un produit est dans la liste de souhaits
     * 
     * @param productId l'ID du produit
     * @return true si le produit est dans la liste, false sinon
     */
    public boolean containsProduct(Long productId) {
        if (items == null) {
            return false;
        }
        
        return items.stream()
            .anyMatch(item -> item.getProduct().getId().equals(productId));
    }
    
    /**
     * Obtient un article par ID de produit
     * 
     * @param productId l'ID du produit
     * @return l'article ou null si non trouvé
     */
    public WishlistItem getItemByProductId(Long productId) {
        if (items == null) {
            return null;
        }
        
        return items.stream()
            .filter(item -> item.getProduct().getId().equals(productId))
            .findFirst()
            .orElse(null);
    }
}
