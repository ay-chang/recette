package com.recette.allenchang.backend.auth.dto.requests;

public record SendVerificationCodeRequest(String email, String password) {
}
