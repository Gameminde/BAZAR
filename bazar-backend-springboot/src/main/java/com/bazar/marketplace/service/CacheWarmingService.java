package com.bazar.marketplace.service;

import com.bazar.marketplace.entity.Product;
import com.bazar.marketplace.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Cache Warming Service
 * Proactively warms caches with frequently accessed data
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class CacheWarmingService {

    private final CacheService cacheService;
    private final ProductRepository productRepository;
    private final ProductService productService;

    /**
     * Warm caches on application startup
     */
    @EventListener(ApplicationReadyEvent.class)
    @Async
    public void warmCachesOnStartup() {
        log.info("Starting cache warming on application startup...");
        
        try {
            // Warm featured products cache
            warmFeaturedProductsCache();
            
            // Warm popular products cache
            warmPopularProductsCache();
            
            // Warm category cache
            warmCategoryCache();
            
            log.info("Cache warming completed successfully");
            
        } catch (Exception e) {
            log.error("Failed to warm caches on startup", e);
        }
    }

    /**
     * Scheduled cache warming - every hour
     */
    @Scheduled(fixedRate = 3600000) // 1 hour
    @Async
    public void scheduledCacheWarming() {
        log.debug("Starting scheduled cache warming...");
        
        try {
            // Refresh featured products
            warmFeaturedProductsCache();
            
            // Refresh popular products based on access statistics
            warmPopularProductsCache();
            
            log.debug("Scheduled cache warming completed");
            
        } catch (Exception e) {
            log.error("Failed during scheduled cache warming", e);
        }
    }

    /**
     * Warm featured products cache
     */
    @Transactional(readOnly = true)
    public void warmFeaturedProductsCache() {
        log.debug("Warming featured products cache...");
        
        try {
            // Get featured products from service (this will cache them)
            List<com.bazar.marketplace.dto.ProductDTO> featuredProducts = productService.getFeaturedProducts();
            
            log.info("Warmed cache for {} featured products", featuredProducts.size());
            
        } catch (Exception e) {
            log.error("Failed to warm featured products cache", e);
        }
    }

    /**
     * Warm popular products cache based on access statistics
     */
    @Transactional(readOnly = true)
    public void warmPopularProductsCache() {
        log.debug("Warming popular products cache...");
        
        try {
            // Get top 50 products by various criteria
            List<Product> recentProducts = productRepository.findTop50ByOrderByCreatedAtDesc();
            List<Product> featuredProducts = productRepository.findByFeaturedTrue();
            
            // Combine and deduplicate
            Map<Long, Product> productsToCache = new HashMap<>();
            
            recentProducts.forEach(p -> productsToCache.put(p.getId(), p));
            featuredProducts.forEach(p -> productsToCache.put(p.getId(), p));
            
            // Convert to DTOs and cache
            Map<Long, Object> productData = new HashMap<>();
            for (Product product : productsToCache.values()) {
                com.bazar.marketplace.dto.ProductDTO dto = convertToDTO(product);
                productData.put(product.getId(), dto);
            }
            
            // Bulk cache warming
            cacheService.warmProductCache(productsToCache.keySet().stream().toList(), productData);
            
            log.info("Warmed cache for {} popular products", productsToCache.size());
            
        } catch (Exception e) {
            log.error("Failed to warm popular products cache", e);
        }
    }

    /**
     * Warm category cache
     */
    @Transactional(readOnly = true)
    public void warmCategoryCache() {
        log.debug("Warming category cache...");
        
        try {
            // This would typically build the category tree and cache it
            // For now, we'll just log the action
            
            // TODO: Implement category tree building and caching
            // CategoryTree categoryTree = categoryService.buildCategoryTree();
            // cacheService.cacheCategoryTree(categoryTree);
            
            log.info("Category cache warming completed");
            
        } catch (Exception e) {
            log.error("Failed to warm category cache", e);
        }
    }

    /**
     * Warm cache for specific product IDs
     */
    @Transactional(readOnly = true)
    public void warmProductCache(List<Long> productIds) {
        log.debug("Warming cache for {} specific products", productIds.size());
        
        try {
            List<Product> products = productRepository.findAllById(productIds);
            
            Map<Long, Object> productData = new HashMap<>();
            for (Product product : products) {
                com.bazar.marketplace.dto.ProductDTO dto = convertToDTO(product);
                productData.put(product.getId(), dto);
            }
            
            cacheService.warmProductCache(productIds, productData);
            
            log.info("Warmed cache for {} products", products.size());
            
        } catch (Exception e) {
            log.error("Failed to warm cache for specific products", e);
        }
    }

    /**
     * Cache warming based on user behavior patterns
     */
    @Scheduled(fixedRate = 1800000) // 30 minutes
    @Async
    public void behaviorBasedCacheWarming() {
        log.debug("Starting behavior-based cache warming...");
        
        try {
            // This would analyze user access patterns and pre-cache likely-to-be-accessed items
            // For now, we'll implement a simple version
            
            // Get products that are running low on stock (likely to be popular)
            List<com.bazar.marketplace.dto.ProductDTO> lowStockProducts = productService.getLowStockProducts();
            
            // Cache these products as they might get more attention
            for (com.bazar.marketplace.dto.ProductDTO product : lowStockProducts) {
                cacheService.cacheProduct(product.getId(), product);
            }
            
            log.debug("Behavior-based cache warming completed for {} products", lowStockProducts.size());
            
        } catch (Exception e) {
            log.error("Failed during behavior-based cache warming", e);
        }
    }

    /**
     * Clean up expired cache entries
     */
    @Scheduled(fixedRate = 7200000) // 2 hours
    @Async
    public void cleanupExpiredCache() {
        log.debug("Starting cache cleanup...");
        
        try {
            // Redis handles TTL automatically, but we can do additional cleanup
            // This could include removing cache entries that are no longer relevant
            
            Map<String, Object> stats = cacheService.getCacheStatistics();
            log.debug("Current cache statistics: {}", stats);
            
            // TODO: Implement intelligent cache cleanup based on access patterns
            
            log.debug("Cache cleanup completed");
            
        } catch (Exception e) {
            log.error("Failed during cache cleanup", e);
        }
    }

    // Helper methods

    private com.bazar.marketplace.dto.ProductDTO convertToDTO(Product product) {
        com.bazar.marketplace.dto.ProductDTO dto = new com.bazar.marketplace.dto.ProductDTO();
        dto.setId(product.getId());
        dto.setName(product.getName());
        dto.setDescription(product.getDescription());
        dto.setPrice(product.getPrice());
        dto.setCompareAtPrice(product.getCompareAtPrice());
        dto.setStockQuantity(product.getStockQuantity());
        // dto.setCategoryId(product.getCategoryId()); // Temporarily commented
        dto.setSku(product.getSku());
        // dto.setSlug(product.getSlug()); // Temporarily commented
        // dto.setStatus(product.getStatus()); // Temporarily commented
        // dto.setVisibility(product.getVisibility()); // Temporarily commented
        dto.setFeatured(product.getFeatured());
        dto.setCreatedAt(product.getCreatedAt());
        dto.setUpdatedAt(product.getUpdatedAt());
        return dto;
    }
}
