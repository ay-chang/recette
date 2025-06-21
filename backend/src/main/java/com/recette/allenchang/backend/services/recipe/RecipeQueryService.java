package com.recette.allenchang.backend.services.recipe;

import java.util.List;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.repositories.RecipeRepository;
import com.recette.allenchang.backend.repositories.UserRepository;

@Service
public class RecipeQueryService {
    private final RecipeRepository recipeRepository;
    private final UserRepository userRepository;

    public RecipeQueryService(RecipeRepository recipeRepository, UserRepository userRepository) {
        this.recipeRepository = recipeRepository;
        this.userRepository = userRepository;
    }

    /** Returns a list of all recipes */
    public List<Recipe> getAllRecipes() {
        return recipeRepository.findAll();
    }

    /** Returns all recipes for user with matching email */
    public List<Recipe> getRecipesByUserEmail(String email) {
        return userRepository.findByEmail(email)
                .map(user -> recipeRepository.findByUserId(user.getId()))
                .orElse(List.of());
    }

    /** Take a recipe id as an arg and returns a single Recipe */
    public Recipe getRecipeById(String id) {
        return recipeRepository.findById(Integer.parseInt(id)).orElse(null);
    }

}
