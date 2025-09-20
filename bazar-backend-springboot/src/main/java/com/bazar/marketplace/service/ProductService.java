package com.bazar.marketplace.service;

import com.bazar.marketplace.dto.ProductDTO;
import com.bazar.marketplace.entity.Product;
import com.bazar.marketplace.exception.ResourceNotFoundException;
import com.bazar.marketplace.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Product Service with Advanced Caching
 * Handles product operations with intelligent cache management
 */
@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class ProductService {

    private final ProductRepository productRepository;
    private final CacheService cacheService;

    /**
     * Get product by ID with cache
     */
    @Transactional(readOnly = true)
    @Cacheable(value = "products", key = "#id")
    public ProductDTO getProductById(Long id) {
        log.debug("Getting product by id: {}", id);

        // Try cache first
        Optional<Object> cachedProduct = cacheService.getCachedProduct(id);
        if (cachedProduct.isPresent() && cachedProduct.get() instanceof ProductDTO) {
            return (ProductDTO) cachedProduct.get();
        }

        Product product = productRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Product", "id", id));

        ProductDTO productDTO = convertToDTO(product);
        
        // Cache the result
        cacheService.cacheProduct(id, productDTO);
        
        return productDTO;
    }

    /**
     * Get all products with pagination and cache
     */
    @Transactional(readOnly = true)
    public Page<ProductDTO> getAllProducts(Pageable pageable) {
        log.debug("Getting all products with pagination: {}", pageable);

        Page<Product> products = productRepository.findAll(pageable);
        Page<ProductDTO> productDTOs = products.map(this::convertToDTO);

        // Warm cache for popular products
        List<ProductDTO> content = productDTOs.getContent();
        if (!content.isEmpty()) {
            content.forEach(dto -> cacheService.cacheProduct(dto.getId(), dto));
        }

        return productDTOs;
    }

    /**
     * Search products with cache
     */
    @Transactional(readOnly = true)
    public Page<ProductDTO> searchProducts(String query, Map<String, Object> filters, Pageable pageable) {
        log.debug("Searching products with query: {} and filters: {}", query, filters);

        // Try cache first
        Optional<Object> cachedResults = cacheService.getCachedSearchResults(query, filters);
        if (cachedResults.isPresent() && cachedResults.get() instanceof Page) {
            log.debug("Cache hit for search query: {}", query);
            return (Page<ProductDTO>) cachedResults.get();
        }

        // Perform search (this would be replaced with actual search implementation)
        Page<Product> products;
        if (query != null && !query.isEmpty()) {
            products = productRepository.findByNameContainingIgnoreCase(query, pageable);
        } else {
            products = productRepository.findAll(pageable);
        }

        Page<ProductDTO> result = products.map(this::convertToDTO);
        
        // Cache the results
        cacheService.cacheSearchResults(query, filters, result);

        return result;
    }

    /**
     * Get products by category with cache
     */
    @Transactional(readOnly = true)
    @Cacheable(value = "products", key = "'category:' + #categoryId")
    public List<ProductDTO> getProductsByCategory(Long categoryId) {
        log.debug("Getting products by category: {}", categoryId);

        List<Product> products = productRepository.findByCategoryId(categoryId);
        List<ProductDTO> productDTOs = products.stream()
                .map(this::convertToDTO)
                .toList();

        // Warm cache for individual products
        productDTOs.forEach(dto -> cacheService.cacheProduct(dto.getId(), dto));

        return productDTOs;
    }

    /**
     * Get featured products with cache
     */
    @Transactional(readOnly = true)
    @Cacheable(value = "products", key = "'featured'")
    public List<ProductDTO> getFeaturedProducts() {
        log.debug("Getting featured products");

        List<Product> products = productRepository.findByFeaturedTrue();
        List<ProductDTO> productDTOs = products.stream()
                .map(this::convertToDTO)
                .toList();

        // Cache individual products
        productDTOs.forEach(dto -> cacheService.cacheProduct(dto.getId(), dto));

        return productDTOs;
    }

    /**
     * Create product with cache invalidation
     */
    @CacheEvict(value = {"products", "categories"}, allEntries = true)
    public ProductDTO createProduct(ProductDTO productDTO) {
        log.info("Creating new product: {}", productDTO.getName());

        Product product = convertToEntity(productDTO);
        Product savedProduct = productRepository.save(product);
        
        ProductDTO result = convertToDTO(savedProduct);
        
        // Cache the new product
        cacheService.cacheProduct(result.getId(), result);
        
        log.info("Product created successfully with id: {}", savedProduct.getId());
        return result;
    }

    /**
     * Update product with cache management
     */
    @CachePut(value = "products", key = "#id")
    public ProductDTO updateProduct(Long id, ProductDTO productDTO) {
        log.info("Updating product with id: {}", id);

        Product existingProduct = productRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Product", "id", id));

        // Update fields
        updateProductFields(existingProduct, productDTO);
        Product updatedProduct = productRepository.save(existingProduct);
        
        ProductDTO result = convertToDTO(updatedProduct);
        
        // Update cache
        cacheService.cacheProduct(id, result);
        
        // Invalidate related caches
        cacheService.invalidateProductCache(id);
        
        log.info("Product updated successfully with id: {}", updatedProduct.getId());
        return result;
    }

    /**
     * Delete product with cache cleanup
     */
    @CacheEvict(value = "products", key = "#id")
    public void deleteProduct(Long id) {
        log.info("Deleting product with id: {}", id);

        if (!productRepository.existsById(id)) {
            throw new ResourceNotFoundException("Product", "id", id);
        }

        productRepository.deleteById(id);
        
        // Clean up cache
        cacheService.invalidateProductCache(id);
        
        log.info("Product deleted successfully with id: {}", id);
    }

    /**
     * Update product stock with cache
     */
    @Transactional
    public void updateStock(Long productId, Integer newStock) {
        log.info("Updating stock for product {} to {}", productId, newStock);

        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("Product", "id", productId));

        product.setStockQuantity(newStock);
        productRepository.save(product);

        // Update cache
        ProductDTO productDTO = convertToDTO(product);
        cacheService.cacheProduct(productId, productDTO);

        log.info("Stock updated successfully for product: {}", productId);
    }

    /**
     * Get low stock products
     */
    @Transactional(readOnly = true)
    public List<ProductDTO> getLowStockProducts() {
        log.debug("Getting low stock products");

        List<Product> products = productRepository.findByStockQuantityLessThanEqual(10);
        return products.stream()
                .map(this::convertToDTO)
                .toList();
    }

    /**
     * Get products by price range
     */
    @Transactional(readOnly = true)
    public List<ProductDTO> getProductsByPriceRange(BigDecimal minPrice, BigDecimal maxPrice) {
        log.debug("Getting products by price range: {} - {}", minPrice, maxPrice);

        List<Product> products = productRepository.findByPriceBetween(minPrice, maxPrice);
        return products.stream()
                .map(this::convertToDTO)
                .toList();
    }

    // Private helper methods

    private ProductDTO convertToDTO(Product product) {
        ProductDTO dto = new ProductDTO();
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

    private Product convertToEntity(ProductDTO dto) {
        Product product = new Product();
        product.setName(dto.getName());
        product.setDescription(dto.getDescription());
        product.setPrice(dto.getPrice());
        product.setCompareAtPrice(dto.getCompareAtPrice());
        product.setStockQuantity(dto.getStockQuantity());
        // product.setCategoryId(dto.getCategoryId()); // Temporarily commented
        product.setSku(dto.getSku());
        // product.setSlug(dto.getSlug()); // Temporarily commented
        // product.setStatus(dto.getStatus()); // Temporarily commented
        // product.setVisibility(dto.getVisibility()); // Temporarily commented
        product.setFeatured(dto.getFeatured());
        return product;
    }

    private void updateProductFields(Product product, ProductDTO dto) {
        if (dto.getName() != null) product.setName(dto.getName());
        if (dto.getDescription() != null) product.setDescription(dto.getDescription());
        if (dto.getPrice() != null) product.setPrice(dto.getPrice());
        if (dto.getCompareAtPrice() != null) product.setCompareAtPrice(dto.getCompareAtPrice());
        if (dto.getStockQuantity() != null) product.setStockQuantity(dto.getStockQuantity());
        // if (dto.getCategoryId() != null) product.setCategoryId(dto.getCategoryId()); // Temporarily commented
        // if (dto.getStatus() != null) product.setStatus(dto.getStatus()); // Temporarily commented
        // if (dto.getVisibility() != null) product.setVisibility(dto.getVisibility()); // Temporarily commented
        if (dto.getFeatured() != null) product.setFeatured(dto.getFeatured());
    }
}
