package com.recette.allenchang.backend.mappers;

import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.dto.responses.IngredientResponse;
import com.recette.allenchang.backend.dto.responses.RecipeResponse;

public class RecipeMapper {

        public static RecipeResponse toResponse(Recipe recipe) {
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
                                recipe.getCookTimeInMinutes());
        }
}
