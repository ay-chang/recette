package com.recette.allenchang.backend.services.recipe;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.inputs.RecipeInput;
import com.recette.allenchang.backend.inputs.UpdateRecipeInput;
import com.recette.allenchang.backend.models.Ingredient;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.models.Tag;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.RecipeRepository;
import com.recette.allenchang.backend.repositories.TagRepository;
import com.recette.allenchang.backend.repositories.UserRepository;

import jakarta.transaction.Transactional;

@Service
public class RecipeMutationService {
    private final RecipeRepository recipeRepository;
    private final TagRepository tagRepository;
    private final UserRepository userRepository;

    public RecipeMutationService(RecipeRepository recipeRepository, TagRepository tagRepository,
            UserRepository userRepository) {
        this.recipeRepository = recipeRepository;
        this.tagRepository = tagRepository;
        this.userRepository = userRepository;
    }

    /** Add a recipe to the database */
    public Recipe addRecipe(RecipeInput input) {
        Recipe recipe = new Recipe();
        recipe.setTitle(input.getTitle());
        recipe.setDescription(input.getDescription());
        recipe.setImageurl(input.getImageurl());
        recipe.setSteps(input.getSteps());

        /*
         * We cant just use the "user" that the frontend sends us through the input. We
         * have to match it by using the "user" we get from the frontend input. This is
         * because the UserInput object is not managed by Hibernate — it doesn't have an
         * ID and is not attached to our database session.
         */
        User user = userRepository.findByEmail(input.getUser().getEmail())
                .orElseThrow(
                        () -> new IllegalArgumentException("User not found with email: " + input.getUser().getEmail()));
        recipe.setUser(user);

        /** Validate and handle the ingredients */
        if (input.getIngredients() == null || input.getIngredients().isEmpty()) {
            throw new IllegalArgumentException("Ingredients cannot be null or empty");
        }

        /** Handle ingredients AFTER recipe has its user set */
        List<Ingredient> ingredientEntities = input.getIngredients().stream()
                .map(ingredientInput -> new Ingredient(
                        ingredientInput.getName(),
                        ingredientInput.getMeasurement(),
                        recipe))
                .toList();
        recipe.setIngredients(ingredientEntities);

        /** Handle tags */
        if (input.getTags() != null && !input.getTags().isEmpty()) {
            List<Tag> tagEntities = input.getTags().stream()
                    .map(tagName -> tagRepository.findByName(tagName)
                            .orElseThrow(() -> new IllegalArgumentException("Tag not found: " + tagName)))
                    .toList();
            recipe.setTags(tagEntities);
        } else {
            recipe.setTags(List.of());
        }

        return recipeRepository.save(recipe);
    }

    /** Update recipe details */
    public Recipe updateRecipe(UpdateRecipeInput input) {
        Recipe recipe = recipeRepository.findById(Integer.parseInt(input.getId()))
                .orElseThrow(() -> new IllegalArgumentException("Recipe not found with id: " + input.getId()));

        /** Update basic fields */
        recipe.setTitle(input.getTitle());
        recipe.setDescription(input.getDescription());
        recipe.setImageurl(input.getImageurl());
        recipe.setSteps(new ArrayList<>(input.getSteps())); // Ensure mutable list

        // --- Ingredients ---
        if (input.getIngredients() == null || input.getIngredients().isEmpty()) {
            throw new IllegalArgumentException("Ingredients cannot be null or empty");
        }

        // Build new ingredients
        List<Ingredient> updatedIngredients = input.getIngredients().stream()
                .map(ingredientInput -> new Ingredient(
                        ingredientInput.getName(),
                        ingredientInput.getMeasurement(),
                        recipe))
                .collect(Collectors.toList());

        // Replace ingredients safely (in-place)
        recipe.getIngredients().clear(); // ✅ Hibernate can track this
        recipe.getIngredients().addAll(updatedIngredients);

        // --- Tags ---
        if (input.getTags() != null && !input.getTags().isEmpty()) {
            List<Tag> tagEntities = input.getTags().stream()
                    .map(tagName -> tagRepository.findByName(tagName)
                            .orElseThrow(() -> new IllegalArgumentException("Tag not found: " + tagName)))
                    .collect(Collectors.toList());
            recipe.setTags(new ArrayList<>(tagEntities)); // Use a mutable list
        } else {
            recipe.setTags(new ArrayList<>()); // ✅ safe empty list
        }

        return recipeRepository.save(recipe);
    }

    /** Delete a recipe given its id */
    @Transactional
    public boolean deleteRecipe(String id) {
        Optional<Recipe> recipeOptional = recipeRepository.findById(Integer.parseInt(id));

        /**
         * If the recipe exists in the database, delete the recipe. In addition
         * to removing the recipe from the database, we also clear the tags from
         * the join table. However, we dont have to worry about manually clearing the
         * ingredients and steps as those properties were cascaded (defined in their
         * models) and are handled automatically,
         */
        if (recipeOptional.isPresent()) {
            Recipe recipe = recipeOptional.get();
            recipe.getTags().clear();
            recipeRepository.delete(recipe);
            return true;
        }
        return false;
    }

}
