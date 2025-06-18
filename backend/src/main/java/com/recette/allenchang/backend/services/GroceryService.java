package com.recette.allenchang.backend.services;

import java.util.List;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.Grocery;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.repositories.GroceryRepository;
import com.recette.allenchang.backend.repositories.RecipeRepository;
import com.recette.allenchang.backend.repositories.UserRepository;

@Service
public class GroceryService {
    private final GroceryRepository groceryRepository;
    private final UserRepository userRepository;
    private final RecipeRepository recipeRepository;

    public GroceryService(GroceryRepository groceryRepository, UserRepository userRepository,
            RecipeRepository recipeRepository) {
        this.groceryRepository = groceryRepository;
        this.userRepository = userRepository;
        this.recipeRepository = recipeRepository;
    }

    public List<Grocery> getUserGroceries(String email) {
        return userRepository.findByEmail(email)
                .map(user -> groceryRepository.findByUserId(user.getId()))
                .orElse(List.of());
    }

    public List<Grocery> addGroceries(List<Grocery> groceries, String email, String recipeid) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found with email: " + email));

        Recipe recipe;
        if (recipeid.isEmpty() || recipeid == null) {
            recipe = null;
        } else {
            recipe = recipeRepository.findById(Integer.parseInt(recipeid))
                    .orElseThrow(() -> new IllegalArgumentException("Recipe not found with id: " + recipeid));
        }

        for (Grocery grocery : groceries) {
            grocery.setUser(user);
            grocery.setRecipe(recipe);
        }

        return groceryRepository.saveAll(groceries);
    }

}
