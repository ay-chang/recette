package com.recette.allenchang.backend.auth.dto.requests;

public record ResetPasswordRequest(String email, String code, String newPassword) {
}
