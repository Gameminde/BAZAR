package com.bazar.marketplace.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

/**
 * Entité WishlistItem pour BAZAR Marketplace
 * 
 * Représente un article dans la liste de souhaits d'un utilisateur
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Entity
@Table(name = "wishlist_items")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "id")
public class WishlistItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "wishlist_id", nullable = false)
    private Wishlist wishlist;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;
    
    @Column(name = "notes", length = 500)
    private String notes;
    
    @Column(name = "priority")
    private Integer priority;
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    /**
     * Constructeur pour créer un WishlistItem avec wishlist et produit
     * 
     * @param wishlist la liste de souhaits
     * @param product le produit
     */
    public WishlistItem(Wishlist wishlist, Product product) {
        this.wishlist = wishlist;
        this.product = product;
        this.priority = 1;
    }
    
    /**
     * Constructeur pour créer un WishlistItem avec notes
     * 
     * @param wishlist la liste de souhaits
     * @param product le produit
     * @param notes les notes
     */
    public WishlistItem(Wishlist wishlist, Product product, String notes) {
        this.wishlist = wishlist;
        this.product = product;
        this.notes = notes;
        this.priority = 1;
    }
}
