package com.recette.allenchang.backend.controllers;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.services.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.dto.requests.AddGroceriesRequest;
import com.recette.allenchang.backend.dto.responses.GroceryResponse;
import com.recette.allenchang.backend.mappers.GroceryMapper;

@RestController
@RequestMapping("/api/groceries")
public class GroceryController {

    private final GroceryQueryService groceryQueryService;
    private final GroceryMutationService groceryMutationService;

    public GroceryController(GroceryQueryService groceryQueryService,
                           GroceryMutationService groceryMutationService) {
        this.groceryQueryService = groceryQueryService;
        this.groceryMutationService = groceryMutationService;
    }

    @GetMapping("/mine")
    public List<GroceryResponse> getMyGroceries() {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        List<Grocery> groceries = groceryQueryService.getUserGroceries(userEmail);
        return groceries.stream()
                .map(GroceryMapper::toResponse)
                .collect(Collectors.toList());
    }

    @PostMapping
    public List<GroceryResponse> addGroceries(@RequestBody AddGroceriesRequest request) {
        String userEmail = JwtUtil.getLoggedInUserEmail();

        // Convert GroceryInput DTOs to Grocery entities
        List<Grocery> groceries = request.groceries().stream()
                .map(input -> {
                    Grocery g = new Grocery();
                    g.setName(input.name());
                    g.setMeasurement(input.measurement());
                    return g;
                })
                .collect(Collectors.toList());

        UUID recipeId = request.recipeId() != null ? UUID.fromString(request.recipeId()) : null;
        List<Grocery> savedGroceries = groceryMutationService.addGroceries(groceries, userEmail, recipeId);

        return savedGroceries.stream()
                .map(GroceryMapper::toResponse)
                .collect(Collectors.toList());
    }

    @PatchMapping("/{id}/toggle")
    public GroceryResponse toggleGroceryCheck(@PathVariable String id, @RequestParam boolean checked) {
        Grocery grocery = groceryMutationService.toggleChecked(UUID.fromString(id), checked);
        return GroceryMapper.toResponse(grocery);
    }

    @DeleteMapping("/recipe/{recipeId}")
    public ResponseEntity<Void> removeRecipeFromGroceries(@PathVariable String recipeId) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        groceryMutationService.removeRecipeFromGroceries(userEmail, UUID.fromString(recipeId));
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping
    public ResponseEntity<Void> removeAllGroceries() {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        groceryMutationService.removeAllGroceries(userEmail);
        return ResponseEntity.noContent().build();
    }
}
