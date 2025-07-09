package com.recette.allenchang.backend.resolvers.user;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.services.user.UserQueryService;

@Controller
public class UserQueryResolver {
    private final UserQueryService userQueryService;

    public UserQueryResolver(UserQueryService userQueryService) {
        this.userQueryService = userQueryService;
    }

    @QueryMapping
    public String getUsername(@Argument String email) {
        return userQueryService.getUsername(email);
    }

    @QueryMapping
    public User userDetails(@Argument String email) {
        return userQueryService.getUserDetails(email);
    }

}
