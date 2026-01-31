package com.recette.allenchang.backend.dto.requests;

import java.util.List;

public record AddGroceriesRequest(
    List<GroceryInput> groceries,
    String recipeId
) {}
