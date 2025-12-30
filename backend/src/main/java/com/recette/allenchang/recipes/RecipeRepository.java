package com.recette.allenchang.recipes;

import org.springframework.data.domain.Sort;

/*
 * The RecipeRepository interface extends JpaRepository, which is a Spring Data JPA 
 * interface providing basic CRUD (Create, Read, Update, Delete) operations. This 
 * repository allows your application to interact with the database. JPA Docs:
 * https://docs.spring.io/spring-data/jpa/reference/repositories/query-keywords-reference.html
 */

import org.springframework.data.jpa.repository.JpaRepository;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.models.Tag;
import java.util.List;
import java.util.UUID;

public interface RecipeRepository extends JpaRepository<Recipe, UUID> {
    List<Recipe> findByUserId(UUID userId, Sort sort);

    List<Recipe> findAllByTagsContaining(Tag tag);
}
