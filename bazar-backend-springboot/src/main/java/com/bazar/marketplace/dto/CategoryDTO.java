package com.bazar.marketplace.dto;

import jakarta.validation.constraints.*;
import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO Category pour BAZAR Marketplace
 * 
 * Évite l'exposition directe de l'entité Category
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CategoryDTO {
    
    private Long id;
    
    @NotBlank(message = "Category name is required")
    @Size(min = 2, max = 255, message = "Category name must be between 2 and 255 characters")
    private String name;
    
    @NotBlank(message = "Slug is required")
    @Size(max = 255, message = "Slug cannot exceed 255 characters")
    @Pattern(regexp = "^[a-z0-9-]+$", message = "Slug must contain only lowercase letters, numbers and hyphens")
    private String slug;
    
    @Size(max = 2000, message = "Description cannot exceed 2000 characters")
    private String description;
    
    private String imageUrl;
    
    private String iconUrl;
    
    @Size(max = 255, message = "Meta title cannot exceed 255 characters")
    private String metaTitle;
    
    @Size(max = 500, message = "Meta description cannot exceed 500 characters")
    private String metaDescription;
    
    @Size(max = 1000, message = "Meta keywords cannot exceed 1000 characters")
    private String metaKeywords;
    
    private Boolean active;
    
    private Boolean featured;
    
    @Min(value = 0, message = "Sort order cannot be negative")
    private Integer sortOrder;
    
    @Min(value = 0, message = "Level cannot be negative")
    private Integer level;
    
    private String path;
    
    private Long parentId;
    
    private String parentName;
    
    private List<CategoryDTO> children;
    
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
    
    // Calculated fields
    private Long totalProductCount;
    
    private Long activeProductCount;
    
    private Boolean isRoot;
    
    private Boolean isLeaf;
}
