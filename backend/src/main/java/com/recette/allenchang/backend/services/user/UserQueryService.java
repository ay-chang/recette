package com.recette.allenchang.backend.services.user;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.UserRepository;

@Service
public class UserQueryService {
    private final UserRepository userRepository;

    public UserQueryService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public String getUsername(String email) {
        return userRepository.findByEmail(email.toLowerCase())
                .map(user -> {
                    return user.getUsername();
                })
                .orElseThrow(() -> {
                    System.out.println("User not found with email: " + email);
                    return new RuntimeException("User not found");
                });
    }

    /** Get user details: username and first and last name */
    public User getUserDetails(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email));
    }

}
