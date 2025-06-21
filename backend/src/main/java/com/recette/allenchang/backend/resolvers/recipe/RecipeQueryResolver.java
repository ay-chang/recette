package com.recette.allenchang.backend.resolvers.recipe;

import java.util.List;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.services.recipe.RecipeQueryService;

@Controller
public class RecipeQueryResolver {
    private final RecipeQueryService recipeService;

    public RecipeQueryResolver(RecipeQueryService recipeService) {
        this.recipeService = recipeService;
    }

    /** GET all recipes */
    @QueryMapping
    public List<Recipe> recipes() {
        return recipeService.getAllRecipes();
    }

    /** GET all recipes associated with a user */
    @QueryMapping
    public List<Recipe> userRecipes(@Argument String email) {
        return recipeService.getRecipesByUserEmail(email);
    }

    /** GET a recipe by its id */
    @QueryMapping
    public Recipe recipeById(@Argument String id) {
        return recipeService.getRecipeById(id);
    }

}
