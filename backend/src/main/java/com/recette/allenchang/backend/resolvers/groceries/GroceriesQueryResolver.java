package com.recette.allenchang.backend.resolvers.groceries;

import java.util.List;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.models.Grocery;
import com.recette.allenchang.backend.services.groceries.GroceriesQueryService;

@Controller
public class GroceriesQueryResolver {
    private final GroceriesQueryService groceriesQueryService;

    public GroceriesQueryResolver(GroceriesQueryService groceriesQueryService) {
        this.groceriesQueryService = groceriesQueryService;
    }

    /** GET: get grocery items for user */
    @QueryMapping
    public List<Grocery> getUserGroceries(@Argument String email) {
        return groceriesQueryService.getUserGroceries(email);
    }

}
