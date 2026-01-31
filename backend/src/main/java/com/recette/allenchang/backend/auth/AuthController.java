package com.recette.allenchang.backend.auth;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.recette.allenchang.backend.auth.dto.requests.CompleteSignUpRequest;
import com.recette.allenchang.backend.auth.dto.requests.GoogleLoginRequest;
import com.recette.allenchang.backend.auth.dto.requests.LoginRequest;
import com.recette.allenchang.backend.auth.dto.requests.SendVerificationCodeRequest;
import com.recette.allenchang.backend.auth.dto.responses.AuthResponse;
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

    /** POST: User login with email and password */
    @PostMapping("/login")
    public AuthResponse login(@RequestBody LoginRequest request) {
        authService.authenticate(request.email().toLowerCase(), request.password());
        String token = jwtUtil.generateToken(request.email().toLowerCase());
        return new AuthResponse(token);
    }

    /** POST: User login with Google */
    @PostMapping("/login/google")
    public AuthResponse loginWithGoogle(@RequestBody GoogleLoginRequest request) {
        User user = authService.authenticateWithGoogle(request.idToken());
        String token = jwtUtil.generateToken(user.getEmail().toLowerCase());
        return new AuthResponse(token);
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
        String token = jwtUtil.generateToken(user.getEmail());
        return new AuthResponse(token);
    }
}
