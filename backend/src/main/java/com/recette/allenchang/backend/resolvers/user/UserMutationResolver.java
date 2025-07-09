package com.recette.allenchang.backend.resolvers.user;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.inputs.AccountDetailsInput;
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
        userMutationService.authenticate(input.getEmail().toLowerCase(), input.getPassword());
        return "Login successful!";
    }

    /** User sign up */
    @MutationMapping
    public User signUp(@Argument UserInput input) {
        return userMutationService.registerUser(input.getEmail().toLowerCase(), input.getPassword());
    }

    /** Logout */
    @MutationMapping
    public boolean logout(@Argument String email) {
        // TODO: In the future: invalidate session/token here
        return true;
    }

    @MutationMapping
    public User updateAccountDetails(@Argument String email, @Argument AccountDetailsInput input) {
        return userMutationService.updateAccountDetails(email, input);
    }

}
