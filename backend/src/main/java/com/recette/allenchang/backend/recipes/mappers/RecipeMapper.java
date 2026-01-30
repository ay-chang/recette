package com.recette.allenchang.backend.recipes.mappers;

import java.util.UUID;
import java.util.stream.Collectors;

import com.recette.allenchang.backend.inputs.IngredientInput;
import com.recette.allenchang.backend.inputs.RecipeInput;
import com.recette.allenchang.backend.inputs.UpdateRecipeInput;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.recipes.dto.requests.CreateRecipeRequest;
import com.recette.allenchang.backend.recipes.dto.requests.IngredientRequest;
import com.recette.allenchang.backend.recipes.dto.requests.UpdateRecipeRequest;
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

        public static RecipeInput toInput(CreateRecipeRequest request) {
                RecipeInput input = new RecipeInput();
                input.setTitle(request.title());
                input.setDescription(request.description());
                input.setImageurl(request.imageurl());
                input.setIngredients(request.ingredients() == null ? null
                                : request.ingredients().stream()
                                                .map(RecipeMapper::toIngredientInput)
                                                .collect(Collectors.toList()));
                input.setSteps(request.steps());
                input.setTags(request.tags());
                input.setDifficulty(request.difficulty());
                input.setServingSize(request.servingSize());
                input.setCookTimeInMinutes(request.cookTimeInMinutes());
                return input;
        }

        public static UpdateRecipeInput toUpdateInput(String id, UpdateRecipeRequest request) {
                UpdateRecipeInput input = new UpdateRecipeInput();
                input.setId(UUID.fromString(id));
                input.setTitle(request.title());
                input.setDescription(request.description());
                input.setImageurl(request.imageurl());
                input.setIngredients(request.ingredients() == null ? null
                                : request.ingredients().stream()
                                                .map(RecipeMapper::toIngredientInput)
                                                .collect(Collectors.toList()));
                input.setSteps(request.steps());
                input.setTags(request.tags());
                input.setDifficulty(request.difficulty());
                input.setServingSize(request.servingSize());
                input.setCookTimeInMinutes(request.cookTimeInMinutes());
                return input;
        }

        private static IngredientInput toIngredientInput(IngredientRequest request) {
                IngredientInput input = new IngredientInput();
                input.setName(request.name());
                input.setMeasurement(request.measurement());
                return input;
        }
}
