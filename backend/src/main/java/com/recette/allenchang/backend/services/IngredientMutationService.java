package com.recette.allenchang.backend.services;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.repositories.*;
import com.recette.allenchang.backend.exceptions.*;

import java.util.UUID;

import org.springframework.stereotype.Service;

@Service
public class IngredientMutationService {
    private final IngredientRepository ingredientRepository;

    public IngredientMutationService(IngredientRepository ingredientRepository) {
        this.ingredientRepository = ingredientRepository;
    }

    public Ingredient updateIngredient(UUID id, String name, String measurement) {
        Ingredient ingredient = ingredientRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Ingredient not found with id: " + id));

        ingredient.setName(name);
        ingredient.setMeasurement(measurement);

        return ingredientRepository.save(ingredient);
    }

    public void deleteIngredient(UUID id) {
        if (!ingredientRepository.existsById(id)) {
            throw new IllegalArgumentException("Ingredient not found with id: " + id);
        }
        ingredientRepository.deleteById(id);
    }
}
