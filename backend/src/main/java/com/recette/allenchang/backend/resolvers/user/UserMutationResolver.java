package com.recette.allenchang.backend.resolvers.user;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.inputs.UserInput;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.services.user.UserMutationService;

@Controller
public class UserMutationResolver {
    private final UserMutationService userMutationService;

    public UserMutationResolver(UserMutationService userMutationService) {
        this.userMutationService = userMutationService;
    }

    /** User login */
    @MutationMapping
    public String login(@Argument UserInput input) {
        return userMutationService.authenticate(input.getEmail().toLowerCase(), input.getPassword())
                .map(user -> "Login successful!")
                .orElseThrow(() -> new IllegalArgumentException("Invalid credentials"));
    }

    /** User sign up */
    @MutationMapping
    public User signUp(@Argument UserInput input) {
        // Uses registerUser function in UserService to create a new user
        return userMutationService.registerUser(input.getEmail().toLowerCase(), input.getPassword());
    }

    /** Logout */
    @MutationMapping
    public boolean logout(@Argument String email) {
        // TODO: In the future: invalidate session/token here
        System.out.println("User logged out: " + email);
        return true;
    }

}
