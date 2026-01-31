package com.recette.allenchang.backend.mappers;

import com.recette.allenchang.backend.models.Ingredient;
import com.recette.allenchang.backend.dto.responses.IngredientResponse;

public class IngredientMapper {

    public static IngredientResponse toResponse(Ingredient ingredient) {
        return new IngredientResponse(
            ingredient.getId().toString(),
            ingredient.getName(),
            ingredient.getMeasurement(),
            ingredient.getRecipe() != null ? ingredient.getRecipe().getId().toString() : null
        );
    }
}
