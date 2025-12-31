package com.recette.allenchang.backend.recipes.mappers;

import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.recipes.dto.responses.IngredientResponse;
import com.recette.allenchang.backend.recipes.dto.responses.RecipeResponse;

public class RecipeMapper {

        public static RecipeResponse toResponse(Recipe recipe) {
                return new RecipeResponse(
                                recipe.getId(),
                                recipe.getTitle(),
                                recipe.getDescription(),
                                recipe.getImageurl(),
                                recipe.getIngredients() == null ? null
                                                : recipe.getIngredients().stream()
                                                                .map(i -> new IngredientResponse(i.getName(),
                                                                                i.getMeasurement()))
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
