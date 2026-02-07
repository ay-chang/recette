package com.recette.allenchang.backend.controllers;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.services.*;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.recette.allenchang.backend.dto.requests.CreateRecipeRequest;
import com.recette.allenchang.backend.dto.requests.FilterRecipeRequest;
import com.recette.allenchang.backend.dto.requests.UpdateRecipeRequest;
import com.recette.allenchang.backend.dto.responses.RecipeResponse;
import com.recette.allenchang.backend.mappers.RecipeMapper;
import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.common.S3Service;

@RestController
@RequestMapping("/api/recipes")
public class RecipeController {

    private final RecipeQueryService recipeQueryService;
    private final RecipeMutationService recipeMutationService;
    private final RecipeImageService recipeImageService;
    private final S3Service S3Service;

    public RecipeController(S3Service S3Service, RecipeQueryService recipeQueryService,
            RecipeMutationService recipeMutationService, RecipeImageService recipeImageService) {
        this.S3Service = S3Service;
        this.recipeQueryService = recipeQueryService;
        this.recipeMutationService = recipeMutationService;
        this.recipeImageService = recipeImageService;
    }

    /** GET recipe by recipe id */
    @GetMapping("/{id}")
    public RecipeResponse getRecipeById(@PathVariable String id) {
        Recipe recipe = recipeQueryService.getRecipeById(UUID.fromString(id));
        return RecipeMapper.toResponse(recipe);
    }

    /** GET all recipes for logged in user */
    @GetMapping("/mine")
    public List<RecipeResponse> mine() {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        return recipeQueryService.mine(userEmail)
                .stream()
                .map(RecipeMapper::toResponse)
                .toList();
    }

    /** Filter recipes for logged in user */
    @GetMapping("/mine/filter")
    public List<RecipeResponse> filterMine(
            @RequestParam(name = "tag", required = false) List<String> tags,
            @RequestParam(name = "difficulty", required = false) List<String> difficulties,
            @RequestParam(name = "maxCookTimeInMinutes", required = false) Integer maxCookTimeInMinutes) {
        String email = JwtUtil.getLoggedInUserEmail();

        FilterRecipeRequest request = new FilterRecipeRequest(tags, difficulties, maxCookTimeInMinutes);

        return recipeQueryService.getUserFilteredRecipes(email, request)
                .stream()
                .map(RecipeMapper::toResponse)
                .toList();
    }

    /** endpoint to handle uploading photo to amazon S3 */
    @PostMapping("upload")
    public ResponseEntity<String> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            String publicUrl = S3Service.optimizeAndUploadImage(file);
            return ResponseEntity.ok(publicUrl);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to upload image: " + e.getMessage());
        }
    }

    /** endpoint to handle delting photo from amazon S3 */
    @DeleteMapping("delete-image")
    public ResponseEntity<String> deleteFile(@RequestParam("url") String fileUrl) {
        try {
            S3Service.deleteImage(fileUrl);
            return ResponseEntity.ok("Deleted image: " + fileUrl);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to delete image: " + e.getMessage());
        }
    }

    /** POST: Create a new recipe */
    @PostMapping
    public RecipeResponse createRecipe(@RequestBody CreateRecipeRequest request) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        Recipe recipe = recipeMutationService.addRecipe(request, userEmail);
        return RecipeMapper.toResponse(recipe);
    }

    /** PUT: Update an existing recipe */
    @PutMapping("/{id}")
    public RecipeResponse updateRecipe(@PathVariable String id, @RequestBody UpdateRecipeRequest request) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        Recipe recipe = recipeMutationService.updateRecipe(UUID.fromString(id), request, userEmail);
        return RecipeMapper.toResponse(recipe);
    }

    /** DELETE: Delete a recipe by id */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteRecipe(@PathVariable String id) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        recipeMutationService.deleteRecipe(UUID.fromString(id), userEmail);
        return ResponseEntity.noContent().build();
    }

    /** PATCH: Toggle recipe visibility */
    @PatchMapping("/{id}/visibility")
    public RecipeResponse toggleVisibility(@PathVariable String id, @RequestParam("isPublic") boolean isPublic) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        Recipe recipe = recipeMutationService.toggleVisibility(UUID.fromString(id), isPublic, userEmail);
        return RecipeMapper.toResponse(recipe);
    }

    /** PATCH: Update a recipe's image */
    @PatchMapping("/{id}/image")
    public RecipeResponse updateRecipeImage(@PathVariable String id, @RequestParam("imageUrl") String imageUrl) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        Recipe recipe = recipeImageService.updateRecipeImage(UUID.fromString(id), imageUrl, userEmail);
        return RecipeMapper.toResponse(recipe);
    }

}
