package com.bazar.marketplace.dto;

import jakarta.validation.constraints.*;
import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO User pour BAZAR Marketplace
 * 
 * Évite l'exposition directe de l'entité User
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDTO {
    
    private Long id;
    
    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 50, message = "Username must be between 3 and 50 characters")
    private String username;
    
    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    @Size(max = 100, message = "Email cannot exceed 100 characters")
    private String email;
    
    @Size(max = 50, message = "First name cannot exceed 50 characters")
    private String firstName;
    
    @Size(max = 50, message = "Last name cannot exceed 50 characters")
    private String lastName;
    
    @Pattern(regexp = "^(\\+213|0)[5-7][0-9]{8}$", message = "Phone number must be a valid Algerian number")
    private String phoneNumber;
    
    private String profileImageUrl;
    
    private Boolean active;
    
    private Boolean emailVerified;
    
    private Boolean phoneVerified;
    
    private LocalDateTime lastLoginAt;
    
    private String role;
    
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
}
