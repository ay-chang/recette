package com.recette.allenchang.backend.common;

import java.util.Arrays;
import java.util.Locale;
import java.util.Optional;
import java.util.Random;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.exceptions.InvalidCredentialsException;
import com.recette.allenchang.backend.exceptions.InvalidInputException;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.UserRepository;
import com.recette.allenchang.backend.verification.VerificationCodeStore;

@Service
public class AuthService {

    @Value("${google.client-ids}") // comma-separated if multiple (iOS, web, etc.)
    private String googleClientIds;

    private final VerificationCodeStore verificationCodeStore;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;
    private final ServiceUtil serviceUtil;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder,
            VerificationCodeStore verificationCodeStore, EmailService emailService, ServiceUtil serviceUtil) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.verificationCodeStore = verificationCodeStore;
        this.emailService = emailService;
        this.serviceUtil = serviceUtil;
    }

    /** Validate username and password during login */
    public User authenticate(String email, String password) {
        email = email.toLowerCase().trim();

        return userRepository.findByEmail(email)
                .filter(user -> passwordEncoder.matches(password, user.getPassword()))
                .orElseThrow(() -> new InvalidCredentialsException("Invalid username or password"));
    }

    /** Send an email to the user with a verification code */
    public void sendVerificationCode(String email, String password) {
        email = email.toLowerCase().trim();
        serviceUtil.validateEmailFormat(email);

        boolean isResend = verificationCodeStore.contains(email);

        if (!isResend) {
            serviceUtil.validatePasswordFormat(password);
            serviceUtil.checkIfEmailExists(email);
        }

        /** Generate 6 digit code between 100000 - 999999 and send the email */
        String code = String.valueOf(new Random().nextInt(900000) + 100000);
        verificationCodeStore.store(email, code, password);
        emailService.sendEmail(
                email,
                "Your Recette verification code",
                "<strong>Your code is: " + code + "</strong>");
    }

    /** Save user to database if completed with code */
    public User completeSignUpWithCode(String email, String code) {
        email = email.toLowerCase().trim();

        if (!verificationCodeStore.isCodeValid(email, code)) {
            throw new InvalidInputException("Invalid or expired verification code");
        }

        serviceUtil.checkIfEmailExists(email); // re-check to avoid race conditions

        String rawPassword = verificationCodeStore.getStoredPassword(email);
        if (rawPassword == null) {
            throw new InvalidInputException("Verification session expired. Please request a new code.");
        }

        User user = new User();
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(rawPassword));
        user.setUsername(email.split("@")[0]);

        User savedUser = userRepository.save(user);
        verificationCodeStore.clear(email);

        return savedUser;
    }

    /** Authenticate or create a new user with Google ID token */
    public User authenticateWithGoogle(String idTokenString) {
        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(),
                    GsonFactory.getDefaultInstance())
                    // The audience must match the client ID(s) that issued the ID token
                    .setAudience(Arrays.stream(googleClientIds.split(","))
                            .map(String::trim)
                            .toList())
                    // (Optional) Explicitly check the issuer
                    .setIssuer("https://accounts.google.com")
                    .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken == null) {
                throw new InvalidCredentialsException("Invalid Google ID token");
            }

            Payload payload = idToken.getPayload();

            // Extra safety: verify the email is verified by Google
            if (!Boolean.TRUE.equals(payload.getEmailVerified())) {
                throw new InvalidCredentialsException("Google email is not verified");
            }

            String email = ((String) payload.getEmail()).toLowerCase(Locale.ROOT);
            String firstName = (String) payload.get("given_name");
            String lasstName = (String) payload.get("family_name");

            Optional<User> existing = userRepository.findByEmail(email);
            if (existing.isPresent()) {
                return existing.get();
            }

            // Create a new account (password stays null)
            User user = new User();
            user.setEmail(email);
            user.setFirstName(firstName);
            user.setLastName(lasstName);
            user.setUsername(defaultUsernameFromEmail(email)); // simple + deterministic
            user.setPassword(null);

            return userRepository.save(user);

        } catch (InvalidCredentialsException e) {
            throw e;
        } catch (Exception e) {
            // Verification or persistence error
            throw new InvalidCredentialsException("Failed Google login");
        }
    }

    private String defaultUsernameFromEmail(String email) {
        // Simple default: local part of email
        String base = email.split("@")[0];
        String candidate = base;
        int suffix = 1;
        while (userRepository.existsByUsername(candidate)) {
            candidate = base + suffix++;
        }
        return candidate;
    }

}
