package com.bazar.marketplace.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

/**
 * Entité OrderAddress pour BAZAR Marketplace
 * 
 * Représente une adresse de commande (livraison ou facturation)
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Entity
@Table(name = "order_addresses")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "id")
public class OrderAddress {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;
    
    @NotBlank(message = "Address type is required")
    @Size(max = 20, message = "Address type cannot exceed 20 characters")
    @Column(name = "address_type", nullable = false, length = 20)
    private String addressType; // "BILLING" ou "SHIPPING"
    
    @NotBlank(message = "First name is required")
    @Size(max = 50, message = "First name cannot exceed 50 characters")
    @Column(name = "first_name", nullable = false, length = 50)
    private String firstName;
    
    @NotBlank(message = "Last name is required")
    @Size(max = 50, message = "Last name cannot exceed 50 characters")
    @Column(name = "last_name", nullable = false, length = 50)
    private String lastName;
    
    @Size(max = 100, message = "Company name cannot exceed 100 characters")
    @Column(name = "company_name", length = 100)
    private String companyName;
    
    @NotBlank(message = "Address line 1 is required")
    @Size(max = 255, message = "Address line 1 cannot exceed 255 characters")
    @Column(name = "address_line_1", nullable = false)
    private String addressLine1;
    
    @Size(max = 255, message = "Address line 2 cannot exceed 255 characters")
    @Column(name = "address_line_2")
    private String addressLine2;
    
    @NotBlank(message = "City is required")
    @Size(max = 100, message = "City cannot exceed 100 characters")
    @Column(name = "city", nullable = false, length = 100)
    private String city;
    
    @NotBlank(message = "State is required")
    @Size(max = 100, message = "State cannot exceed 100 characters")
    @Column(name = "state", nullable = false, length = 100)
    private String state;
    
    @NotBlank(message = "Postal code is required")
    @Size(max = 20, message = "Postal code cannot exceed 20 characters")
    @Pattern(regexp = "^[0-9]{5}$", message = "Postal code must be a valid Algerian postal code (5 digits)")
    @Column(name = "postal_code", nullable = false, length = 20)
    private String postalCode;
    
    @NotBlank(message = "Country is required")
    @Size(max = 3, message = "Country code cannot exceed 3 characters")
    @Pattern(regexp = "^[A-Z]{2,3}$", message = "Country code must be a valid ISO code")
    @Column(name = "country", nullable = false, length = 3)
    private String country;
    
    @Pattern(regexp = "^(\\+213|0)[5-7][0-9]{8}$", message = "Phone number must be a valid Algerian number")
    @Column(name = "phone_number", length = 20)
    private String phoneNumber;
    
    @Email(message = "Email should be valid")
    @Size(max = 100, message = "Email cannot exceed 100 characters")
    @Column(name = "email", length = 100)
    private String email;
    
    @Size(max = 500, message = "Notes cannot exceed 500 characters")
    @Column(name = "notes", length = 500)
    private String notes;
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    /**
     * Enum pour les types d'adresses
     */
    public enum AddressType {
        BILLING("BILLING"),
        SHIPPING("SHIPPING");
        
        private final String value;
        
        AddressType(String value) {
            this.value = value;
        }
        
        public String getValue() {
            return value;
        }
    }
    
    /**
     * Constructeur pour créer une adresse de commande
     * 
     * @param order la commande
     * @param addressType le type d'adresse
     * @param firstName le prénom
     * @param lastName le nom
     * @param addressLine1 la ligne d'adresse 1
     * @param city la ville
     * @param state l'état/province
     * @param postalCode le code postal
     * @param country le pays
     */
    public OrderAddress(Order order, String addressType, String firstName, String lastName,
                       String addressLine1, String city, String state, String postalCode, String country) {
        this.order = order;
        this.addressType = addressType;
        this.firstName = firstName;
        this.lastName = lastName;
        this.addressLine1 = addressLine1;
        this.city = city;
        this.state = state;
        this.postalCode = postalCode;
        this.country = country;
    }
    
    /**
     * Retourne le nom complet
     * 
     * @return le nom complet
     */
    public String getFullName() {
        return firstName + " " + lastName;
    }
    
    /**
     * Retourne l'adresse complète formatée
     * 
     * @return l'adresse formatée
     */
    public String getFormattedAddress() {
        StringBuilder address = new StringBuilder();
        address.append(addressLine1);
        
        if (addressLine2 != null && !addressLine2.trim().isEmpty()) {
            address.append(", ").append(addressLine2);
        }
        
        address.append(", ").append(city);
        address.append(", ").append(state);
        address.append(" ").append(postalCode);
        address.append(", ").append(country);
        
        return address.toString();
    }
}
