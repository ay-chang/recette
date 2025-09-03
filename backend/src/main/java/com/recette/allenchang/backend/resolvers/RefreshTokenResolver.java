package com.recette.allenchang.backend.resolvers;

import java.util.Date;
import java.util.UUID;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.services.RefreshTokenService;

@Controller
public class RefreshTokenResolver {

    private final JwtUtil jwtUtil;
    private final RefreshTokenService refreshTokenService;

    public record AuthPayload(String accessToken, String refreshToken) {
    }

    public RefreshTokenResolver(JwtUtil jwtUtil, RefreshTokenService refreshTokenService) {
        this.jwtUtil = jwtUtil;
        this.refreshTokenService = refreshTokenService;
    }

    @MutationMapping
    public AuthPayload refresh(@Argument String refreshToken) {
        // 1) cryptographic validation (signature, exp)
        if (!jwtUtil.validateRefresh(refreshToken)) {
            throw new RuntimeException("Invalid refresh token");
        }

        // 2) jti must be active (not revoked, not expired in DB)
        String oldJti = jwtUtil.extractJtiFromRefresh(refreshToken);
        if (!refreshTokenService.isActive(oldJti)) {
            // Optional: treat as token reuse -> force re-login
            throw new RuntimeException("Refresh token is no longer valid");
        }

        // 3) rotate: revoke old jti, mint new pair
        refreshTokenService.revoke(oldJti);

        String email = jwtUtil.extractEmailFromRefresh(refreshToken);
        String newAccess = jwtUtil.generateAccessToken(email);

        String newJti = UUID.randomUUID().toString();
        String newRefresh = jwtUtil.generateRefreshToken(email, newJti);
        refreshTokenService.save(
                newJti, email, new Date(System.currentTimeMillis() + 1000L * 60 * 60 * 24 * 30));

        return new AuthPayload(newAccess, newRefresh);
    }
}
