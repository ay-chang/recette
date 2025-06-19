package com.recette.allenchang.backend.controllers;

/**
 * This controller exposes the recipe graphql queries
 */

import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.inputs.RecipeInput;
import com.recette.allenchang.backend.inputs.UpdateRecipeInput;
import com.recette.allenchang.backend.services.RecipeService;
import com.recette.allenchang.backend.services.S3Service;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import java.util.List;

import java.io.IOException;
import org.springframework.http.HttpStatus;

/**
 * This controller combines GraphQL queries for recipe data and a REST API
 * endpoint for image uploads.
 */
@RestController
public class RecipeController {

    private final RecipeService recipeService;
    private final S3Service S3Service;

    public RecipeController(RecipeService recipeService, S3Service S3Service) {
        this.recipeService = recipeService;
        this.S3Service = S3Service;
    }

    /** GET all recipes */
    @QueryMapping
    public List<Recipe> recipes() {
        return recipeService.getAllRecipes();
    }

    /** GET all recipes associated with a user */
    @QueryMapping
    public List<Recipe> userRecipes(@Argument String email) {
        return recipeService.getRecipesByUserEmail(email);
    }

    /** GET a recipe by its id */
    @QueryMapping
    public Recipe recipeById(@Argument String id) {
        return recipeService.getRecipeById(id);
    }

    /** DELETE: a recipe by its id */
    @MutationMapping
    public boolean deleteRecipe(@Argument String id) {
        return recipeService.deleteRecipe(id);
    }

    /** POST: a recipe to database */
    @MutationMapping
    public Recipe addRecipe(@Argument RecipeInput input) {
        return recipeService.addRecipe(input);
    }

    /** UPDATE: a recipes image */
    @MutationMapping
    public Recipe updateRecipeImage(@Argument String recipeId, @Argument String imageurl) {
        return recipeService.updateRecipeImage(recipeId, imageurl);
    }

    /** UPDATE: recipe details */
    @MutationMapping
    public Recipe updateRecipe(@Argument UpdateRecipeInput input) {
        return recipeService.updateRecipe(input);
    }

    /** REST endpoint to handle uploading photo to amazon S3 */
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

    /** REST endpoint to handle delting photo from amazon S3 */
    @DeleteMapping("delete-image")
    public ResponseEntity<String> deleteFile(@RequestParam("url") String fileUrl) {
        System.out.println("Deleting Image: " + fileUrl + "\n\n");

        try {
            S3Service.deleteImage(fileUrl);
            return ResponseEntity.ok("Deleted image: " + fileUrl);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to delete image: " + e.getMessage());
        }
    }

}
