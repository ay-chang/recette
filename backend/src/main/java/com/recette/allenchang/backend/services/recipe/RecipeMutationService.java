package com.recette.allenchang.backend.services.recipe;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.inputs.IngredientInput;
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
    public Recipe addRecipe(RecipeInput input, String userEmail) {
        Recipe recipe = new Recipe();
        User user = findUserByEmail(userEmail);

        recipe.setUser(user);
        recipe.setTitle(input.getTitle());
        recipe.setDescription(input.getDescription());
        recipe.setImageurl(input.getImageurl());
        recipe.setSteps(new ArrayList<>(input.getSteps()));
        recipe.setIngredients(new ArrayList<>(mapIngredients(input.getIngredients(), recipe)));
        recipe.setTags(new ArrayList<>(mapTags(input.getTags(), user))); // <-- fix here
        recipe.setDifficulty(input.getDifficulty());
        recipe.setServingSize(input.getServingSize());
        recipe.setCookTimeInMinutes(input.getCookTimeInMinutes());

        return recipeRepository.save(recipe);

    }

    /** Update recipe details */
    public Recipe updateRecipe(UpdateRecipeInput input, String userEmail) {
        Recipe recipe = findRecipeById(input.getId());

        if (!recipe.getUser().getEmail().equalsIgnoreCase(userEmail)) {
            throw new RuntimeException("Unauthorized to update this recipe");
        }

        User user = findUserByEmail(userEmail);

        recipe.setTitle(input.getTitle());
        recipe.setDescription(input.getDescription());
        recipe.setImageurl(input.getImageurl());
        recipe.setSteps(new ArrayList<>(input.getSteps()));
        recipe.getIngredients().clear();
        recipe.getIngredients().addAll(mapIngredients(input.getIngredients(), recipe));
        recipe.setTags(new ArrayList<>(mapTags(input.getTags(), user))); // 🔧 Use user-scoped tags
        recipe.setDifficulty(input.getDifficulty());
        recipe.setServingSize(input.getServingSize());
        recipe.setCookTimeInMinutes(input.getCookTimeInMinutes());

        return recipeRepository.save(recipe);
    }

    /** Delete a recipe given its id */
    @Transactional
    public boolean deleteRecipe(UUID id, String userEmail) {
        Recipe recipe = findRecipeById(id);

        if (!recipe.getUser().getEmail().equalsIgnoreCase(userEmail)) {
            throw new RuntimeException("Unauthorized to delete this recipe");
        }

        recipe.getTags().clear();
        recipeRepository.delete(recipe);
        return true;
    }

    /** -------------------- Private helper functions -------------------- */

    /** Setting the user in a mutation function */
    private User findUserByEmail(String email) {
        return userRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("User not found with email: " + email));
    }

    /** Setting the recipe in a mutation function */
    private Recipe findRecipeById(UUID id) {
        return recipeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Recipe not found with id: " + id));
    }

    /** Creating and mapping ingredients */
    private List<Ingredient> mapIngredients(List<IngredientInput> inputs, Recipe recipe) {
        if (inputs == null || inputs.isEmpty()) {
            throw new IllegalArgumentException("Ingredients cannot be null or empty");
        }
        return inputs.stream()
                .map(i -> new Ingredient(i.getName(), i.getMeasurement(), recipe))
                .toList();
    }

    /** Creating and mapping tags */
    private List<Tag> mapTags(List<String> tagNames, User user) {
        if (tagNames == null || tagNames.isEmpty()) {
            return List.of();
        }

        return tagNames.stream()
                .map(name -> tagRepository.findByUserAndName(user, name)
                        .orElseThrow(() -> new IllegalArgumentException("Tag not found for user: " + name)))
                .toList();
    }

}
