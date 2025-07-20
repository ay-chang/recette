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

    /** Send verification code during sign-up */
    @MutationMapping
    public boolean sendVerificationCode(@Argument String email, @Argument String password) {
        userMutationService.sendVerificationCode(email, password);
        return true;
    }

    /** Complete sign-up after verifying email code */
    @MutationMapping
    public String completeSignUpWithCode(@Argument String email, @Argument String code) {
        User user = userMutationService.completeSignUpWithCode(email, code);
        return jwtUtil.generateToken(user.getEmail());
    }

    /** Logout is a client side function so just ignore */
    @MutationMapping
    public boolean logout() {
        return true;
    }

    /** Delete a user account */
    @MutationMapping
    public boolean deleteAccount() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getPrincipal() == null) {
            throw new RuntimeException("Unauthorized");
        }

        String currentUserEmail = (String) auth.getPrincipal();
        userMutationService.deleteUserByEmail(currentUserEmail);
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
