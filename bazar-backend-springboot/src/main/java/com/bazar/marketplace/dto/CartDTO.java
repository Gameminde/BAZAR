package com.bazar.marketplace.dto;

import jakarta.validation.constraints.*;
import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO Cart pour BAZAR Marketplace
 * 
 * Évite l'exposition directe de l'entité Cart
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CartDTO {
    
    private Long id;
    
    private Long userId;
    
    private String sessionId;
    
    @Email(message = "Guest email should be valid")
    @Size(max = 100, message = "Guest email cannot exceed 100 characters")
    private String guestEmail;
    
    @NotBlank(message = "Currency code is required")
    @Size(min = 3, max = 3, message = "Currency code must be exactly 3 characters")
    @Pattern(regexp = "^[A-Z]{3}$", message = "Currency code must be uppercase letters")
    private String currencyCode;
    
    @NotNull(message = "Subtotal is required")
    @DecimalMin(value = "0.00", message = "Subtotal cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Subtotal format is invalid")
    private BigDecimal subtotal;
    
    @NotNull(message = "Tax amount is required")
    @DecimalMin(value = "0.00", message = "Tax amount cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Tax amount format is invalid")
    private BigDecimal taxAmount;
    
    @NotNull(message = "Shipping amount is required")
    @DecimalMin(value = "0.00", message = "Shipping amount cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Shipping amount format is invalid")
    private BigDecimal shippingAmount;
    
    @NotNull(message = "Discount amount is required")
    @DecimalMin(value = "0.00", message = "Discount amount cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Discount amount format is invalid")
    private BigDecimal discountAmount;
    
    @NotNull(message = "Total amount is required")
    @DecimalMin(value = "0.00", message = "Total amount cannot be negative")
    @Digits(integer = 8, fraction = 2, message = "Total amount format is invalid")
    private BigDecimal totalAmount;
    
    @Min(value = 0, message = "Item count cannot be negative")
    private Integer itemCount;
    
    @Min(value = 0, message = "Total quantity cannot be negative")
    private Integer totalQuantity;
    
    @Size(max = 50, message = "Coupon code cannot exceed 50 characters")
    private String couponCode;
    
    @Size(max = 1000, message = "Notes cannot exceed 1000 characters")
    private String notes;
    
    private LocalDateTime expiresAt;
    
    private Boolean abandoned;
    
    private LocalDateTime abandonedAt;
    
    private List<CartItemDTO> items;
    
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
    
    // Calculated fields
    private Boolean isEmpty;
    
    private Boolean isExpired;
    
    private Boolean isValidForCheckout;
}
