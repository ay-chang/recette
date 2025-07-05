package com.recette.allenchang.backend.models;

/**
 * We can think of this Recipe class represents a table in the database,
 * where each instance of Recipe corresponds to a row, and each field (ex: 
 * String title) corresponds to a column. It defines the structure of the 
 * recipe table in the database. 
 */

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.CascadeType;
import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.JoinTable;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.hibernate.annotations.CreationTimestamp;

/**
 * The @Entity anotations marks the class as a JPA entity, which means
 * it maps to a table in the database. The table will be named recipe by
 * default (based on the class name). Each field is a column in the table
 * and each object instance is a row in the table.
 */
@Entity
@Table(name = "recipes")
public class Recipe {

    /** The @Id marks the id field as the primary key of the entity. */
    @Id
    @GeneratedValue
    private UUID id;
    private String title;
    private String description;
    private String imageurl;
    private String difficulty;
    private Integer cookTimeInMinutes;
    private Integer servingSize;

    /**
     * The @OneToMany: Indicates a one-to-many relationship. A Recipe is the "one"
     * side, and Ingredient is the "many" side. mappedBy = "recipe": This tells JPA
     * that the ingredients field in the Recipe class is mapped by the recipe field
     * in the Ingredient class. CascadeType.ALL means any operation performed on a
     * Recipe (e.g., save, delete) will be cascaded to its associated Ingredient
     * entities.CascadeType. ALL may have to be changed to optimize database
     * operations. Same is true for the orphanRemoval = true property.
     */
    @OneToMany(mappedBy = "recipe", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Ingredient> ingredients;

    /**
     * The @ManyToOne annotation combined with @JoinColumn(name = "user_id") ensures
     * that the user field maps to the user_id column in the database. So I can
     * continue to use "user" in other files rather than "user_id"
     */
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    /** TODO: Change to a @ManyToOne relationship when adding ordering to steps */
    @ElementCollection
    @CollectionTable(name = "recipe_steps", joinColumns = @JoinColumn(name = "recipe_id"))
    @Column(name = "step")
    private List<String> steps;

    @ManyToMany
    @JoinTable(name = "recipe_tags", joinColumns = @JoinColumn(name = "recipe_id"), inverseJoinColumns = @JoinColumn(name = "tag_id"))
    private List<Tag> tags;

    @OneToMany(mappedBy = "recipe", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Grocery> groceries;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    /** Constructor, getters, and setters */
    public Recipe() {
    }

    public Recipe(String title, String description, List<Ingredient> ingredients, List<String> steps,
            String imageurl, User user, String difficulty, Integer cookTimeInMinutes, Integer servingSize) {
        this.title = title;
        this.description = description;
        this.ingredients = ingredients;
        this.steps = steps;
        this.imageurl = imageurl;
        this.user = user;
        this.difficulty = difficulty;
        this.cookTimeInMinutes = cookTimeInMinutes;
        this.servingSize = servingSize;
    }

    /** Getters and setters */
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
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

    public List<Ingredient> getIngredients() {
        return ingredients;
    }

    public void setIngredients(List<Ingredient> ingredients) {
        this.ingredients = ingredients;
    }

    public String getImageurl() {
        return imageurl;
    }

    public void setImageurl(String imageurl) {
        this.imageurl = imageurl;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<Tag> getTags() {
        return tags;
    }

    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }

    public List<String> getSteps() {
        return steps;
    }

    public void setSteps(List<String> steps) {
        this.steps = steps;
    }

    public String getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public Integer getCookTimeInMinutes() {
        return cookTimeInMinutes;
    }

    public void setCookTimeInMinutes(Integer cookTimeInMinutes) {
        this.cookTimeInMinutes = cookTimeInMinutes;
    }

    public Integer getServingSize() {
        return servingSize;
    }

    public void setServingSize(Integer servingSize) {
        this.servingSize = servingSize;
    }

    public LocalDateTime getCreatedAt() {
        return this.createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

}
