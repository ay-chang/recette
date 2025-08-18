package com.recette.allenchang.backend.services.user;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.UserRepository;
import com.recette.allenchang.backend.inputs.AccountDetailsInput;

@Service
public class UserMutationService {

    private final UserRepository userRepository;

    public UserMutationService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /** Update a users first and last name, for now */
    public User updateAccountDetails(String email, AccountDetailsInput input) {
        User user = userRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new RuntimeException("User not found with email: " +
                        email));

        user.setFirstName(input.getFirstName());
        user.setLastName(input.getLastName());

        return userRepository.save(user);
    }

    /** Delete a user account */
    public void deleteUserByEmail(String email) {
        User user = userRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email));
        userRepository.delete(user);
    }
}
