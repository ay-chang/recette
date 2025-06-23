package com.recette.allenchang.backend.inputs;

import java.util.List;

public class RecipeFilterInput {
    private List<String> tags;
    private String difficulty;
    private Integer cookTimeInMinutes;

    public List<String> getTags() {
        return this.tags;
    }

    public void setTags(List<String> tags) {
        this.tags = tags;
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

}
