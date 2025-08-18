package com.recette.allenchang.backend.resolvers.user;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.inputs.AccountDetailsInput;
import com.recette.allenchang.backend.models.User;

import com.recette.allenchang.backend.services.user.UserMutationService;

@Controller
public class UserMutationResolver {
    private final UserMutationService userMutationService;

    public UserMutationResolver(UserMutationService userMutationService) {
        this.userMutationService = userMutationService;
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
