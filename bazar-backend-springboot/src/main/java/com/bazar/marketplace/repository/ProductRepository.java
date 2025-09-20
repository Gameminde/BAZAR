package com.bazar.marketplace.repository;

import com.bazar.marketplace.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Repository Product pour BAZAR Marketplace
 * 
 * Accès aux données produits avec optimisations performance
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    /**
     * Trouve un produit par SKU
     * 
     * @param sku le SKU du produit
     * @return le produit ou Optional.empty()
     */
    @Query("SELECT p FROM Product p WHERE p.sku = :sku")
    Optional<Product> findBySku(@Param("sku") String sku);
    
    /**
     * Vérifie si un SKU existe
     * 
     * @param sku le SKU à vérifier
     * @return true si le SKU existe, false sinon
     */
    @Query("SELECT COUNT(p) > 0 FROM Product p WHERE p.sku = :sku")
    boolean existsBySku(@Param("sku") String sku);
    
    /**
     * Trouve les produits actifs
     * 
     * @param pageable la pagination
     * @return la page de produits actifs
     */
    @Query("SELECT p FROM Product p WHERE p.active = true")
    Page<Product> findActiveProducts(Pageable pageable);
    
    /**
     * Trouve les produits par catégorie
     * 
     * @param categoryId l'ID de la catégorie
     * @param pageable la pagination
     * @return la page de produits
     */
    @Query("SELECT p FROM Product p WHERE p.category.id = :categoryId AND p.active = true")
    Page<Product> findByCategoryId(@Param("categoryId") Long categoryId, Pageable pageable);
    
    /**
     * Trouve les produits en stock
     * 
     * @param pageable la pagination
     * @return la page de produits en stock
     */
    @Query("SELECT p FROM Product p WHERE p.active = true AND (p.stockQuantity > 0 OR p.allowBackorder = true)")
    Page<Product> findInStockProducts(Pageable pageable);
    
    /**
     * Trouve les produits en rupture de stock
     * 
     * @param pageable la pagination
     * @return la page de produits en rupture
     */
    @Query("SELECT p FROM Product p WHERE p.active = true AND p.stockQuantity <= 0 AND p.allowBackorder = false")
    Page<Product> findOutOfStockProducts(Pageable pageable);
    
    /**
     * Trouve les produits avec stock faible
     * 
     * @param pageable la pagination
     * @return la page de produits avec stock faible
     */
    @Query("SELECT p FROM Product p WHERE p.active = true AND p.trackQuantity = true AND p.stockQuantity <= p.lowStockThreshold")
    Page<Product> findLowStockProducts(Pageable pageable);
    
    /**
     * Trouve les produits en promotion
     * 
     * @param pageable la pagination
     * @return la page de produits en promotion
     */
    @Query("SELECT p FROM Product p WHERE p.active = true AND p.compareAtPrice IS NOT NULL AND p.compareAtPrice > p.price")
    Page<Product> findDiscountedProducts(Pageable pageable);
    
    /**
     * Trouve les produits par gamme de prix
     * 
     * @param minPrice le prix minimum
     * @param maxPrice le prix maximum
     * @param pageable la pagination
     * @return la page de produits
     */
    @Query("SELECT p FROM Product p WHERE p.active = true AND p.price BETWEEN :minPrice AND :maxPrice")
    Page<Product> findByPriceRange(@Param("minPrice") BigDecimal minPrice, 
                                  @Param("maxPrice") BigDecimal maxPrice, 
                                  Pageable pageable);
    
    /**
     * Trouve les produits par recherche textuelle
     * 
     * @param searchTerm le terme de recherche
     * @param pageable la pagination
     * @return la page de produits
     */
    @Query("SELECT p FROM Product p WHERE p.active = true AND " +
           "(LOWER(p.name) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(p.description) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(p.sku) LIKE LOWER(CONCAT('%', :searchTerm, '%')))")
    Page<Product> searchProducts(@Param("searchTerm") String searchTerm, Pageable pageable);
    
    /**
     * Trouve les produits les plus vus
     * 
     * @param limit la limite
     * @return la liste des produits
     */
    @Query("SELECT p FROM Product p WHERE p.active = true ORDER BY p.viewCount DESC")
    List<Product> findMostViewedProducts(@Param("limit") int limit);
    
    /**
     * Trouve les produits les plus vendus
     * 
     * @param limit la limite
     * @return la liste des produits
     */
    @Query("SELECT p FROM Product p WHERE p.active = true ORDER BY p.soldCount DESC")
    List<Product> findBestSellingProducts(@Param("limit") int limit);
    
    /**
     * Trouve les produits récents
     * 
     * @param limit la limite
     * @return la liste des produits
     */
    @Query("SELECT p FROM Product p WHERE p.active = true ORDER BY p.createdAt DESC")
    List<Product> findRecentProducts(@Param("limit") int limit);
    
    /**
     * Trouve les produits mis en avant
     * 
     * @param pageable la pagination
     * @return la page de produits
     */
    @Query("SELECT p FROM Product p WHERE p.active = true AND p.featured = true")
    Page<Product> findFeaturedProducts(Pageable pageable);
    
    /**
     * Trouve les produits numériques
     * 
     * @param pageable la pagination
     * @return la page de produits
     */
    @Query("SELECT p FROM Product p WHERE p.active = true AND p.digital = true")
    Page<Product> findDigitalProducts(Pageable pageable);
    
    /**
     * Trouve les produits physiques
     * 
     * @param pageable la pagination
     * @return la page de produits
     */
    @Query("SELECT p FROM Product p WHERE p.active = true AND p.digital = false")
    Page<Product> findPhysicalProducts(Pageable pageable);
    
    /**
     * Trouve les produits par multiple critères
     * 
     * @param categoryId l'ID de la catégorie (optionnel)
     * @param minPrice le prix minimum (optionnel)
     * @param maxPrice le prix maximum (optionnel)
     * @param searchTerm le terme de recherche (optionnel)
     * @param pageable la pagination
     * @return la page de produits
     */
    @Query("SELECT p FROM Product p WHERE p.active = true " +
           "AND (:categoryId IS NULL OR p.category.id = :categoryId) " +
           "AND (:minPrice IS NULL OR p.price >= :minPrice) " +
           "AND (:maxPrice IS NULL OR p.price <= :maxPrice) " +
           "AND (:searchTerm IS NULL OR " +
           "LOWER(p.name) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(p.description) LIKE LOWER(CONCAT('%', :searchTerm, '%')))")
    Page<Product> findProductsWithFilters(@Param("categoryId") Long categoryId,
                                         @Param("minPrice") BigDecimal minPrice,
                                         @Param("maxPrice") BigDecimal maxPrice,
                                         @Param("searchTerm") String searchTerm,
                                         Pageable pageable);
    
    /**
     * Compte le nombre de produits actifs
     * 
     * @return le nombre de produits actifs
     */
    @Query("SELECT COUNT(p) FROM Product p WHERE p.active = true")
    long countActiveProducts();
    
    /**
     * Compte le nombre de produits par catégorie
     * 
     * @param categoryId l'ID de la catégorie
     * @return le nombre de produits
     */
    @Query("SELECT COUNT(p) FROM Product p WHERE p.category.id = :categoryId AND p.active = true")
    long countByCategoryId(@Param("categoryId") Long categoryId);
    
    /**
     * Compte le nombre de produits en stock
     * 
     * @return le nombre de produits en stock
     */
    @Query("SELECT COUNT(p) FROM Product p WHERE p.active = true AND (p.stockQuantity > 0 OR p.allowBackorder = true)")
    long countInStockProducts();
}
