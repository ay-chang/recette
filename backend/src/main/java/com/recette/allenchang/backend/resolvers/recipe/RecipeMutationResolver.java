package com.recette.allenchang.backend.resolvers.recipe;

import java.util.UUID;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.inputs.RecipeInput;
import com.recette.allenchang.backend.inputs.UpdateRecipeInput;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.services.recipe.RecipeImageService;
import com.recette.allenchang.backend.services.recipe.RecipeMutationService;

@Controller
public class RecipeMutationResolver {
    private final RecipeMutationService recipeMutationService;
    private final RecipeImageService recipeImageService;

    public RecipeMutationResolver(RecipeMutationService recipeMutationService, RecipeImageService recipeImageService) {
        this.recipeMutationService = recipeMutationService;
        this.recipeImageService = recipeImageService;
    }

    /** DELETE: a recipe by its id */
    @MutationMapping
    public boolean deleteRecipe(@Argument String id) {
        String userEmail = getLoggedInUser();
        return recipeMutationService.deleteRecipe(UUID.fromString(id), userEmail);
    }

    /** POST: a recipe to database */
    @MutationMapping
    public Recipe addRecipe(@Argument RecipeInput input) {
        String userEmail = getLoggedInUser();
        return recipeMutationService.addRecipe(input, userEmail);
    }

    /** UPDATE: a recipes image */
    @MutationMapping
    public Recipe updateRecipeImage(@Argument String recipeId, @Argument String imageurl) {
        String userEmail = getLoggedInUser();
        return recipeImageService.updateRecipeImage(UUID.fromString(recipeId), imageurl, userEmail);
    }

    /** UPDATE: recipe details */
    @MutationMapping
    public Recipe updateRecipe(@Argument UpdateRecipeInput input) {
        String userEmail = getLoggedInUser();
        return recipeMutationService.updateRecipe(input, userEmail);
    }

    /** Helper to extract logged-in user email */
    private String getLoggedInUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getPrincipal() == null) {
            throw new RuntimeException("Unauthorized");
        }
        return (String) auth.getPrincipal();
    }

}
