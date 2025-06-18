package com.recette.allenchang.backend.inputs;

import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.models.User;

public class GroceryInput {
    private String name;
    private String measurement;
    private Recipe recipe;
    private User user;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMeasurement() {
        return measurement;
    }

    public void setMeasurement(String measurement) {
        this.measurement = measurement;
    }

    public Recipe getRecipe() {
        return recipe;
    }

    public void setRecipe(Recipe recipe) {
        this.recipe = recipe;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

}
