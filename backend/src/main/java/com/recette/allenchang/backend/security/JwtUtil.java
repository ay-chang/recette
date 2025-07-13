package com.recette.allenchang.backend.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

/**
 * This is your token toolkit to sign tokens on login, verify tokens on
 * requests, and extract the user email (aka "subject") from the token
 */
@Component
public class JwtUtil {

    @Value("${jwt.secret}")
    private String secret;

    private SecretKey secretKey;

    @PostConstruct
    public void init() {
        this.secretKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }

    /** Create token with the users email with an expiration of 24 hours */
    public String generateToken(String email) {
        long expirationMillis = 1000L * 60 * 60 * 24 * 30;
        Date expiration = new Date(System.currentTimeMillis() + expirationMillis);

        return Jwts.builder()
                .setSubject(email)
                .setIssuedAt(new Date())
                .setExpiration(expiration) // 30 days
                .signWith(secretKey, SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * Reads the "sub" (subject) claim from the JWT payload which we use as the
     * user's identity.
     */
    public String extractEmail(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getSubject();
    }

    /**
     * Verifies that the token is signed with the secret key, Not expired, and not
     * tampered with.
     */
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(secretKey)
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            System.out.println("WT validation error: " + e.getMessage());
            return false;
        }
    }

    public static String getLoggedInUserEmail() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        System.out.println("DEBUG: Authentication object: " + auth);
        if (auth == null || auth.getPrincipal() == null) {
            throw new RuntimeException("Unauthorized");
        }
        return (String) auth.getPrincipal();
    }
}
