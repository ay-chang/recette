package com.recette.allenchang.backend.dto.responses;

public record UserResponse(
    String id,
    String username,
    String email,
    String firstName,
    String lastName
) {}
