package com.recette.allenchang.backend.services.groceries;

import java.util.List;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.Grocery;
import com.recette.allenchang.backend.repositories.GroceryRepository;
import com.recette.allenchang.backend.repositories.UserRepository;

@Service
public class GroceriesQueryService {
    private final GroceryRepository groceryRepository;
    private final UserRepository userRepository;

    public GroceriesQueryService(GroceryRepository groceryRepository, UserRepository userRepository) {
        this.groceryRepository = groceryRepository;
        this.userRepository = userRepository;
    }

    public List<Grocery> getUserGroceries(String email) {
        return userRepository.findByEmail(email)
                .map(user -> groceryRepository.findByUserId(user.getId()))
                .orElse(List.of());
    }

}
