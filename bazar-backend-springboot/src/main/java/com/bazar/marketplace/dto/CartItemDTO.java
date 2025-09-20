package com.bazar.marketplace.dto;

import jakarta.validation.constraints.*;
import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * DTO CartItem pour BAZAR Marketplace
 * 
 * Évite l'exposition directe de l'entité CartItem
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CartItemDTO {
    
    private Long id;
    
    private Long cartId;
    
    private Long productId;
    
    private String productName;
    
    private String productSku;
    
    private String productDescription;
    
    private String productImageUrl;
    
    @NotNull(message = "Quantity is required")
    @Min(value = 1, message = "Quantity must be at least 1")
    @Max(value = 999, message = "Quantity cannot exceed 999")
    private Integer quantity;
    
    @NotNull(message = "Price is required")
    @DecimalMin(value = "0.01", message = "Price must be greater than 0")
    @Digits(integer = 8, fraction = 2, message = "Price format is invalid")
    private BigDecimal price;
    
    @DecimalMin(value = "0.01", message = "Compare at price must be greater than 0")
    @Digits(integer = 8, fraction = 2, message = "Compare at price format is invalid")
    private BigDecimal compareAtPrice;
    
    @NotNull(message = "Discount amount is required")
    @DecimalMin(value = "0.00", message = "Discount amount cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Discount amount format is invalid")
    private BigDecimal discountAmount;
    
    @NotNull(message = "Tax amount is required")
    @DecimalMin(value = "0.00", message = "Tax amount cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Tax amount format is invalid")
    private BigDecimal taxAmount;
    
    @NotNull(message = "Line total is required")
    @DecimalMin(value = "0.00", message = "Line total cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Line total format is invalid")
    private BigDecimal lineTotal;
    
    @Size(max = 500, message = "Notes cannot exceed 500 characters")
    private String notes;
    
    private LocalDateTime createdAt;
    
    // Calculated fields
    private BigDecimal discountPercentage;
    
    private BigDecimal taxPercentage;
    
    private Boolean hasDiscount;
    
    private Boolean hasTax;
}
