package com.recette.allenchang.backend.services;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.repositories.*;
import com.recette.allenchang.backend.exceptions.*;

import java.util.List;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.repositories.UserRepository;

@Service
public class GroceryQueryService {
    private final GroceryRepository groceryRepository;
    private final UserRepository userRepository;

    public GroceryQueryService(GroceryRepository groceryRepository, UserRepository userRepository) {
        this.groceryRepository = groceryRepository;
        this.userRepository = userRepository;
    }

    public List<Grocery> getUserGroceries(String email) {
        return userRepository.findByEmail(email.toLowerCase())
                .map(user -> groceryRepository.findByUserId(user.getId()))
                .orElse(List.of());
    }

}
