package com.recette.allenchang.backend.resolvers.groceries;

import java.util.List;
import java.util.UUID;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.models.Grocery;
import com.recette.allenchang.backend.services.groceries.GroceriesMutationService;

@Controller
public class GroceriesMutationResolver {
    private final GroceriesMutationService groceriesMutationService;

    public GroceriesMutationResolver(GroceriesMutationService groceriesMutationService) {
        this.groceriesMutationService = groceriesMutationService;
    }

    /** POST: add grocery items */
    @MutationMapping
    public List<Grocery> addGroceries(@Argument List<Grocery> groceries, @Argument String email,
            @Argument String recipeId) {
        return groceriesMutationService.addGroceries(groceries, email, UUID.fromString(recipeId));
    }

    /** UPDATE: toggle checked for grocery item */
    @MutationMapping
    public Grocery toggleGroceryCheck(@Argument UUID id, @Argument boolean checked) {
        return groceriesMutationService.toggleChecked(id, checked);
    }

    /** DELETE: delete a recipe group from the grocery list */
    @MutationMapping
    public boolean removeRecipeFromGroceries(@Argument String email, @Argument String recipeId) {
        return groceriesMutationService.removeRecipeFromGroceries(email, UUID.fromString(recipeId));
    }

}
