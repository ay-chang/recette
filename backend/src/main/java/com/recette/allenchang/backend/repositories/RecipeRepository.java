package com.recette.allenchang.backend.repositories;

/*
 * The RecipeRepository interface extends JpaRepository, which is a Spring Data JPA 
 * interface providing basic CRUD (Create, Read, Update, Delete) operations. This 
 * repository allows your application to interact with the database. JPA Docs:
 * https://docs.spring.io/spring-data/jpa/reference/repositories/query-keywords-reference.html
 */

import org.springframework.data.jpa.repository.JpaRepository;
import com.recette.allenchang.backend.models.Recipe;
import java.util.List;

public interface RecipeRepository extends JpaRepository<Recipe, Integer> {
    List<Recipe> findByUserId(Long userId);

}
