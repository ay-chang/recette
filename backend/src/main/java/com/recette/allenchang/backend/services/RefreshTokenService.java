package com.recette.allenchang.backend.services;

import java.util.Date;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.RefreshToken;
import com.recette.allenchang.backend.repositories.RefreshTokenRepository;

@Service
public class RefreshTokenService {
    private final RefreshTokenRepository repo;

    public RefreshTokenService(RefreshTokenRepository repo) {
        this.repo = repo;
    }

    public void save(String jti, String email, Date expiresAt) {
        var t = new RefreshToken();
        t.setJti(jti);
        t.setEmail(email);
        t.setRevoked(false);
        t.setExpiresAt(expiresAt);
        repo.save(t);
    }

    public boolean isActive(String jti) {
        return repo.findByJtiAndRevokedFalse(jti).isPresent();
    }

    public void revoke(String jti) {
        repo.findByJtiAndRevokedFalse(jti).ifPresent(t -> {
            t.setRevoked(true);
            repo.save(t);
        });
    }
}
