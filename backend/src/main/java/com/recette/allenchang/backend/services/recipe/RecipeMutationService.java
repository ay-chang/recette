package com.recette.allenchang.backend.services.recipe;

import java.util.ArrayList;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.inputs.RecipeInput;
import com.recette.allenchang.backend.inputs.UpdateRecipeInput;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.RecipeRepository;
import com.recette.allenchang.backend.services.ServiceUtil;

import jakarta.transaction.Transactional;

@Service
public class RecipeMutationService {
    private final RecipeRepository recipeRepository;
    private final ServiceUtil serviceUtil;

    public RecipeMutationService(RecipeRepository recipeRepository, ServiceUtil serviceUtil) {
        this.recipeRepository = recipeRepository;
        this.serviceUtil = serviceUtil;
    }

    /** Add a recipe to the database */
    public Recipe addRecipe(RecipeInput input, String userEmail) {
        Recipe recipe = new Recipe();
        User user = serviceUtil.findUserByEmail(userEmail);

        recipe.setUser(user);
        recipe.setTitle(input.getTitle());
        recipe.setDescription(input.getDescription());
        recipe.setImageurl(input.getImageurl());
        recipe.setSteps(new ArrayList<>(input.getSteps()));
        recipe.setIngredients(new ArrayList<>(serviceUtil.mapIngredients(input.getIngredients(), recipe)));
        recipe.setTags(new ArrayList<>(serviceUtil.mapTags(input.getTags(), user)));
        recipe.setDifficulty(input.getDifficulty());
        recipe.setServingSize(input.getServingSize());
        recipe.setCookTimeInMinutes(input.getCookTimeInMinutes());

        return recipeRepository.save(recipe);

    }

    /** Update recipe details */
    public Recipe updateRecipe(UpdateRecipeInput input, String userEmail) {
        Recipe recipe = serviceUtil.findRecipeById(input.getId());

        if (!recipe.getUser().getEmail().equalsIgnoreCase(userEmail)) {
            throw new RuntimeException("Unauthorized to update this recipe");
        }

        User user = serviceUtil.findUserByEmail(userEmail);

        recipe.setTitle(input.getTitle());
        recipe.setDescription(input.getDescription());
        recipe.setImageurl(input.getImageurl());
        recipe.setSteps(new ArrayList<>(input.getSteps()));
        recipe.getIngredients().clear();
        recipe.getIngredients().addAll(serviceUtil.mapIngredients(input.getIngredients(), recipe));
        recipe.setTags(new ArrayList<>(serviceUtil.mapTags(input.getTags(), user)));
        recipe.setDifficulty(input.getDifficulty());
        recipe.setServingSize(input.getServingSize());
        recipe.setCookTimeInMinutes(input.getCookTimeInMinutes());

        return recipeRepository.save(recipe);
    }

    /** Delete a recipe given its id */
    @Transactional
    public boolean deleteRecipe(UUID id, String userEmail) {
        Recipe recipe = serviceUtil.findRecipeById(id);

        if (!recipe.getUser().getEmail().equalsIgnoreCase(userEmail)) {
            throw new RuntimeException("Unauthorized to delete this recipe");
        }

        recipe.getTags().clear();
        recipeRepository.delete(recipe);
        return true;
    }
}
