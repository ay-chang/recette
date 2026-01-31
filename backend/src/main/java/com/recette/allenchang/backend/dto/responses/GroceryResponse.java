package com.recette.allenchang.backend.dto.responses;

public record GroceryResponse(
    String id,
    String name,
    String measurement,
    boolean checked,
    String recipeId,
    String recipeTitle
) {}
