package com.recette.allenchang.backend.dto.responses;

import java.util.List;
import java.util.UUID;

import com.recette.allenchang.backend.dto.responses.IngredientResponse;

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