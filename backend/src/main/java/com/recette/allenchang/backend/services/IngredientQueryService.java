package com.recette.allenchang.backend.services;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.repositories.*;
import com.recette.allenchang.backend.exceptions.*;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.Ingredient;

@Service
public class IngredientQueryService {
    private final IngredientRepository ingredientRepository;

    public IngredientQueryService(IngredientRepository ingredientRepository) {
        this.ingredientRepository = ingredientRepository;
    }

    public Ingredient getIngredientById(UUID id) {
        return ingredientRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Ingredient not found with id: " + id));
    }

    public List<Ingredient> getIngredientsByRecipeId(UUID recipeId) {
        return ingredientRepository.findByRecipeId(recipeId);
    }
}
