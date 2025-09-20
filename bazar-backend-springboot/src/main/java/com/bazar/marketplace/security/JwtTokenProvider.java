package com.bazar.marketplace.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SecurityException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import java.security.Key;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * JWT Token Provider with RS256 Algorithm and Key Rotation
 * Enterprise-grade security implementation
 */
@Component
@Slf4j
public class JwtTokenProvider {

    @Value("${security.jwt.expiration:900000}")  // 15 minutes
    private long jwtExpirationMs;

    @Value("${security.jwt.refresh-expiration:604800000}")  // 7 days
    private long refreshExpirationMs;

    @Value("${security.jwt.issuer:bazar-marketplace}")
    private String issuer;

    @Value("${security.jwt.key-rotation-hours:24}")
    private int keyRotationHours;

    private KeyPair currentKeyPair;
    private KeyPair previousKeyPair;
    private String currentKeyId;
    private String previousKeyId;

    private final RedisTemplate<String, String> redisTemplate;
    private static final String BLACKLIST_PREFIX = "jwt:blacklist:";
    private static final String KEY_ROTATION_PREFIX = "jwt:keys:";

    public JwtTokenProvider(RedisTemplate<String, String> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    @PostConstruct
    public void init() {
        try {
            generateKeyPairs();
            log.info("JWT Token Provider initialized with RS256 algorithm");
        } catch (Exception e) {
            log.error("Failed to initialize JWT Token Provider", e);
            throw new RuntimeException("JWT initialization failed", e);
        }
    }

    /**
     * Generate RSA key pairs for JWT signing
     */
    private void generateKeyPairs() throws NoSuchAlgorithmException {
        KeyPairGenerator keyGenerator = KeyPairGenerator.getInstance("RSA");
        keyGenerator.initialize(2048);

        // Generate current key pair
        currentKeyPair = keyGenerator.generateKeyPair();
        currentKeyId = UUID.randomUUID().toString();

        // Generate previous key pair (for key rotation)
        previousKeyPair = keyGenerator.generateKeyPair();
        previousKeyId = UUID.randomUUID().toString();

        log.info("Generated RSA key pairs for JWT signing. Current Key ID: {}", currentKeyId);
    }

    /**
     * Generate Access Token
     */
    public String generateAccessToken(Authentication authentication) {
        UserPrincipal userPrincipal = (UserPrincipal) authentication.getPrincipal();
        return generateAccessToken(userPrincipal);
    }

    public String generateAccessToken(UserPrincipal userPrincipal) {
        Instant now = Instant.now();
        Instant expiryDate = now.plus(jwtExpirationMs, ChronoUnit.MILLIS);

        List<String> authorities = userPrincipal.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());

        return Jwts.builder()
                .setSubject(userPrincipal.getId().toString())
                .setIssuer(issuer)
                .setIssuedAt(Date.from(now))
                .setExpiration(Date.from(expiryDate))
                .claim("email", userPrincipal.getEmail())
                .claim("authorities", authorities)
                .claim("type", "access")
                .setHeaderParam("kid", currentKeyId)
                .signWith(currentKeyPair.getPrivate(), SignatureAlgorithm.RS256)
                .compact();
    }

    /**
     * Generate Refresh Token
     */
    public String generateRefreshToken(UserPrincipal userPrincipal) {
        Instant now = Instant.now();
        Instant expiryDate = now.plus(refreshExpirationMs, ChronoUnit.MILLIS);

        String tokenId = UUID.randomUUID().toString();

        // Store refresh token in Redis for revocation capability
        String redisKey = "refresh_token:" + userPrincipal.getId() + ":" + tokenId;
        redisTemplate.opsForValue().set(redisKey, "valid", refreshExpirationMs, TimeUnit.MILLISECONDS);

        return Jwts.builder()
                .setSubject(userPrincipal.getId().toString())
                .setIssuer(issuer)
                .setIssuedAt(Date.from(now))
                .setExpiration(Date.from(expiryDate))
                .claim("type", "refresh")
                .claim("tokenId", tokenId)
                .setHeaderParam("kid", currentKeyId)
                .signWith(currentKeyPair.getPrivate(), SignatureAlgorithm.RS256)
                .compact();
    }

