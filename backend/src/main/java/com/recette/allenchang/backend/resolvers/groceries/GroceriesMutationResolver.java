package com.recette.allenchang.backend.resolvers.groceries;

import java.util.List;
import java.util.UUID;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.models.Grocery;
import com.recette.allenchang.backend.services.groceries.GroceriesMutationService;
import com.recette.allenchang.backend.security.JwtUtil;

@Controller
public class GroceriesMutationResolver {
    private final GroceriesMutationService groceriesMutationService;

    public GroceriesMutationResolver(GroceriesMutationService groceriesMutationService) {
        this.groceriesMutationService = groceriesMutationService;
    }

    /** POST: add grocery items */
    @MutationMapping
    public List<Grocery> addGroceries(@Argument List<Grocery> groceries, @Argument String recipeId) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        return groceriesMutationService.addGroceries(groceries, userEmail, UUID.fromString(recipeId));
    }

    /** UPDATE: toggle checked for grocery item */
    @MutationMapping
    public Grocery toggleGroceryCheck(@Argument UUID id, @Argument boolean checked) {
        return groceriesMutationService.toggleChecked(id, checked);
    }

    /** DELETE: delete a recipe group from the grocery list */
    @MutationMapping
    public boolean removeRecipeFromGroceries(@Argument String recipeId) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        return groceriesMutationService.removeRecipeFromGroceries(userEmail, UUID.fromString(recipeId));
    }

}
