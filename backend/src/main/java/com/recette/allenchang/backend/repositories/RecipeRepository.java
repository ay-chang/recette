package com.recette.allenchang.backend.repositories;

import com.recette.allenchang.backend.models.*;

import org.springframework.data.domain.Sort;

/*
 * The RecipeRepository interface extends JpaRepository, which is a Spring Data JPA 
 * interface providing basic CRUD (Create, Read, Update, Delete) operations. This 
 * repository allows your application to interact with the database. JPA Docs:
 * https://docs.spring.io/spring-data/jpa/reference/repositories/query-keywords-reference.html
 */

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.recette.allenchang.backend.models.Tag;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface RecipeRepository extends JpaRepository<Recipe, UUID> {
    List<Recipe> findByUserId(UUID userId, Sort sort);

    List<Recipe> findAllByTagsContaining(Tag tag);

    @Query("SELECT r FROM Recipe r WHERE r.user.id IN :userIds AND r.isPublic = true ORDER BY r.createdAt DESC")
    List<Recipe> findPublicRecipesByUserIds(@Param("userIds") List<UUID> userIds);

    @Query("SELECT r FROM Recipe r WHERE r.id = :id AND r.isPublic = true")
    Optional<Recipe> findPublicRecipeById(@Param("id") UUID id);
}
