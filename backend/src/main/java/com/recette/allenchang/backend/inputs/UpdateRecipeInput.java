package com.recette.allenchang.backend.inputs;

import java.util.List;

public class UpdateRecipeInput {
    private String id;
    private String title;
    private String description;
    private String imageUrl;
    private List<IngredientInput> ingredients;
    private List<String> tags;
    private List<String> steps;
    private String difficulty;
    private Integer cookTimeInMinutes;
    private Integer servingSize;

    /** Getters and Setters */
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageurl() {
        return imageUrl;
    }

    public void setImageurl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public List<IngredientInput> getIngredients() {
        return ingredients;
    }

    public void setIngredients(List<IngredientInput> ingredients) {
        this.ingredients = ingredients;
    }

    public List<String> getTags() {
        return tags;
    }

    public void setTags(List<String> tags) {
        this.tags = tags;
    }

    public List<String> getSteps() {
        return steps;
    }

    public void setSteps(List<String> steps) {
        this.steps = steps;
    }

    public String getDifficulty() {
        return this.difficulty;
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public Integer getCookTimeInMinutes() {
        return this.cookTimeInMinutes;
    }

    public void setCookTimeInMinutes(Integer cookTimeInMinutes) {
        this.cookTimeInMinutes = cookTimeInMinutes;
    }

    public Integer getServingSize() {
        return this.servingSize;
    }

    public void setServingSize(Integer servingSize) {
        this.servingSize = servingSize;
    }
}
