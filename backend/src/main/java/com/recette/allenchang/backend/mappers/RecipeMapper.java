package com.recette.allenchang.backend.mappers;

import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.dto.responses.IngredientResponse;
import com.recette.allenchang.backend.dto.responses.RecipeResponse;
import com.recette.allenchang.backend.dto.responses.UserResponse;

public class RecipeMapper {

        /** Maps recipe to response (for user's own recipes, without owner/saved info) */
        public static RecipeResponse toResponse(Recipe recipe) {
                return toResponse(recipe, null, null);
        }

        /** Maps recipe to response with owner and saved state (for social feed) */
        public static RecipeResponse toResponse(Recipe recipe, UserResponse owner, Boolean isSaved) {
                return new RecipeResponse(
                                recipe.getId(),
                                recipe.getTitle(),
                                recipe.getDescription(),
                                recipe.getImageurl(),
                                recipe.getIngredients() == null ? null
                                                : recipe.getIngredients().stream()
                                                                .map(i -> new IngredientResponse(
                                                                                i.getId().toString(),
                                                                                i.getName(),
                                                                                i.getMeasurement(),
                                                                                recipe.getId().toString()))
                                                                .toList(),
                                recipe.getSteps(),
                                recipe.getTags() == null ? null
                                                : recipe.getTags().stream()
                                                                .map(tag -> tag.getName())
                                                                .toList(),
                                recipe.getDifficulty(),
                                recipe.getServingSize(),
                                recipe.getCookTimeInMinutes(),
                                recipe.getIsPublic(),
                                owner,
                                isSaved);
        }
}
