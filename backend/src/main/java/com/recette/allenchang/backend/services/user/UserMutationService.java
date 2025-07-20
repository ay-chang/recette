package com.recette.allenchang.backend.services.user;

import java.util.Random;
import com.recette.allenchang.backend.verification.VerificationCodeStore;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.UserRepository;
import com.recette.allenchang.backend.inputs.AccountDetailsInput;
import com.recette.allenchang.backend.exceptions.InvalidCredentialsException;
import com.recette.allenchang.backend.exceptions.InvalidInputException;
import com.recette.allenchang.backend.exceptions.EmailAlreadyInUseException;
import com.recette.allenchang.backend.services.EmailService;

@Service
public class UserMutationService {

    private final VerificationCodeStore verificationCodeStore;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;

    public UserMutationService(UserRepository userRepository, PasswordEncoder passwordEncoder,
            VerificationCodeStore verificationCodeStore, EmailService emailService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.verificationCodeStore = verificationCodeStore;
        this.emailService = emailService;
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
        validateEmailFormat(email);
        validatePasswordFormat(password);
        checkIfEmailExists(email);

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

        checkIfEmailExists(email); // re-check to avoid race conditions

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

    /** Update a users first and last name, for now */
    public User updateAccountDetails(String email, AccountDetailsInput input) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email));

        user.setFirstName(input.getFirstName());
        user.setLastName(input.getLastName());

        return userRepository.save(user);
    }

    /** Delete a user account */
    public void deleteUserByEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email));
        userRepository.delete(user);
    }

    /** -------------------- Private helper functions -------------------- */

    private void validateEmailFormat(String email) {
        if (!email.matches("^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            throw new InvalidInputException("Invalid email format");
        }
    }

    private void checkIfEmailExists(String email) {
        if (userRepository.findByEmail(email).isPresent()) {
            throw new EmailAlreadyInUseException("Email already in use");
        }
    }

    private void validatePasswordFormat(String password) {
        if (password.length() < 8 || !password.matches(".*[A-Z].*")) {
            throw new InvalidInputException("Password must be at least 8 characters and contain an uppercase letter.");
        }
    }

}
