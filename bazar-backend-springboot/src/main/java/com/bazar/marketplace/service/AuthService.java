package com.bazar.marketplace.service;

import com.bazar.marketplace.dto.RegisterRequestDTO;
import com.bazar.marketplace.entity.User;
import com.bazar.marketplace.repository.UserRepository;
import com.bazar.marketplace.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

/**
 * Authentication Service
 * Handles user authentication, registration, and password management
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    /**
     * Create new user account
     */
    @Transactional
    public User createUser(RegisterRequestDTO registerRequest) {
        // Check if user already exists
        if (userRepository.existsByEmail(registerRequest.getEmail())) {
            throw new RuntimeException("User with email " + registerRequest.getEmail() + " already exists");
        }

        // Create new user
        User user = new User();
        user.setEmail(registerRequest.getEmail());
        user.setPasswordHash(passwordEncoder.encode(registerRequest.getPassword()));
        user.setFirstName(registerRequest.getFirstName());
        user.setLastName(registerRequest.getLastName());
        user.setPhone(registerRequest.getPhone());
        user.setIsActive(true);
        user.setIsVerified(false); // Email verification required
        user.setFailedLoginAttempts(0);

        User savedUser = userRepository.save(user);
        log.info("New user created: {}", savedUser.getEmail());

        // TODO: Send email verification
        // emailService.sendVerificationEmail(savedUser);

        return savedUser;
    }

    /**
     * Check if user exists by email
     */
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    /**
     * Load user by ID
     */
    public UserDetails loadUserById(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with id: " + userId));

        return UserPrincipal.create(user);
    }

    /**
     * Update last login timestamp
     */
    @Transactional
    @CacheEvict(value = "users", key = "#userId")
    public void updateLastLogin(Long userId) {
        userRepository.findById(userId).ifPresent(user -> {
            user.setLastLoginAt(LocalDateTime.now());
            user.setFailedLoginAttempts(0); // Reset failed attempts on successful login
            userRepository.save(user);
        });
    }

    /**
     * Increment failed login attempts
     */
    @Transactional
    @CacheEvict(value = "users", key = "#email")
    public void incrementFailedLoginAttempts(String email) {
        userRepository.findByEmail(email).ifPresent(user -> {
            int failedAttempts = user.getFailedLoginAttempts() + 1;
            user.setFailedLoginAttempts(failedAttempts);

            // Lock account after 5 failed attempts for 15 minutes
            if (failedAttempts >= 5) {
                user.setLockedUntil(LocalDateTime.now().plusMinutes(15));
                log.warn("User account locked due to too many failed login attempts: {}", email);
            }

            userRepository.save(user);
        });
    }

    /**
     * Check if user account is locked
     */
    public boolean isAccountLocked(String email) {
        return userRepository.findByEmail(email)
                .map(user -> user.getLockedUntil() != null && 
                           user.getLockedUntil().isAfter(LocalDateTime.now()))
                .orElse(false);
    }

    /**
     * Unlock user account
     */
    @Transactional
    @CacheEvict(value = "users", key = "#email")
    public void unlockAccount(String email) {
        userRepository.findByEmail(email).ifPresent(user -> {
            user.setLockedUntil(null);
            user.setFailedLoginAttempts(0);
            userRepository.save(user);
            log.info("User account unlocked: {}", email);
        });
    }

    /**
     * Change user password
     */
    @Transactional
    @CacheEvict(value = "users", key = "#userId")
    public boolean changePassword(Long userId, String currentPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        // Verify current password
        if (!passwordEncoder.matches(currentPassword, user.getPasswordHash())) {
            return false;
        }

        // Update password
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        log.info("Password changed for user: {}", user.getEmail());
        return true;
    }

    /**
     * Reset password (for forgot password functionality)
     */
    @Transactional
    @CacheEvict(value = "users", key = "#email")
    public void resetPassword(String email, String newPassword) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        log.info("Password reset for user: {}", email);
    }

    /**
     * Verify user email
     */
    @Transactional
    @CacheEvict(value = "users", key = "#userId")
    public void verifyEmail(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        user.setIsVerified(true);
        user.setEmailVerifiedAt(LocalDateTime.now());
        userRepository.save(user);

        log.info("Email verified for user: {}", user.getEmail());
    }

    /**
     * Deactivate user account
     */
    @Transactional
    @CacheEvict(value = "users", key = "#userId")
    public void deactivateAccount(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        user.setIsActive(false);
        userRepository.save(user);

        log.info("Account deactivated for user: {}", user.getEmail());
    }

    /**
     * Activate user account
     */
    @Transactional
    @CacheEvict(value = "users", key = "#userId")
    public void activateAccount(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        user.setIsActive(true);
        user.setLockedUntil(null);
        user.setFailedLoginAttempts(0);
        userRepository.save(user);

        log.info("Account activated for user: {}", user.getEmail());
    }
}
