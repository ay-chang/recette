package com.recette.allenchang.backend.resolvers.recipe;

import java.util.List;
import java.util.UUID;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.inputs.RecipeFilterInput;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.services.recipe.RecipeQueryService;

@Controller
public class RecipeQueryResolver {
    private final RecipeQueryService recipeQueryervice;

    public RecipeQueryResolver(RecipeQueryService recipeQueryervice) {
        this.recipeQueryervice = recipeQueryervice;
    }

    /** GET all recipes */
    @QueryMapping
    public List<Recipe> recipes() {
        return recipeQueryervice.getAllRecipes();
    }

    /** GET all recipes associated with a user */
    @QueryMapping
    public List<Recipe> userRecipes(@Argument String email) {
        return recipeQueryervice.getRecipesByUserEmail(email);
    }

    /** GET a recipe by its id */
    @QueryMapping
    public Recipe recipeById(@Argument String id) {
        return recipeQueryervice.getRecipeById(UUID.fromString(id));
    }

    /** GET a list of user created recipes based off a filter */
    @QueryMapping
    public List<Recipe> filterUserRecipes(@Argument String email, @Argument RecipeFilterInput recipeFilterInput) {
        return recipeQueryervice.getUserFilteredRecipes(email, recipeFilterInput);
    }

}
