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
 * Entity User - Utilisateur du système BAZAR Marketplace
 * 
 * Représente un utilisateur authentifié avec ses informations de profil
 * et ses rôles dans le système.
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Entity
@Table(name = "users", 
       indexes = {
           @Index(name = "idx_user_email", columnList = "email", unique = true),
           @Index(name = "idx_user_username", columnList = "username", unique = true),
           @Index(name = "idx_user_active", columnList = "active"),
           @Index(name = "idx_user_created_at", columnList = "created_at")
       })
@Data
@EqualsAndHashCode(callSuper = false)
@EntityListeners(AuditingEntityListener.class)
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true, length = 50)
    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 50, message = "Username must be between 3 and 50 characters")
    @Pattern(regexp = "^[a-zA-Z0-9._-]+$", message = "Username contains invalid characters")
    private String username;
    
    @Column(nullable = false, unique = true, length = 100)
    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    @Size(max = 100, message = "Email cannot exceed 100 characters")
    private String email;
    
    @Column(name = "password_hash", nullable = false)
    @NotBlank(message = "Password is required")
    @Size(min = 60, max = 60, message = "Password hash must be exactly 60 characters")
    private String passwordHash;
    
    @Column(name = "first_name", length = 50)
    @Size(max = 50, message = "First name cannot exceed 50 characters")
    private String firstName;
    
    @Column(name = "last_name", length = 50)
    @Size(max = 50, message = "Last name cannot exceed 50 characters")
    private String lastName;
    
    @Column(name = "phone_number", length = 20)
    @Pattern(regexp = "^(\\+213|0)[5-7][0-9]{8}$", message = "Phone number must be a valid Algerian number (+213 or 0 followed by 5, 6, or 7 and 8 digits)")
    private String phoneNumber;
    
    @Column(name = "profile_image_url", length = 500)
    @Size(max = 500, message = "Profile image URL cannot exceed 500 characters")
    private String profileImageUrl;
    
    @Column(nullable = false)
    private Boolean active = true;
    
    @Column(name = "email_verified", nullable = false)
    private Boolean emailVerified = false;
    
    @Column(name = "phone_verified", nullable = false)
    private Boolean phoneVerified = false;
    
    @Column(name = "last_login_at")
    private LocalDateTime lastLoginAt;
    
    @Column(name = "failed_login_attempts", nullable = false)
    private Integer failedLoginAttempts = 0;
    
    @Column(name = "locked_until")
    private LocalDateTime lockedUntil;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @NotNull(message = "Role is required")
    private UserRole role = UserRole.USER;
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Cart> carts = new HashSet<>();
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Order> orders = new HashSet<>();
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Wishlist> wishlists = new HashSet<>();
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    /**
     * Vérifie si le compte utilisateur est verrouillé
     * 
     * @return true si le compte est verrouillé, false sinon
     */
    public boolean isAccountLocked() {
        return lockedUntil != null && lockedUntil.isAfter(LocalDateTime.now());
    }
    
    /**
     * Vérifie si l'utilisateur peut se connecter
     * 
     * @return true si l'utilisateur peut se connecter, false sinon
     */
    public boolean canLogin() {
        return active && !isAccountLocked() && emailVerified;
    }
    
    /**
     * Rôles utilisateur disponibles
     */
    public enum UserRole {
        USER("User"),
        ADMIN("Administrator"),
        MODERATOR("Moderator"),
        SELLER("Seller");
        
        private final String displayName;
        
        UserRole(String displayName) {
            this.displayName = displayName;
        }
        
        public String getDisplayName() {
            return displayName;
        }
    }
}
