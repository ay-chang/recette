package com.recette.allenchang.backend.resolvers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.inputs.UserInput;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.services.AuthService;

@Controller
public class AuthResolver {
    @Autowired
    private JwtUtil jwtUtil;
    private final AuthService authService;

    public AuthResolver(AuthService authService) {
        this.authService = authService;
    }

    /** User login with email */
    @MutationMapping
    public String login(@Argument UserInput input) {
        authService.authenticate(input.getEmail().toLowerCase(), input.getPassword());
        return jwtUtil.generateToken(input.getEmail().toLowerCase());
    }

    /** User login with Google */
    @MutationMapping
    public String loginWithGoogle(@Argument String idToken) {
        User user = authService.authenticateWithGoogle(idToken);
        return jwtUtil.generateToken(user.getEmail().toLowerCase());
    }

    /** Send verification code during sign-up */
    @MutationMapping
    public boolean sendVerificationCode(@Argument String email, @Argument String password) {
        authService.sendVerificationCode(email, password);
        return true;
    }

    /** Complete sign-up after verifying email code */
    @MutationMapping
    public String completeSignUpWithCode(@Argument String email, @Argument String code) {
        User user = authService.completeSignUpWithCode(email, code);
        return jwtUtil.generateToken(user.getEmail());
    }

}
