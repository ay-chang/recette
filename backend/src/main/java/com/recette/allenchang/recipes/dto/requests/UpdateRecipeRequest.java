package com.recette.allenchang.recipes.dto;

import java.util.List;

// UpdateRecipeRequest.java
public record UpdateRecipeRequest(
        String title,
        String description,
        String imageurl,
        List<IngredientRequest> ingredients,
        List<String> steps,
        List<String> tags,
        String difficulty,
        Integer servingSize,
        Integer cookTimeInMinutes) {
}
