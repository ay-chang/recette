package com.recette.allenchang.backend.auth;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.recette.allenchang.backend.auth.dto.requests.CompleteSignUpRequest;
import com.recette.allenchang.backend.auth.dto.requests.AppleLoginRequest;
import com.recette.allenchang.backend.auth.dto.requests.GoogleLoginRequest;
import com.recette.allenchang.backend.auth.dto.requests.LoginRequest;
import com.recette.allenchang.backend.auth.dto.requests.ForgotPasswordRequest;
import com.recette.allenchang.backend.auth.dto.requests.RefreshTokenRequest;
import com.recette.allenchang.backend.auth.dto.requests.ResetPasswordRequest;
import com.recette.allenchang.backend.auth.dto.requests.SendVerificationCodeRequest;
import com.recette.allenchang.backend.auth.dto.responses.AuthResponse;
import com.recette.allenchang.backend.exceptions.InvalidCredentialsException;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.common.AuthService;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final JwtUtil jwtUtil;
    private final AuthService authService;

    public AuthController(JwtUtil jwtUtil, AuthService authService) {
        this.jwtUtil = jwtUtil;
        this.authService = authService;
    }

    private AuthResponse buildAuthResponse(String email) {
        String token = jwtUtil.generateToken(email);
        String refreshToken = jwtUtil.generateRefreshToken(email);
        return new AuthResponse(token, refreshToken);
    }

    /** POST: User login with email and password */
    @PostMapping("/login")
    public AuthResponse login(@RequestBody LoginRequest request) {
        authService.authenticate(request.email().toLowerCase(), request.password());
        return buildAuthResponse(request.email().toLowerCase());
    }

    /** POST: User login with Google */
    @PostMapping("/login/google")
    public AuthResponse loginWithGoogle(@RequestBody GoogleLoginRequest request) {
        User user = authService.authenticateWithGoogle(request.idToken());
        return buildAuthResponse(user.getEmail().toLowerCase());
    }

    /** POST: User login with Apple */
    @PostMapping("/login/apple")
    public AuthResponse loginWithApple(@RequestBody AppleLoginRequest request) {
        User user = authService.authenticateWithApple(request.idToken());
        return buildAuthResponse(user.getEmail().toLowerCase());
    }

    /** POST: Send verification code during sign-up */
    @PostMapping("/signup/send-code")
    public ResponseEntity<Void> sendVerificationCode(@RequestBody SendVerificationCodeRequest request) {
        authService.sendVerificationCode(request.email(), request.password());
        return ResponseEntity.ok().build();
    }

    /** POST: Complete sign-up after verifying email code */
    @PostMapping("/signup/complete")
    public AuthResponse completeSignUp(@RequestBody CompleteSignUpRequest request) {
        User user = authService.completeSignUpWithCode(request.email(), request.code());
        return buildAuthResponse(user.getEmail());
    }

    /** POST: Exchange a valid refresh token for a new access token */
    @PostMapping("/refresh")
    public AuthResponse refreshToken(@RequestBody RefreshTokenRequest request) {
        String refreshToken = request.refreshToken();
        if (!jwtUtil.validateToken(refreshToken) || !jwtUtil.isRefreshToken(refreshToken)) {
            throw new InvalidCredentialsException("Invalid or expired refresh token");
        }
        String email = jwtUtil.extractEmail(refreshToken);
        String newAccessToken = jwtUtil.generateToken(email);
        return new AuthResponse(newAccessToken, refreshToken);
    }

    /** POST: Request a password reset code */
    @PostMapping("/forgot-password")
    public ResponseEntity<Void> forgotPassword(@RequestBody ForgotPasswordRequest request) {
        authService.sendPasswordResetCode(request.email());
        return ResponseEntity.ok().build();
    }

    /** POST: Reset password with code */
    @PostMapping("/reset-password")
    public ResponseEntity<Void> resetPassword(@RequestBody ResetPasswordRequest request) {
        authService.resetPassword(request.email(), request.code(), request.newPassword());
        return ResponseEntity.ok().build();
    }
}
