package com.recette.allenchang.backend.repositories;

import com.recette.allenchang.backend.models.*;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.recette.allenchang.backend.models.Recipe;

public interface IngredientRepository extends JpaRepository<Ingredient, UUID> {
    List<Ingredient> findByRecipe(Recipe recipe);
    List<Ingredient> findByRecipeId(UUID recipeId);
}
