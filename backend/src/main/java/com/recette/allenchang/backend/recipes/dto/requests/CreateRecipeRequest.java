package com.recette.allenchang.backend.recipes.dto.requests;

import java.util.List;

public record CreateRecipeRequest(
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