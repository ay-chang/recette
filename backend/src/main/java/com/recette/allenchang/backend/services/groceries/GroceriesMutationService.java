package com.recette.allenchang.backend.services.groceries;

import java.util.List;

import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;

import com.recette.allenchang.backend.models.Grocery;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.repositories.GroceryRepository;
import com.recette.allenchang.backend.repositories.RecipeRepository;
import com.recette.allenchang.backend.repositories.UserRepository;

@Service
public class GroceriesMutationService {
    private final GroceryRepository groceryRepository;
    private final UserRepository userRepository;
    private final RecipeRepository recipeRepository;

    public GroceriesMutationService(GroceryRepository groceryRepository, UserRepository userRepository,
            RecipeRepository recipeRepository) {
        this.groceryRepository = groceryRepository;
        this.userRepository = userRepository;
        this.recipeRepository = recipeRepository;
    }

    public List<Grocery> addGroceries(List<Grocery> groceries, String email, String recipeId) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found with email: " + email));

        Recipe recipe;
        if (recipeId.isEmpty() || recipeId == null) {
            recipe = null;
        } else {
            recipe = recipeRepository.findById(Integer.parseInt(recipeId))
                    .orElseThrow(() -> new IllegalArgumentException("Recipe not found with id: " + recipeId));
        }

        for (Grocery grocery : groceries) {
            grocery.setUser(user);
            grocery.setRecipe(recipe);
        }

        return groceryRepository.saveAll(groceries);
    }

    @Transactional
    public Grocery toggleChecked(Integer id, boolean checked) {
        groceryRepository.updateChecked(id, checked);
        return groceryRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Grocery not found with id: " + id));
    }

    @Transactional
    public boolean removeRecipeFromGroceries(String email, String recipeId) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found with email: " + email));

        Recipe recipe = recipeRepository.findById(Integer.parseInt(recipeId))
                .orElseThrow(() -> new IllegalArgumentException("Recipe not found with id: " + recipeId));

        groceryRepository.deleteByUserAndRecipe(user, recipe);

        return true;
    }

}
