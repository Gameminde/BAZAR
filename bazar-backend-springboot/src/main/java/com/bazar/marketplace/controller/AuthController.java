package com.bazar.marketplace.controller;

import com.bazar.marketplace.dto.AuthRequestDTO;
import com.bazar.marketplace.dto.AuthResponseDTO;
import com.bazar.marketplace.dto.RefreshTokenRequestDTO;
import com.bazar.marketplace.dto.RegisterRequestDTO;
import com.bazar.marketplace.entity.User;
import com.bazar.marketplace.security.JwtTokenProvider;
import com.bazar.marketplace.security.UserPrincipal;
import com.bazar.marketplace.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Authentication Controller
 * Handles login, registration, token refresh, and logout
 */
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@Slf4j
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final AuthService authService;
    private final JwtTokenProvider tokenProvider;

    /**
     * User Login
     */
    @PostMapping("/login")
    public ResponseEntity<AuthResponseDTO> login(@Valid @RequestBody AuthRequestDTO loginRequest) {
        try {
            // Authenticate user
            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                    loginRequest.getEmail(),
                    loginRequest.getPassword()
                )
            );

            SecurityContextHolder.getContext().setAuthentication(authentication);
            UserPrincipal userPrincipal = (UserPrincipal) authentication.getPrincipal();

            // Generate tokens
            String accessToken = tokenProvider.generateAccessToken(userPrincipal);
            String refreshToken = tokenProvider.generateRefreshToken(userPrincipal);

            // Update last login
            authService.updateLastLogin(userPrincipal.getId());

            AuthResponseDTO response = AuthResponseDTO.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(900) // 15 minutes
                .user(AuthResponseDTO.UserInfo.builder()
                    .id(userPrincipal.getId())
                    .email(userPrincipal.getEmail())
                    .firstName(userPrincipal.getFirstName())
                    .lastName(userPrincipal.getLastName())
                    .isVerified(userPrincipal.isVerified())
                    .build())
                .build();

            log.info("User logged in successfully: {}", userPrincipal.getEmail());
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("Login failed for email: {}", loginRequest.getEmail(), e);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(AuthResponseDTO.builder()
                    .error("Invalid credentials")
                    .message("Email or password is incorrect")
                    .build());
        }
    }

    /**
     * User Registration
     */
    @PostMapping("/register")
    public ResponseEntity<AuthResponseDTO> register(@Valid @RequestBody RegisterRequestDTO registerRequest) {
        try {
            // Check if user already exists
            if (authService.existsByEmail(registerRequest.getEmail())) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(AuthResponseDTO.builder()
                        .error("User already exists")
                        .message("An account with this email already exists")
                        .build());
            }

            // Create new user
            User newUser = authService.createUser(registerRequest);
            UserPrincipal userPrincipal = UserPrincipal.create(newUser);

            // Generate tokens
            String accessToken = tokenProvider.generateAccessToken(userPrincipal);
            String refreshToken = tokenProvider.generateRefreshToken(userPrincipal);

            AuthResponseDTO response = AuthResponseDTO.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(900) // 15 minutes
                .user(AuthResponseDTO.UserInfo.builder()
                    .id(newUser.getId())
                    .email(newUser.getEmail())
                    .firstName(newUser.getFirstName())
                    .lastName(newUser.getLastName())
                    .isVerified(newUser.getIsVerified())
                    .build())
                .build();

            log.info("User registered successfully: {}", newUser.getEmail());
            return ResponseEntity.status(HttpStatus.CREATED).body(response);

        } catch (Exception e) {
            log.error("Registration failed for email: {}", registerRequest.getEmail(), e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(AuthResponseDTO.builder()
                    .error("Registration failed")
                    .message("Unable to create account. Please try again.")
                    .build());
        }
    }

    /**
     * Refresh Access Token
     */
    @PostMapping("/refresh")
    public ResponseEntity<AuthResponseDTO> refreshToken(@Valid @RequestBody RefreshTokenRequestDTO refreshRequest) {
        try {
            String refreshToken = refreshRequest.getRefreshToken();

            // Validate refresh token
            if (!tokenProvider.validateRefreshToken(refreshToken)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(AuthResponseDTO.builder()
                        .error("Invalid refresh token")
                        .message("Refresh token is invalid or expired")
                        .build());
            }

            // Get user from refresh token
            Long userId = tokenProvider.getUserIdFromToken(refreshToken);
            UserPrincipal userPrincipal = (UserPrincipal) authService.loadUserById(userId);

            // Generate new access token
            String newAccessToken = tokenProvider.generateAccessToken(userPrincipal);

            AuthResponseDTO response = AuthResponseDTO.builder()
                .accessToken(newAccessToken)
                .refreshToken(refreshToken) // Keep the same refresh token
                .tokenType("Bearer")
                .expiresIn(900) // 15 minutes
                .build();

            log.debug("Access token refreshed for user: {}", userId);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("Token refresh failed", e);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(AuthResponseDTO.builder()
                    .error("Token refresh failed")
                    .message("Unable to refresh token. Please login again.")
                    .build());
        }
    }

    /**
     * User Logout
     */
    @PostMapping("/logout")
    public ResponseEntity<Map<String, String>> logout(@RequestHeader("Authorization") String authHeader) {
        try {
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                String token = authHeader.substring(7);
                
                // Blacklist the token
                tokenProvider.blacklistToken(token);
                
                // Clear security context
                SecurityContextHolder.clearContext();
                
                log.info("User logged out successfully");
            }

            Map<String, String> response = new HashMap<>();
            response.put("message", "Logged out successfully");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("Logout failed", e);
            Map<String, String> response = new HashMap<>();
            response.put("error", "Logout failed");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Get Current User Info
     */
    @GetMapping("/me")
    public ResponseEntity<AuthResponseDTO.UserInfo> getCurrentUser() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            UserPrincipal userPrincipal = (UserPrincipal) authentication.getPrincipal();

            AuthResponseDTO.UserInfo userInfo = AuthResponseDTO.UserInfo.builder()
                .id(userPrincipal.getId())
                .email(userPrincipal.getEmail())
                .firstName(userPrincipal.getFirstName())
                .lastName(userPrincipal.getLastName())
                .isVerified(userPrincipal.isVerified())
                .build();

            return ResponseEntity.ok(userInfo);

        } catch (Exception e) {
            log.error("Failed to get current user", e);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }

    /**
     * Change Password
     */
    @PostMapping("/change-password")
    public ResponseEntity<Map<String, String>> changePassword(
            @RequestBody Map<String, String> passwordRequest) {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            UserPrincipal userPrincipal = (UserPrincipal) authentication.getPrincipal();

            String currentPassword = passwordRequest.get("currentPassword");
            String newPassword = passwordRequest.get("newPassword");

            boolean success = authService.changePassword(
                userPrincipal.getId(), 
                currentPassword, 
                newPassword
            );

            if (success) {
                Map<String, String> response = new HashMap<>();
                response.put("message", "Password changed successfully");
                return ResponseEntity.ok(response);
            } else {
                Map<String, String> response = new HashMap<>();
                response.put("error", "Current password is incorrect");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }

        } catch (Exception e) {
            log.error("Password change failed", e);
            Map<String, String> response = new HashMap<>();
            response.put("error", "Password change failed");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
