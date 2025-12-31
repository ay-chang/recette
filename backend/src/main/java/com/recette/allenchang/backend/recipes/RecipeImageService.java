package com.recette.allenchang.backend.recipes;

import java.util.UUID;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.Recipe;

@Service
public class RecipeImageService {
    private final RecipeRepository recipeRepository;

    public RecipeImageService(RecipeRepository recipeRepository) {
        this.recipeRepository = recipeRepository;
    }

    /**
     * Update the recipes image, triggered when users add an image to a recipe that
     * currently doesnt have an image or when changing the existing image.
     */
    public Recipe updateRecipeImage(UUID recipeId, String imageurl, String userEmail) {
        Recipe recipe = recipeRepository.findById(recipeId)
                .orElseThrow(() -> new IllegalArgumentException("Recipe not found with id: " + recipeId));

        if (!recipe.getUser().getEmail().equalsIgnoreCase(userEmail.toLowerCase())) {
            throw new RuntimeException("Unauthorized to update image for this recipe");
        }

        recipe.setImageurl(imageurl);
        return recipeRepository.save(recipe);
    }

}
