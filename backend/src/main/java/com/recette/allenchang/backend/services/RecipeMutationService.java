package com.recette.allenchang.backend.services;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.repositories.*;
import com.recette.allenchang.backend.exceptions.*;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.dto.requests.CreateRecipeRequest;
import com.recette.allenchang.backend.dto.requests.UpdateRecipeRequest;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.common.ServiceUtil;

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
    public Recipe addRecipe(CreateRecipeRequest request, String userEmail) {
        Recipe recipe = new Recipe();
        User user = serviceUtil.findUserByEmail(userEmail);

        recipe.setUser(user);
        recipe.setTitle(request.title());
        recipe.setDescription(request.description());
        recipe.setImageurl(request.imageurl());

        /** If no steps are provided then return an emtpy list */
        List<String> steps = (request.steps() == null) ? new ArrayList<>() : new ArrayList<>(request.steps());
        recipe.setSteps(steps);

        /** Steps are required for now */
        recipe.setIngredients(new ArrayList<>(serviceUtil.mapIngredients(request.ingredients(), recipe)));

        recipe.setTags(new ArrayList<>(serviceUtil.mapTags(request.tags(), user)));
        recipe.setDifficulty(request.difficulty());
        recipe.setServingSize(request.servingSize());
        recipe.setCookTimeInMinutes(request.cookTimeInMinutes());

        return recipeRepository.save(recipe);
    }

    /** Update recipe details */
    public Recipe updateRecipe(UUID id, UpdateRecipeRequest request, String userEmail) {
        Recipe recipe = serviceUtil.findRecipeById(id);

        if (!recipe.getUser().getEmail().equalsIgnoreCase(userEmail)) {
            throw new RuntimeException("Unauthorized to update this recipe");
        }

        User user = serviceUtil.findUserByEmail(userEmail);

        recipe.setTitle(request.title());
        recipe.setDescription(request.description());
        recipe.setImageurl(request.imageurl());
        recipe.setSteps(new ArrayList<>(request.steps()));
        recipe.getIngredients().clear();
        recipe.getIngredients().addAll(serviceUtil.mapIngredients(request.ingredients(), recipe));
        recipe.setTags(new ArrayList<>(serviceUtil.mapTags(request.tags(), user)));
        recipe.setDifficulty(request.difficulty());
        recipe.setServingSize(request.servingSize());
        recipe.setCookTimeInMinutes(request.cookTimeInMinutes());

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
