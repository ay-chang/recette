package com.recette.allenchang.backend.recipes;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.recette.allenchang.backend.inputs.RecipeFilterInput;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.recipes.dto.requests.FilterRecipeRequest;
import com.recette.allenchang.backend.recipes.dto.responses.RecipeResponse;
import com.recette.allenchang.backend.recipes.mappers.RecipeFilterMapper;
import com.recette.allenchang.backend.recipes.mappers.RecipeMapper;
import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.services.S3Service;

@RestController
@RequestMapping("/api/recipes")
public class RecipeController {

    private final RecipeQueryService recipeQueryService;
    private final S3Service S3Service;

    public RecipeController(S3Service S3Service, RecipeQueryService recipeQueryService) {
        this.S3Service = S3Service;
        this.recipeQueryService = recipeQueryService;
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

        RecipeFilterInput input = RecipeFilterMapper.toInput(request);

        return recipeQueryService.getUserFilteredRecipes(email, input)
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

}
