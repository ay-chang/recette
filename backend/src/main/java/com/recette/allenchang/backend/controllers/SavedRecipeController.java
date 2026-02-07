package com.recette.allenchang.backend.controllers;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.services.*;
import com.recette.allenchang.backend.dto.responses.*;
import com.recette.allenchang.backend.mappers.*;
import com.recette.allenchang.backend.security.JwtUtil;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/saved-recipes")
public class SavedRecipeController {
    private final SavedRecipeService savedRecipeService;

    public SavedRecipeController(SavedRecipeService savedRecipeService) {
        this.savedRecipeService = savedRecipeService;
    }

    /** GET: Get all saved recipes for current user */
    @GetMapping
    public List<RecipeResponse> getSavedRecipes() {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        List<SavedRecipe> savedRecipes = savedRecipeService.getSavedRecipes(userEmail);

        return savedRecipes.stream()
            .map(sr -> {
                Recipe recipe = sr.getRecipe();
                UserResponse owner = UserMapper.toResponse(recipe.getUser());
                return RecipeMapper.toResponse(recipe, owner, true);
            })
            .toList();
    }

    /** POST: Save/bookmark a recipe */
    @PostMapping("/{recipeId}")
    public ResponseEntity<String> saveRecipe(@PathVariable String recipeId) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        savedRecipeService.saveRecipe(userEmail, UUID.fromString(recipeId));
        return ResponseEntity.ok("Recipe saved");
    }

    /** DELETE: Unsave/unbookmark a recipe */
    @DeleteMapping("/{recipeId}")
    public ResponseEntity<Void> unsaveRecipe(@PathVariable String recipeId) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        savedRecipeService.unsaveRecipe(userEmail, UUID.fromString(recipeId));
        return ResponseEntity.noContent().build();
    }

    /** GET: Check if a recipe is saved */
    @GetMapping("/{recipeId}/status")
    public ResponseEntity<Boolean> checkSavedStatus(@PathVariable String recipeId) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        boolean isSaved = savedRecipeService.isRecipeSaved(userEmail, UUID.fromString(recipeId));
        return ResponseEntity.ok(isSaved);
    }
}
