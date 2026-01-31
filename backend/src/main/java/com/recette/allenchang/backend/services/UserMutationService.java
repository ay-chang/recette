package com.recette.allenchang.backend.services;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.repositories.*;
import com.recette.allenchang.backend.exceptions.*;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.dto.requests.UpdateAccountDetailsRequest;

@Service
public class UserMutationService {

    private final UserRepository userRepository;

    public UserMutationService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /** Update a users first and last name, for now */
    public User updateAccountDetails(String email, UpdateAccountDetailsRequest request) {
        User user = userRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new RuntimeException("User not found with email: " +
                        email));

        user.setFirstName(request.firstName());
        user.setLastName(request.lastName());

        return userRepository.save(user);
    }

    /** Delete a user account */
    public void deleteUserByEmail(String email) {
        User user = userRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email));
        userRepository.delete(user);
    }
}
