package com.recette.allenchang.backend.recipes.mappers;

import com.recette.allenchang.backend.recipes.dto.requests.FilterRecipeRequest;
import com.recette.allenchang.backend.inputs.RecipeFilterInput;

public class RecipeFilterMapper {

    public static RecipeFilterInput toInput(FilterRecipeRequest req) {
        RecipeFilterInput input = new RecipeFilterInput();
        input.setTags(req.tags());
        input.setDifficulties(req.difficulties());
        input.setMaxCookTimeInMinutes(req.maxCookTimeInMinutes());
        return input;
    }
}
