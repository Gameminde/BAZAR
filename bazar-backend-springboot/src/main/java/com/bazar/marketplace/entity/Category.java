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
 * Entity Category - Catégorie de produits BAZAR Marketplace
 * 
 * Représente une catégorie avec support hiérarchique pour
 * organiser les produits en arbre de catégories.
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Entity
@Table(name = "categories", 
       indexes = {
           @Index(name = "idx_category_name", columnList = "name"),
           @Index(name = "idx_category_slug", columnList = "slug", unique = true),
           @Index(name = "idx_category_parent", columnList = "parent_id"),
           @Index(name = "idx_category_active", columnList = "active"),
           @Index(name = "idx_category_sort_order", columnList = "sort_order")
       })
@org.hibernate.annotations.Cache(usage = org.hibernate.annotations.CacheConcurrencyStrategy.READ_WRITE)
@Data
@EqualsAndHashCode(callSuper = false)
@EntityListeners(AuditingEntityListener.class)
public class Category {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 255)
    @NotBlank(message = "Category name is required")
    @Size(min = 2, max = 255, message = "Category name must be between 2 and 255 characters")
    private String name;
    
    @Column(unique = true, length = 255)
    @NotBlank(message = "Slug is required")
    @Size(max = 255, message = "Slug cannot exceed 255 characters")
    @Pattern(regexp = "^[a-z0-9-]+$", message = "Slug must contain only lowercase letters, numbers and hyphens")
    private String slug;
    
    @Column(columnDefinition = "TEXT")
    @Size(max = 2000, message = "Description cannot exceed 2000 characters")
    private String description;
    
    @Column(name = "image_url", length = 500)
    @Size(max = 500, message = "Image URL cannot exceed 500 characters")
    private String imageUrl;
    
    @Column(name = "icon_url", length = 500)
    @Size(max = 500, message = "Icon URL cannot exceed 500 characters")
    private String iconUrl;
    
    @Column(name = "meta_title", length = 255)
    @Size(max = 255, message = "Meta title cannot exceed 255 characters")
    private String metaTitle;
    
    @Column(name = "meta_description", length = 500)
    @Size(max = 500, message = "Meta description cannot exceed 500 characters")
    private String metaDescription;
    
    @Column(name = "meta_keywords", length = 1000)
    @Size(max = 1000, message = "Meta keywords cannot exceed 1000 characters")
    private String metaKeywords;
    
    @Column(nullable = false)
    private Boolean active = true;
    
    @Column(name = "featured", nullable = false)
    private Boolean featured = false;
    
    @Column(name = "sort_order", nullable = false)
    @Min(value = 0, message = "Sort order cannot be negative")
    private Integer sortOrder = 0;
    
    @Column(name = "level", nullable = false)
    @Min(value = 0, message = "Level cannot be negative")
    private Integer level = 0;
    
    @Column(name = "path", length = 1000)
    @Size(max = 1000, message = "Path cannot exceed 1000 characters")
    private String path;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Category parent;
    
    @OneToMany(mappedBy = "parent", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("sortOrder ASC, name ASC")
    private Set<Category> children = new HashSet<>();
    
    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Product> products = new HashSet<>();
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    /**
     * Vérifie si la catégorie est une catégorie racine
     * 
     * @return true si c'est une catégorie racine, false sinon
     */
    public boolean isRoot() {
        return parent == null;
    }
    
    /**
     * Vérifie si la catégorie est une feuille (sans enfants)
     * 
     * @return true si c'est une feuille, false sinon
     */
    public boolean isLeaf() {
        return children == null || children.isEmpty();
    }
    
    /**
     * Obtient le chemin complet de la catégorie
     * 
     * @return le chemin complet (ex: "Electronics > Phones > Smartphones")
     */
    public String getFullPath() {
        if (path != null) {
            return path;
        }
        
        StringBuilder fullPath = new StringBuilder(name);
        Category current = parent;
        
        while (current != null) {
            fullPath.insert(0, current.getName() + " > ");
            current = current.getParent();
        }
        
        return fullPath.toString();
    }
    
    /**
     * Obtient le nombre total de produits dans cette catégorie
     * (incluant les sous-catégories)
     * 
     * @return le nombre total de produits
     */
    public long getTotalProductCount() {
        long count = products.size();
        
        for (Category child : children) {
            count += child.getTotalProductCount();
        }
        
        return count;
    }
    
    /**
     * Obtient le nombre de produits actifs dans cette catégorie
     * (incluant les sous-catégories)
     * 
     * @return le nombre de produits actifs
     */
    public long getActiveProductCount() {
        long count = products.stream()
            .mapToLong(product -> product.getActive() ? 1 : 0)
            .sum();
        
        for (Category child : children) {
            count += child.getActiveProductCount();
        }
        
        return count;
    }
    
    /**
     * Ajoute un enfant à cette catégorie
     * 
     * @param child la catégorie enfant à ajouter
     */
    public void addChild(Category child) {
        children.add(child);
        child.setParent(this);
        child.setLevel(this.level + 1);
        child.updatePath();
    }
    
    /**
     * Supprime un enfant de cette catégorie
     * 
     * @param child la catégorie enfant à supprimer
     */
    public void removeChild(Category child) {
        children.remove(child);
        child.setParent(null);
        child.setLevel(0);
        child.setPath(null);
    }
    
    /**
     * Met à jour le chemin de la catégorie
     */
    private void updatePath() {
        this.path = getFullPath();
        
        // Mettre à jour le chemin de tous les enfants
        for (Category child : children) {
            child.updatePath();
        }
    }
}
