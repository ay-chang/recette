package com.recette.allenchang.backend.dto.responses;

public record IngredientResponse(
    String id,
    String name,
    String measurement,
    String recipeId
) {}
