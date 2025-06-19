package com.recette.allenchang.backend.controllers;

import java.util.List;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.models.Grocery;
import com.recette.allenchang.backend.services.GroceryService;

@Controller
public class GroceriesController {
    private final GroceryService groceryService;

    public GroceriesController(GroceryService groceryService) {
        this.groceryService = groceryService;
    }

    /** GET: get grocery items for user */
    @QueryMapping
    public List<Grocery> getUserGroceries(@Argument String email) {
        return groceryService.getUserGroceries(email);
    }

    /** POST: add grocery items */
    @MutationMapping
    public List<Grocery> addGroceries(@Argument List<Grocery> groceries, @Argument String email,
            @Argument String recipeId) {
        return groceryService.addGroceries(groceries, email, recipeId);
    }

    /** UPDATE: toggle checked for grocery item */
    @MutationMapping
    public Grocery toggleGroceryCheck(@Argument int id, @Argument boolean checked) {
        return groceryService.toggleChecked(id, checked);
    }

    /** DELETE: delete a recipe group from the grocery list */
    @MutationMapping
    public boolean removeRecipeFromGroceries(@Argument String email, @Argument String recipeId) {
        return groceryService.removeRecipeFromGroceries(email, recipeId);
    }

}
