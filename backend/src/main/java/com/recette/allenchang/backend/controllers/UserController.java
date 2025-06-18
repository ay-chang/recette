package com.recette.allenchang.backend.controllers;

import com.recette.allenchang.backend.inputs.UserInput;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.UserRepository;
import com.recette.allenchang.backend.services.UserService;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

/**
 * Handles GraphQL operations for User.
 */
@Controller
public class UserController {

    private final UserRepository userRepository;
    private final UserService userService;

    public UserController(UserService userService, UserRepository userRepository) {
        this.userService = userService;
        this.userRepository = userRepository;
    }

    // GraphQL mutation for user login
    @MutationMapping
    public String login(@Argument UserInput input) {
        return userService.authenticate(input.getEmail().toLowerCase(), input.getPassword())
                .map(user -> "Login successful!")
                .orElseThrow(() -> new IllegalArgumentException("Invalid credentials"));
    }

    // GraphQL mutation for user signup
    @MutationMapping
    public User signUp(@Argument UserInput input) {
        // Uses registerUser function in UserService to create a new user
        return userService.registerUser(input.getEmail().toLowerCase(), input.getPassword());
    }

    /**
     * @QueryMapping tells Spring this is a GraphQL query
     * @Argument tells Spring to bind the GraphQL variable to the method parameter
     */
    @QueryMapping
    public String getUsername(@Argument String email) {
        System.out.println("getUsername called with email: " + email);
        return userRepository.findByEmail(email.toLowerCase())
                .map(user -> {
                    return user.getUsername();
                })
                .orElseThrow(() -> {
                    System.out.println("User not found with email: " + email);
                    return new RuntimeException("User not found");
                });
    }

    @MutationMapping
    public boolean logout(@Argument String email) {
        // TODO: In the future: invalidate session/token here
        System.out.println("User logged out: " + email);
        return true;
    }

}
