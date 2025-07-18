package com.recette.allenchang.backend.verification;

import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class VerificationCodeStore {
    private static record CodeEntry(String code, LocalDateTime expiresAt, String password) {
    }

    private final Map<String, CodeEntry> store = new ConcurrentHashMap<>();

    public void store(String email, String code, String rawPassword) {
        store.put(email, new CodeEntry(code, LocalDateTime.now().plusMinutes(10), rawPassword));
    }

    public boolean isCodeValid(String email, String inputCode) {
        CodeEntry entry = store.get(email);
        if (entry == null || LocalDateTime.now().isAfter(entry.expiresAt()))
            return false;
        return entry.code().equals(inputCode);
    }

    public String getStoredPassword(String email) {
        CodeEntry entry = store.get(email);
        return (entry != null) ? entry.password() : null;
    }

    public void clear(String email) {
        store.remove(email);
    }
}
