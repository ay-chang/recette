package com.recette.allenchang.backend.repositories;

import com.recette.allenchang.backend.models.SavedRecipe;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface SavedRecipeRepository extends JpaRepository<SavedRecipe, UUID> {
    List<SavedRecipe> findByUserIdOrderByCreatedAtDesc(UUID userId);

    Optional<SavedRecipe> findByUserIdAndRecipeId(UUID userId, UUID recipeId);

    boolean existsByUserIdAndRecipeId(UUID userId, UUID recipeId);

    void deleteByUserIdAndRecipeId(UUID userId, UUID recipeId);
}
