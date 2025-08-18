package com.recette.allenchang.backend.services;

import java.util.Random;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.exceptions.InvalidCredentialsException;
import com.recette.allenchang.backend.exceptions.InvalidInputException;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.UserRepository;
import com.recette.allenchang.backend.verification.VerificationCodeStore;

@Service
public class AuthService {

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

}
