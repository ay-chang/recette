package com.recette.allenchang.backend.repositories;

import com.recette.allenchang.backend.models.Grocery;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface GroceryRepository extends JpaRepository<Grocery, Integer> {
    List<Grocery> findByUserId(Long userId);
}