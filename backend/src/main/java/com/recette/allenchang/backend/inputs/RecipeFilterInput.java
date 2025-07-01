package com.recette.allenchang.backend.inputs;

import java.util.List;

public class RecipeFilterInput {
    private List<String> tags;
    private List<String> difficulties;
    private Integer maxCookTimeInMinutes;

    public List<String> getTags() {
        return this.tags;
    }

    public void setTags(List<String> tags) {
        this.tags = tags;
    }

    public List<String> getDifficulties() {
        return this.difficulties;
    }

    public void setDifficulties(List<String> difficulties) {
        this.difficulties = difficulties;
    }

    public Integer getCookTimeInMinutes() {
        return this.maxCookTimeInMinutes;
    }

    public void setCookTimeInMinutes(Integer cookTimeInMinutes) {
        this.maxCookTimeInMinutes = cookTimeInMinutes;
    }

}
