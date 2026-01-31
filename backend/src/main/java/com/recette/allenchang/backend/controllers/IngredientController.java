package com.recette.allenchang.backend.controllers;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.services.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.recette.allenchang.backend.dto.requests.UpdateIngredientRequest;
import com.recette.allenchang.backend.dto.responses.IngredientResponse;
import com.recette.allenchang.backend.mappers.IngredientMapper;

@RestController
@RequestMapping("/api/ingredients")
public class IngredientController {

    private final IngredientQueryService ingredientQueryService;
    private final IngredientMutationService ingredientMutationService;

    public IngredientController(IngredientQueryService ingredientQueryService,
                              IngredientMutationService ingredientMutationService) {
        this.ingredientQueryService = ingredientQueryService;
        this.ingredientMutationService = ingredientMutationService;
    }

    @GetMapping("/{id}")
    public IngredientResponse getIngredient(@PathVariable String id) {
        Ingredient ingredient = ingredientQueryService.getIngredientById(UUID.fromString(id));
        return IngredientMapper.toResponse(ingredient);
    }

    @GetMapping("/recipe/{recipeId}")
    public List<IngredientResponse> getIngredientsByRecipe(@PathVariable String recipeId) {
        List<Ingredient> ingredients = ingredientQueryService.getIngredientsByRecipeId(UUID.fromString(recipeId));
        return ingredients.stream()
                .map(IngredientMapper::toResponse)
                .collect(Collectors.toList());
    }

    @PutMapping("/{id}")
    public IngredientResponse updateIngredient(@PathVariable String id,
                                               @RequestBody UpdateIngredientRequest request) {
        Ingredient ingredient = ingredientMutationService.updateIngredient(
                UUID.fromString(id),
                request.name(),
                request.measurement()
        );
        return IngredientMapper.toResponse(ingredient);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteIngredient(@PathVariable String id) {
        ingredientMutationService.deleteIngredient(UUID.fromString(id));
        return ResponseEntity.noContent().build();
    }
}
