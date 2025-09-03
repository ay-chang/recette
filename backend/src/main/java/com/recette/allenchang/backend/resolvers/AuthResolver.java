package com.recette.allenchang.backend.resolvers;

import java.util.Date;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.inputs.UserInput;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.services.AuthService;
import com.recette.allenchang.backend.services.RefreshTokenService;

/* TODO: Move this to its own file */
class AuthPayload {
    private String accessToken;
    private String refreshToken;

    public AuthPayload(String a, String r) {
        this.accessToken = a;
        this.refreshToken = r;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public String getRefreshToken() {
        return refreshToken;
    }
}

@Controller
public class AuthResolver {
    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private RefreshTokenService refreshTokenService;

    private final AuthService authService;

    public record AuthPayload(String accessToken, String refreshToken) {
    }

    public AuthResolver(AuthService authService) {
        this.authService = authService;
    }

    /** User login */
    @MutationMapping
    public AuthPayload login(@Argument UserInput input) {
        authService.authenticate(input.getEmail().toLowerCase(), input.getPassword());
        String email = input.getEmail().toLowerCase();

        String access = jwtUtil.generateAccessToken(email);
        String jti = UUID.randomUUID().toString();
        String refresh = jwtUtil.generateRefreshToken(email, jti);

        refreshTokenService.save(
                jti, email, new Date(System.currentTimeMillis() + 1000L * 60 * 60 * 24 * 30));

        return new AuthPayload(access, refresh);
    }

    /** Send verification code during sign-up */
    @MutationMapping
    public boolean sendVerificationCode(@Argument String email, @Argument String password) {
        authService.sendVerificationCode(email, password);
        return true;
    }

    /** Complete sign-up after verifying email code */
    @MutationMapping
    public AuthPayload completeSignUpWithCode(@Argument String email, @Argument String code) {
        User user = authService.completeSignUpWithCode(email, code);

        String access = jwtUtil.generateAccessToken(user.getEmail());
        String jti = UUID.randomUUID().toString();
        String refresh = jwtUtil.generateRefreshToken(user.getEmail(), jti);

        refreshTokenService.save(
                jti, user.getEmail(), new Date(System.currentTimeMillis() + 1000L * 60 * 60 * 24 * 30));

        return new AuthPayload(access, refresh);
    }

    /** This revokes the current refresh token so it can’t be replayed. */
    @MutationMapping
    public boolean logout(@Argument String refreshToken) {
        if (!jwtUtil.validateRefresh(refreshToken))
            return true; // already invalid -> treat as logged out
        String jti = jwtUtil.extractJtiFromRefresh(refreshToken);
        refreshTokenService.revoke(jti);
        return true;
    }

}
