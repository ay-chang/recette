package com.recette.allenchang.backend.services;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.repositories.*;
import com.recette.allenchang.backend.common.ServiceUtil;

import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class SavedRecipeService {
    private final SavedRecipeRepository savedRecipeRepository;
    private final ServiceUtil serviceUtil;

    public SavedRecipeService(SavedRecipeRepository savedRecipeRepository, ServiceUtil serviceUtil) {
        this.savedRecipeRepository = savedRecipeRepository;
        this.serviceUtil = serviceUtil;
    }

    /** Save/bookmark a recipe */
    public SavedRecipe saveRecipe(String userEmail, UUID recipeId) {
        User user = serviceUtil.findUserByEmail(userEmail);
        Recipe recipe = serviceUtil.findRecipeById(recipeId);

        // Prevent saving own recipes
        if (recipe.getUser().getId().equals(user.getId())) {
            throw new IllegalArgumentException("Cannot save your own recipe");
        }

        // Check if already saved
        if (savedRecipeRepository.existsByUserIdAndRecipeId(user.getId(), recipeId)) {
            throw new IllegalArgumentException("Recipe already saved");
        }

        SavedRecipe savedRecipe = new SavedRecipe(user, recipe);
        return savedRecipeRepository.save(savedRecipe);
    }

    /** Unsave/unbookmark a recipe */
    @Transactional
    public void unsaveRecipe(String userEmail, UUID recipeId) {
        User user = serviceUtil.findUserByEmail(userEmail);
        savedRecipeRepository.deleteByUserIdAndRecipeId(user.getId(), recipeId);
    }

    /** Get all saved recipes for a user */
    public List<SavedRecipe> getSavedRecipes(String userEmail) {
        User user = serviceUtil.findUserByEmail(userEmail);
        return savedRecipeRepository.findByUserIdOrderByCreatedAtDesc(user.getId());
    }

    /** Check if a recipe is saved by the user */
    public boolean isRecipeSaved(String userEmail, UUID recipeId) {
        User user = serviceUtil.findUserByEmail(userEmail);
        return savedRecipeRepository.existsByUserIdAndRecipeId(user.getId(), recipeId);
    }
}
