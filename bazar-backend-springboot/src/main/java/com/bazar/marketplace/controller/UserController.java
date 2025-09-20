package com.bazar.marketplace.controller;

import com.bazar.marketplace.dto.UserDTO;
import com.bazar.marketplace.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

/**
 * Contrôleur REST pour la gestion des utilisateurs BAZAR Marketplace
 * 
 * Fournit les endpoints CRUD pour les utilisateurs avec sécurité JWT
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
@Slf4j
public class UserController {
    
    private final UserService userService;
    
    /**
     * Crée un nouvel utilisateur
     * 
     * @param userDTO le DTO utilisateur
     * @return le DTO utilisateur créé
     */
    @PostMapping
    public ResponseEntity<UserDTO> createUser(@Valid @RequestBody UserDTO userDTO) {
        log.info("Creating new user with email: {}", userDTO.getEmail());
        
        UserDTO createdUser = userService.createUser(userDTO);
        
        log.info("User created successfully with id: {}", createdUser.getId());
        return ResponseEntity.status(HttpStatus.CREATED).body(createdUser);
    }
    
    /**
     * Récupère un utilisateur par son ID
     * 
     * @param id l'ID de l'utilisateur
     * @return le DTO utilisateur ou 404 si non trouvé
     */
    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable Long id) {
        log.debug("Getting user by id: {}", id);
        
        UserDTO user = userService.getUserById(id);
        
        if (user != null) {
            log.debug("User found: {}", user.getEmail());
            return ResponseEntity.ok(user);
        } else {
            log.warn("User not found with id: {}", id);
            return ResponseEntity.notFound().build();
        }
    }
    
    /**
     * Récupère tous les utilisateurs avec pagination
     * 
     * @param pageable les paramètres de pagination
     * @return la page d'utilisateurs
     */
    @GetMapping
    public ResponseEntity<Page<UserDTO>> getAllUsers(Pageable pageable) {
        log.debug("Getting all users with pagination: {}", pageable);
        
        Page<UserDTO> users = userService.getAllUsers(pageable);
        
        log.debug("Found {} users", users.getTotalElements());
        return ResponseEntity.ok(users);
    }
    
    /**
     * Met à jour un utilisateur existant
     * 
     * @param id l'ID de l'utilisateur
     * @param userDTO les nouvelles données
     * @return l'utilisateur mis à jour
     */
    @PutMapping("/{id}")
    public ResponseEntity<UserDTO> updateUser(@PathVariable Long id, 
                                              @Valid @RequestBody UserDTO userDTO) {
        log.info("Updating user with id: {}", id);
        
        try {
            UserDTO updatedUser = userService.updateUser(id, userDTO);
            
            log.info("User updated successfully: {}", updatedUser.getEmail());
            return ResponseEntity.ok(updatedUser);
        } catch (IllegalArgumentException e) {
            log.error("User not found for update: {}", id);
            return ResponseEntity.notFound().build();
        }
    }
    
    /**
     * Supprime un utilisateur
     * 
     * @param id l'ID de l'utilisateur à supprimer
     * @return 204 No Content si succès
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        log.info("Deleting user with id: {}", id);
        
        try {
            userService.deleteUser(id);
            
            log.info("User deleted successfully: {}", id);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException e) {
            log.error("User not found for deletion: {}", id);
            return ResponseEntity.notFound().build();
        }
    }
}