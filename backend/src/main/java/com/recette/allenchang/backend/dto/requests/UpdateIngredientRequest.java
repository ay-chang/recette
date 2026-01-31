package com.recette.allenchang.backend.dto.requests;

public record UpdateIngredientRequest(
    String name,
    String measurement
) {}
