package com.recette.allenchang.backend.controllers;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.services.*;
import com.recette.allenchang.backend.repositories.*;
import com.recette.allenchang.backend.dto.responses.*;
import com.recette.allenchang.backend.mappers.*;
import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.common.ServiceUtil;

import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/social")
public class SocialController {
    private final FriendshipQueryService friendshipQueryService;
    private final RecipeRepository recipeRepository;
    private final SavedRecipeService savedRecipeService;
    private final ServiceUtil serviceUtil;

    public SocialController(FriendshipQueryService friendshipQueryService,
                           RecipeRepository recipeRepository,
                           SavedRecipeService savedRecipeService,
                           ServiceUtil serviceUtil) {
        this.friendshipQueryService = friendshipQueryService;
        this.recipeRepository = recipeRepository;
        this.savedRecipeService = savedRecipeService;
        this.serviceUtil = serviceUtil;
    }

    /** GET: Friends' public recipes feed */
    @GetMapping("/feed")
    public List<RecipeResponse> getFriendsFeed() {
        String userEmail = JwtUtil.getLoggedInUserEmail();

        List<User> friends = friendshipQueryService.getFriends(userEmail);
        List<UUID> friendIds = friends.stream().map(User::getId).toList();

        if (friendIds.isEmpty()) {
            return List.of();
        }

        List<Recipe> recipes = recipeRepository.findPublicRecipesByUserIds(friendIds);

        return recipes.stream()
            .map(recipe -> {
                UserResponse owner = UserMapper.toResponse(recipe.getUser());
                Boolean isSaved = savedRecipeService.isRecipeSaved(userEmail, recipe.getId());
                return RecipeMapper.toResponse(recipe, owner, isSaved);
            })
            .toList();
    }

    /** GET: View a public recipe by ID (for shareable links) */
    @GetMapping("/recipe/{id}")
    public RecipeResponse getPublicRecipe(@PathVariable String id) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        Recipe recipe = serviceUtil.findRecipeById(UUID.fromString(id));

        // Allow viewing if: recipe is public OR user is the owner
        if (!recipe.getIsPublic() && !recipe.getUser().getEmail().equalsIgnoreCase(userEmail)) {
            throw new RuntimeException("Recipe not accessible");
        }

        UserResponse owner = UserMapper.toResponse(recipe.getUser());
        Boolean isSaved = savedRecipeService.isRecipeSaved(userEmail, recipe.getId());
        return RecipeMapper.toResponse(recipe, owner, isSaved);
    }
}
