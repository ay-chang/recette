package com.recette.allenchang.backend.mappers;

import com.recette.allenchang.backend.models.Grocery;
import com.recette.allenchang.backend.dto.responses.GroceryResponse;

public class GroceryMapper {

    public static GroceryResponse toResponse(Grocery grocery) {
        return new GroceryResponse(
            grocery.getId().toString(),
            grocery.getName(),
            grocery.getMeasurement(),
            grocery.getChecked(),
            grocery.getRecipe() != null ? grocery.getRecipe().getId().toString() : null,
            grocery.getRecipe() != null ? grocery.getRecipe().getTitle() : "No Recipe"
        );
    }
}