    /**
     * Get User ID from JWT Token
     */
    public Long getUserIdFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return Long.valueOf(claims.getSubject());
    }

    /**
     * Get Email from JWT Token
     */
    public String getEmailFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.get("email", String.class);
    }

    /**
     * Get Authorities from JWT Token
     */
    @SuppressWarnings("unchecked")
    public List<String> getAuthoritiesFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.get("authorities", List.class);
    }

    /**
     * Get Token Type (access/refresh)
     */
    public String getTokenType(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.get("type", String.class);
    }

    /**
     * Validate JWT Token
     */
    public boolean validateToken(String token) {
        try {
            // Check if token is blacklisted
            if (isTokenBlacklisted(token)) {
                log.warn("Token is blacklisted");
                return false;
            }

            // Parse and validate token
            getClaimsFromToken(token);
            return true;

        } catch (SecurityException ex) {
            log.error("Invalid JWT signature: {}", ex.getMessage());
        } catch (MalformedJwtException ex) {
            log.error("Invalid JWT token: {}", ex.getMessage());
        } catch (ExpiredJwtException ex) {
            log.error("Expired JWT token: {}", ex.getMessage());
        } catch (UnsupportedJwtException ex) {
            log.error("Unsupported JWT token: {}", ex.getMessage());
        } catch (IllegalArgumentException ex) {
            log.error("JWT claims string is empty: {}", ex.getMessage());
        } catch (Exception ex) {
            log.error("JWT validation error: {}", ex.getMessage());
        }

        return false;
    }

    /**
     * Get Claims from Token with Key Rotation Support
     */
    private Claims getClaimsFromToken(String token) {
        try {
            // Try with current key first
            return parseTokenWithKey(token, currentKeyPair.getPublic());
        } catch (Exception e) {
            log.debug("Failed to parse with current key, trying previous key");
            try {
                // Try with previous key (for key rotation period)
                return parseTokenWithKey(token, previousKeyPair.getPublic());
            } catch (Exception ex) {
                log.error("Failed to parse token with both current and previous keys");
                throw ex;
            }
        }
    }

    /**
     * Parse Token with Specific Key
     */
    private Claims parseTokenWithKey(String token, Key key) {
        try {
            return Jwts.parser()
                    .setSigningKey(key)
                    .requireIssuer(issuer)
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            log.error("Failed to parse JWT token", e);
            throw new RuntimeException("Invalid JWT token", e);
        }
    }

    /**
     * Blacklist Token (for logout)
     */
    public void blacklistToken(String token) {
        try {
            Claims claims = getClaimsFromToken(token);
            Date expiration = claims.getExpiration();
            long ttl = expiration.getTime() - System.currentTimeMillis();

            if (ttl > 0) {
                String tokenHash = Integer.toString(token.hashCode());
                redisTemplate.opsForValue().set(
                    BLACKLIST_PREFIX + tokenHash, 
                    "blacklisted", 
                    ttl, 
                    TimeUnit.MILLISECONDS
                );
                log.info("Token blacklisted successfully");
            }
        } catch (Exception e) {
            log.error("Failed to blacklist token", e);
        }
    }

    /**
     * Check if Token is Blacklisted
     */
    private boolean isTokenBlacklisted(String token) {
        try {
            String tokenHash = Integer.toString(token.hashCode());
            return redisTemplate.hasKey(BLACKLIST_PREFIX + tokenHash);
        } catch (Exception e) {
            log.error("Failed to check token blacklist status", e);
            return false;
        }
    }

    /**
     * Rotate Keys (should be called periodically)
     */
    public void rotateKeys() {
        try {
            log.info("Starting key rotation process");
            
            // Move current key to previous
            previousKeyPair = currentKeyPair;
            previousKeyId = currentKeyId;

            // Generate new current key
            KeyPairGenerator keyGenerator = KeyPairGenerator.getInstance("RSA");
            keyGenerator.initialize(2048);
            currentKeyPair = keyGenerator.generateKeyPair();
            currentKeyId = UUID.randomUUID().toString();

            log.info("Key rotation completed. New Key ID: {}, Previous Key ID: {}", 
                    currentKeyId, previousKeyId);

        } catch (Exception e) {
            log.error("Failed to rotate keys", e);
            throw new RuntimeException("Key rotation failed", e);
        }
    }

    /**
     * Get Current Public Key (for external verification)
     */
    public Key getCurrentPublicKey() {
        return currentKeyPair.getPublic();
    }

    /**
     * Get Current Key ID
     */
    public String getCurrentKeyId() {
        return currentKeyId;
    }

    /**
     * Revoke Refresh Token
     */
    public void revokeRefreshToken(Long userId, String tokenId) {
        String redisKey = "refresh_token:" + userId + ":" + tokenId;
        redisTemplate.delete(redisKey);
        log.info("Refresh token revoked for user: {}", userId);
    }

    /**
     * Validate Refresh Token
     */
    public boolean validateRefreshToken(String token) {
        try {
            if (!validateToken(token)) {
                return false;
            }

            Claims claims = getClaimsFromToken(token);
            String tokenType = claims.get("type", String.class);
            
            if (!"refresh".equals(tokenType)) {
                return false;
            }

            // Check if refresh token exists in Redis
            Long userId = Long.valueOf(claims.getSubject());
            String tokenId = claims.get("tokenId", String.class);
            String redisKey = "refresh_token:" + userId + ":" + tokenId;

            return redisTemplate.hasKey(redisKey);

        } catch (Exception e) {
            log.error("Refresh token validation failed", e);
            return false;
        }
    }
}
