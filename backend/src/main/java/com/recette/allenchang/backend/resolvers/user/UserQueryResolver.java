package com.recette.allenchang.backend.resolvers.user;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.repositories.UserRepository;

@Controller
public class UserQueryResolver {
    private final UserRepository userRepository;

    public UserQueryResolver(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

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

}
