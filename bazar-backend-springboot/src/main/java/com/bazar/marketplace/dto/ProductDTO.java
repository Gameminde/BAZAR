package com.bazar.marketplace.dto;

import jakarta.validation.constraints.*;
import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Set;

/**
 * DTO Product pour BAZAR Marketplace
 * 
 * Évite l'exposition directe de l'entité Product
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductDTO {
    
    private Long id;
    
    @NotBlank(message = "Product name is required")
    @Size(min = 2, max = 255, message = "Product name must be between 2 and 255 characters")
    private String name;
    
    @NotBlank(message = "SKU is required")
    @Size(max = 100, message = "SKU cannot exceed 100 characters")
    private String sku;
    
    @Size(max = 5000, message = "Description cannot exceed 5000 characters")
    private String description;
    
    @Size(max = 10000, message = "Long description cannot exceed 10000 characters")
    private String longDescription;
    
    @NotNull(message = "Price is required")
    @DecimalMin(value = "0.01", message = "Price must be greater than 0")
    @Digits(integer = 8, fraction = 2, message = "Price format is invalid")
    private BigDecimal price;
    
    @DecimalMin(value = "0.01", message = "Compare at price must be greater than 0")
    @Digits(integer = 8, fraction = 2, message = "Compare at price format is invalid")
    private BigDecimal compareAtPrice;
    
    @DecimalMin(value = "0.00", message = "Cost price cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Cost price format is invalid")
    private BigDecimal costPrice;
    
    @Min(value = 0, message = "Stock quantity cannot be negative")
    private Integer stockQuantity;
    
    @Min(value = 0, message = "Low stock threshold cannot be negative")
    private Integer lowStockThreshold;
    
    @DecimalMin(value = "0.000", message = "Weight cannot be negative")
    private BigDecimal weight;
    
    @DecimalMin(value = "0.00", message = "Length cannot be negative")
    private BigDecimal length;
    
    @DecimalMin(value = "0.00", message = "Width cannot be negative")
    private BigDecimal width;
    
    @DecimalMin(value = "0.00", message = "Height cannot be negative")
    private BigDecimal height;
    
    private String imageUrl;
    
    private Set<String> additionalImages;
    
    private Boolean active;
    
    private Boolean featured;
    
    private Boolean digital;
    
    private Boolean downloadable;
    
    private Boolean virtual;
    
    private Boolean requiresShipping;
    
    private Boolean trackQuantity;
    
    private Boolean allowBackorder;
    
    @Size(max = 255, message = "Meta title cannot exceed 255 characters")
    private String metaTitle;
    
    @Size(max = 500, message = "Meta description cannot exceed 500 characters")
    private String metaDescription;
    
    @Size(max = 1000, message = "Meta keywords cannot exceed 1000 characters")
    private String metaKeywords;
    
    private Long viewCount;
    
    private Long soldCount;
    
    private Long categoryId;
    
    private String categoryName;
    
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
    
    // Calculated fields
    private BigDecimal discountPercentage;
    
    private Boolean inStock;
    
    private Boolean lowStock;
}
