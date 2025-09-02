package com.recette.allenchang.backend.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
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
    private String accessSecret; // keep current secret for access tokens

    @Value("${jwt.refresh-secret}")
    private String refreshSecret; // use a different secret for refresh

    private SecretKey accessKey;
    private SecretKey refreshKey;

    @PostConstruct
    public void init() {
        this.accessKey = Keys.hmacShaKeyFor(accessSecret.getBytes(StandardCharsets.UTF_8));
        this.refreshKey = Keys.hmacShaKeyFor(refreshSecret.getBytes(StandardCharsets.UTF_8));
    }

    /** Generate token with the users email that expires in 15 minutes */
    public String generateAccessToken(String email) {
        long expMs = 1000L * 60 * 15; // 15 minutes
        Date now = new Date();
        return Jwts.builder()
                .setSubject(email)
                .setIssuedAt(now)
                .setExpiration(new Date(now.getTime() + expMs))
                .signWith(accessKey, SignatureAlgorithm.HS256)
                .compact();
    }

    /** Generate a refresh token that refreshes every 30 days */
    public String generateRefreshToken(String email, String jti) {
        long expMs = 1000L * 60 * 60 * 24 * 30; // 30 days
        Date now = new Date();
        return Jwts.builder()
                .setSubject(email)
                .setId(jti) // for rotation/revocation
                .setIssuedAt(now)
                .setExpiration(new Date(now.getTime() + expMs))
                .signWith(refreshKey, SignatureAlgorithm.HS256)
                .compact();
    }

    public String extractEmailFromAccess(String token) {
        return Jwts.parserBuilder().setSigningKey(accessKey).build()
                .parseClaimsJws(token).getBody().getSubject();
    }

    public String extractEmailFromRefresh(String token) {
        return Jwts.parserBuilder().setSigningKey(refreshKey).build()
                .parseClaimsJws(token).getBody().getSubject();
    }

    public String extractJtiFromRefresh(String token) {
        return Jwts.parserBuilder().setSigningKey(refreshKey).build()
                .parseClaimsJws(token).getBody().getId();
    }

    public boolean validateAccess(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(accessKey).build().parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * Verifies that the token is signed with the secret key, Not expired, and not
     * tampered with.
     */
    public boolean validateRefresh(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(refreshKey).build().parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    public static String getLoggedInUserEmail() {
        var auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getPrincipal() == null)
            throw new RuntimeException("Unauthorized");
        return (String) auth.getPrincipal();
    }
}