package com.recette.allenchang.backend.resolvers.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.inputs.AccountDetailsInput;
import com.recette.allenchang.backend.inputs.UserInput;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.services.user.UserMutationService;

@Controller
public class UserMutationResolver {
    @Autowired
    private JwtUtil jwtUtil;
    private final UserMutationService userMutationService;

    public UserMutationResolver(UserMutationService userMutationService) {
        this.userMutationService = userMutationService;
    }

    /** User login */
    @MutationMapping
    public String login(@Argument UserInput input) {
        userMutationService.authenticate(input.getEmail().toLowerCase(), input.getPassword());
        return jwtUtil.generateToken(input.getEmail().toLowerCase());
    }

    /** User sign up */
    @MutationMapping
    public String signUp(@Argument UserInput input) {
        User user = userMutationService.registerUser(input.getEmail().toLowerCase(), input.getPassword());
        return jwtUtil.generateToken(user.getEmail());
    }

    /** Logout */
    @MutationMapping
    public boolean logout(@Argument String email) {
        // TODO: In the future: invalidate session/token here
        return true;
    }

    /** Update user account details */
    @MutationMapping
    public User updateAccountDetails(@Argument String email, @Argument AccountDetailsInput input) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getPrincipal() == null) {
            throw new RuntimeException("Unauthorized");
        }
        String currentUserEmail = (String) auth.getPrincipal();

        if (!email.equalsIgnoreCase(currentUserEmail)) {
            throw new RuntimeException("Unauthorized — can't update another user's account");
        }

        return userMutationService.updateAccountDetails(email, input);
    }

}
