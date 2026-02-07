package com.recette.allenchang.backend.models;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Column;
import jakarta.persistence.UniqueConstraint;

import java.time.LocalDateTime;
import java.util.UUID;

import org.hibernate.annotations.CreationTimestamp;

/**
 * Represents a saved/bookmarked recipe by a user.
 * Users can save other users' public recipes for quick access.
 */
@Entity
@Table(name = "saved_recipes", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "recipe_id"})
})
public class SavedRecipe {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "recipe_id", nullable = false)
    private Recipe recipe;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    public SavedRecipe() {
    }

    public SavedRecipe(User user, Recipe recipe) {
        this.user = user;
        this.recipe = recipe;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Recipe getRecipe() {
        return recipe;
    }

    public void setRecipe(Recipe recipe) {
        this.recipe = recipe;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
