package com.recette.allenchang.backend.verification;

import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@Component
public class PasswordResetStore {
    private static final int MAX_ATTEMPTS = 5;
    private static final int LOCKOUT_MINUTES = 15;

    private static record ResetEntry(String code, LocalDateTime expiresAt) {}
    private static record AttemptEntry(AtomicInteger count, LocalDateTime lockedUntil) {}

    private final Map<String, ResetEntry> store = new ConcurrentHashMap<>();
    private final Map<String, AttemptEntry> attempts = new ConcurrentHashMap<>();

    public void store(String email, String code) {
        store.put(email, new ResetEntry(code, LocalDateTime.now().plusMinutes(10)));
        attempts.remove(email);
    }

    public boolean isLockedOut(String email) {
        AttemptEntry entry = attempts.get(email);
        if (entry == null) return false;
        if (entry.lockedUntil() != null && LocalDateTime.now().isBefore(entry.lockedUntil())) {
            return true;
        }
        if (entry.lockedUntil() != null && LocalDateTime.now().isAfter(entry.lockedUntil())) {
            attempts.remove(email);
            return false;
        }
        return false;
    }

    public boolean isCodeValid(String email, String inputCode) {
        if (isLockedOut(email)) return false;

        ResetEntry entry = store.get(email);
        if (entry == null || LocalDateTime.now().isAfter(entry.expiresAt()))
            return false;

        if (entry.code().equals(inputCode)) {
            attempts.remove(email);
            return true;
        }

        AttemptEntry attemptEntry = attempts.computeIfAbsent(email,
                k -> new AttemptEntry(new AtomicInteger(0), null));
        int count = attemptEntry.count().incrementAndGet();
        if (count >= MAX_ATTEMPTS) {
            attempts.put(email, new AttemptEntry(new AtomicInteger(count),
                    LocalDateTime.now().plusMinutes(LOCKOUT_MINUTES)));
        }

        return false;
    }

    public void clear(String email) {
        store.remove(email);
        attempts.remove(email);
    }
}
