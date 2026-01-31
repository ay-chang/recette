package com.recette.allenchang.backend.dto.requests;

import java.util.List;

import com.recette.allenchang.backend.dto.requests.IngredientRequest;

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
