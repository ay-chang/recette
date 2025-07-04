package com.recette.allenchang.backend.repositories;

import com.recette.allenchang.backend.models.Grocery;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.models.User;

import jakarta.transaction.Transactional;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface GroceryRepository extends JpaRepository<Grocery, UUID> {
    List<Grocery> findByUserId(UUID userId);

    @Modifying
    @Transactional
    @Query("UPDATE Grocery g SET g.checked = :checked WHERE g.id = :id")
    void updateChecked(@Param("id") UUID id, @Param("checked") boolean checked);

    void deleteByUserAndRecipe(User user, Recipe recipe);
}