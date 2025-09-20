package com.bazar.marketplace.repository;

import com.bazar.marketplace.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository User pour BAZAR Marketplace
 * 
 * Accès aux données utilisateurs avec optimisations performance
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    /**
     * Trouve un utilisateur par email
     * 
     * @param email l'email de l'utilisateur
     * @return l'utilisateur ou Optional.empty()
     */
    @Query("SELECT u FROM User u WHERE u.email = :email")
    Optional<User> findByEmail(@Param("email") String email);
    
    /**
     * Trouve un utilisateur par nom d'utilisateur
     * 
     * @param username le nom d'utilisateur
     * @return l'utilisateur ou Optional.empty()
     */
    @Query("SELECT u FROM User u WHERE u.username = :username")
    Optional<User> findByUsername(@Param("username") String username);
    
    /**
     * Trouve un utilisateur par email ou nom d'utilisateur
     * 
     * @param email l'email
     * @param username le nom d'utilisateur
     * @return l'utilisateur ou Optional.empty()
     */
    @Query("SELECT u FROM User u WHERE u.email = :email OR u.username = :username")
    Optional<User> findByEmailOrUsername(@Param("email") String email, @Param("username") String username);
    
    /**
     * Vérifie si un email existe
     * 
     * @param email l'email à vérifier
     * @return true si l'email existe, false sinon
     */
    @Query("SELECT COUNT(u) > 0 FROM User u WHERE u.email = :email")
    boolean existsByEmail(@Param("email") String email);
    
    /**
     * Vérifie si un nom d'utilisateur existe
     * 
     * @param username le nom d'utilisateur à vérifier
     * @return true si le nom d'utilisateur existe, false sinon
     */
    @Query("SELECT COUNT(u) > 0 FROM User u WHERE u.username = :username")
    boolean existsByUsername(@Param("username") String username);
    
    /**
     * Trouve les utilisateurs actifs
     * 
     * @param pageable la pagination
     * @return la page d'utilisateurs actifs
     */
    @Query("SELECT u FROM User u WHERE u.active = true")
    Page<User> findActiveUsers(Pageable pageable);
    
    /**
     * Trouve les utilisateurs par rôle
     * 
     * @param role le rôle
     * @param pageable la pagination
     * @return la page d'utilisateurs
     */
    @Query("SELECT u FROM User u WHERE u.role = :role")
    Page<User> findByRole(@Param("role") User.UserRole role, Pageable pageable);
    
    /**
     * Trouve les utilisateurs avec des tentatives de connexion échouées
     * 
     * @param maxAttempts le nombre maximum de tentatives
     * @return la liste des utilisateurs
     */
    @Query("SELECT u FROM User u WHERE u.failedLoginAttempts >= :maxAttempts")
    List<User> findUsersWithFailedLoginAttempts(@Param("maxAttempts") int maxAttempts);
    
    /**
     * Trouve les utilisateurs verrouillés
     * 
     * @return la liste des utilisateurs verrouillés
     */
    @Query("SELECT u FROM User u WHERE u.lockedUntil IS NOT NULL AND u.lockedUntil > :now")
    List<User> findLockedUsers(@Param("now") LocalDateTime now);
    
    /**
     * Trouve les utilisateurs par recherche textuelle
     * 
     * @param searchTerm le terme de recherche
     * @param pageable la pagination
     * @return la page d'utilisateurs
     */
    @Query("SELECT u FROM User u WHERE " +
           "LOWER(u.username) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(u.email) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(u.firstName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(u.lastName) LIKE LOWER(CONCAT('%', :searchTerm, '%'))")
    Page<User> searchUsers(@Param("searchTerm") String searchTerm, Pageable pageable);
    
    /**
     * Trouve les utilisateurs créés dans une période
     * 
     * @param startDate la date de début
     * @param endDate la date de fin
     * @param pageable la pagination
     * @return la page d'utilisateurs
     */
    @Query("SELECT u FROM User u WHERE u.createdAt BETWEEN :startDate AND :endDate")
    Page<User> findUsersCreatedBetween(@Param("startDate") LocalDateTime startDate, 
                                      @Param("endDate") LocalDateTime endDate, 
                                      Pageable pageable);
    
    /**
     * Trouve les utilisateurs avec email non vérifié
     * 
     * @param pageable la pagination
     * @return la page d'utilisateurs
     */
    @Query("SELECT u FROM User u WHERE u.emailVerified = false")
    Page<User> findUsersWithUnverifiedEmail(Pageable pageable);
    
    /**
     * Trouve les utilisateurs avec téléphone non vérifié
     * 
     * @param pageable la pagination
     * @return la page d'utilisateurs
     */
    @Query("SELECT u FROM User u WHERE u.phoneVerified = false AND u.phoneNumber IS NOT NULL")
    Page<User> findUsersWithUnverifiedPhone(Pageable pageable);
    
    /**
     * Compte le nombre d'utilisateurs actifs
     * 
     * @return le nombre d'utilisateurs actifs
     */
    @Query("SELECT COUNT(u) FROM User u WHERE u.active = true")
    long countActiveUsers();
    
    /**
     * Compte le nombre d'utilisateurs par rôle
     * 
     * @param role le rôle
     * @return le nombre d'utilisateurs
     */
    @Query("SELECT COUNT(u) FROM User u WHERE u.role = :role")
    long countByRole(@Param("role") User.UserRole role);
}
