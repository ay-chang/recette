package com.recette.allenchang.backend.recipes.dto.responses;

import java.util.List;
import java.util.UUID;

public record RecipeResponse(
                UUID id,
                String title,
                String description,
                String imageurl,
                List<IngredientResponse> ingredients,
                List<String> steps,
                List<String> tags,
                String difficulty,
                Integer servingSize,
                Integer cookTimeInMinutes) {
}