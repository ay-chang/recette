package com.recette.allenchang.backend.common;

import java.math.BigInteger;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.security.SecureRandom;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.recette.allenchang.backend.exceptions.InvalidCredentialsException;
import com.recette.allenchang.backend.exceptions.InvalidInputException;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.UserRepository;
import com.recette.allenchang.backend.security.AppleJwksCache;
import com.recette.allenchang.backend.verification.PasswordResetStore;
import com.recette.allenchang.backend.verification.VerificationCodeStore;

@Service
public class AuthService {

    @Value("${google.client-ids}") // comma-separated if multiple (iOS, web, etc.)
    private String googleClientIds;

    @Value("${apple.client-id}")
    private String appleClientId;

    private final VerificationCodeStore verificationCodeStore;
    private final PasswordResetStore passwordResetStore;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;
    private final ServiceUtil serviceUtil;
    private final ObjectMapper objectMapper;
    private final AppleJwksCache appleJwksCache;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder,
            VerificationCodeStore verificationCodeStore, PasswordResetStore passwordResetStore,
            EmailService emailService, ServiceUtil serviceUtil,
            ObjectMapper objectMapper, AppleJwksCache appleJwksCache) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.verificationCodeStore = verificationCodeStore;
        this.passwordResetStore = passwordResetStore;
        this.emailService = emailService;
        this.serviceUtil = serviceUtil;
        this.objectMapper = objectMapper;
        this.appleJwksCache = appleJwksCache;
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
        String code = String.valueOf(new SecureRandom().nextInt(900000) + 100000);
        verificationCodeStore.store(email, code, password);
        emailService.sendEmail(
                email,
                "Your Recette verification code",
                "<strong>Your code is: " + code + "</strong>");
    }

    /** Save user to database if completed with code */
    public User completeSignUpWithCode(String email, String code) {
        email = email.toLowerCase().trim();

        if (verificationCodeStore.isLockedOut(email)) {
            throw new InvalidInputException("Too many failed attempts. Please try again later.");
        }

        if (!verificationCodeStore.isCodeValid(email, code)) {
            throw new InvalidInputException("Invalid or expired verification code");
        }

        serviceUtil.checkIfEmailExists(email); // re-check to avoid race conditions

        String hashedPassword = verificationCodeStore.getStoredPassword(email);
        if (hashedPassword == null) {
            throw new InvalidInputException("Verification session expired. Please request a new code.");
        }

        User user = new User();
        user.setEmail(email);
        user.setPassword(hashedPassword); // already hashed in VerificationCodeStore
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
            String lastName = (String) payload.get("family_name");

            Optional<User> existing = userRepository.findByEmail(email);
            if (existing.isPresent()) {
                return existing.get();
            }

            // Create a new account (password stays null)
            User user = new User();
            user.setEmail(email);
            user.setFirstName(firstName);
            user.setLastName(lastName);
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

    /** Authenticate or create a new user with Apple ID token */
    public User authenticateWithApple(String idTokenString) {
        try {
            // Decode token header to extract kid
            String[] parts = idTokenString.split("\\.");
            if (parts.length != 3) {
                throw new InvalidCredentialsException("Invalid Apple ID token format");
            }
            String headerJson = new String(Base64.getUrlDecoder().decode(parts[0]));
            Map<String, Object> header = objectMapper.readValue(headerJson, Map.class);
            String kid = (String) header.get("kid");

            // Fetch Apple's public keys (cached, refreshed hourly)
            List<Map<String, Object>> keys = appleJwksCache.getKeys();
            Map<String, Object> matchingKey = keys.stream()
                    .filter(k -> kid.equals(k.get("kid")))
                    .findFirst()
                    .orElseThrow(() -> new InvalidCredentialsException("No matching key in Apple JWKS"));

            // Reconstruct RSA public key from JWK n and e parameters
            byte[] modulus = Base64.getUrlDecoder().decode((String) matchingKey.get("n"));
            byte[] exponent = Base64.getUrlDecoder().decode((String) matchingKey.get("e"));
            RSAPublicKeySpec keySpec = new RSAPublicKeySpec(
                    new BigInteger(1, modulus),
                    new BigInteger(1, exponent));
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            PublicKey publicKey = keyFactory.generatePublic(keySpec);

            // Verify the token signature and required claims
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(publicKey)
                    .requireIssuer("https://appleid.apple.com")
                    .requireAudience(appleClientId)
                    .build()
                    .parseClaimsJws(idTokenString)
                    .getBody();

            String appleSub = claims.getSubject();
            String email = claims.get("email", String.class);

            // Returning user: look up by Apple ID first
            Optional<User> existingByAppleId = userRepository.findByAppleId(appleSub);
            if (existingByAppleId.isPresent()) {
                return existingByAppleId.get();
            }

            // First sign-in: email must be present
            if (email == null) {
                throw new InvalidCredentialsException("Apple sign-in failed: no email and no linked account");
            }
            email = email.toLowerCase(Locale.ROOT);

            // Parse name — Apple sends it as a nested JSON string
            // {"firstName":"...","lastName":"..."}
            String firstName = null;
            String lastName = null;
            String nameJson = claims.get("name", String.class);
            if (nameJson != null) {
                Map<String, String> nameMap = objectMapper.readValue(nameJson, Map.class);
                firstName = nameMap.get("firstName");
                lastName = nameMap.get("lastName");
            }

            // Link to an existing account if email already registered
            Optional<User> existingByEmail = userRepository.findByEmail(email);
            if (existingByEmail.isPresent()) {
                User user = existingByEmail.get();
                user.setAppleId(appleSub);
                return userRepository.save(user);
            }

            // Create a new account (password stays null)
            User user = new User();
            user.setEmail(email);
            user.setAppleId(appleSub);
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setUsername(defaultUsernameFromEmail(email));
            user.setPassword(null);

            return userRepository.save(user);

        } catch (InvalidCredentialsException e) {
            throw e;
        } catch (Exception e) {
            throw new InvalidCredentialsException("Failed Apple login");
        }
    }

    /** Send a password reset code to the user's email */
    public void sendPasswordResetCode(String email) {
        email = email.toLowerCase().trim();
        serviceUtil.validateEmailFormat(email);

        // Only send if user exists, but don't reveal that to the caller
        Optional<User> user = userRepository.findByEmail(email);
        if (user.isEmpty()) {
            return; // silently succeed to prevent email enumeration
        }

        String code = String.valueOf(new SecureRandom().nextInt(900000) + 100000);
        passwordResetStore.store(email, code);
        emailService.sendEmail(
                email,
                "Your Recette password reset code",
                "<strong>Your password reset code is: " + code + "</strong><br>This code expires in 10 minutes.");
    }

    /** Reset the user's password using the verification code */
    public void resetPassword(String email, String code, String newPassword) {
        email = email.toLowerCase().trim();

        if (passwordResetStore.isLockedOut(email)) {
            throw new InvalidInputException("Too many failed attempts. Please try again later.");
        }

        if (!passwordResetStore.isCodeValid(email, code)) {
            throw new InvalidInputException("Invalid or expired reset code");
        }

        serviceUtil.validatePasswordFormat(newPassword);

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new InvalidInputException("User not found"));

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        passwordResetStore.clear(email);
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
