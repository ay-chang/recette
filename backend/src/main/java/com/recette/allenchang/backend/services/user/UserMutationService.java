package com.recette.allenchang.backend.services.user;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.UserRepository;
import com.recette.allenchang.backend.inputs.AccountDetailsInput;
import com.recette.allenchang.backend.exceptions.InvalidCredentialsException;
import com.recette.allenchang.backend.exceptions.InvalidInputException;
import com.recette.allenchang.backend.exceptions.EmailAlreadyInUseException;

@Service
public class UserMutationService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserMutationService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    /**
     * Registers the user with the given a user given email and a user given
     * password that is encoded.
     */
    public User registerUser(String email, String password) {
        email = email.toLowerCase().trim();
        validateEmail(email);
        validatePassword(password);

        if (userRepository.findByEmail(email).isPresent()) {
            throw new EmailAlreadyInUseException("Email already in use");
        }

        User user = new User();
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));
        user.setUsername(email.split("@")[0]);

        User savedUser = userRepository.save(user);
        return savedUser;
    }

    /**
     * Validate username and password during login. If authentication is successful
     * (username exists and password matches), it contains the User. If
     * authentication fails, it returns an empty Optional.
     */
    public User authenticate(String email, String password) {
        email = email.toLowerCase().trim();

        return userRepository.findByEmail(email)
                .filter(user -> passwordEncoder.matches(password, user.getPassword()))
                .orElseThrow(() -> new InvalidCredentialsException("Invalid username or password"));
    }

    /** Update a users first and last name, for now */
    public User updateAccountDetails(String email, AccountDetailsInput input) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email));

        user.setFirstName(input.getFirstName());
        user.setLastName(input.getLastName());

        return userRepository.save(user);
    }

    public void deleteUserByEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email));
        userRepository.delete(user);
    }

    /** -------------------- Private helper functions -------------------- */

    private void validateEmail(String email) {
        if (!email.matches("^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            throw new InvalidInputException("Invalid email format");
        }
    }

    private void validatePassword(String password) {
        if (password.length() < 8 || !password.matches(".*[A-Z].*")) {
            throw new InvalidInputException("Password must be at least 8 characters and contain an uppercase letter.");
        }
    }

}
