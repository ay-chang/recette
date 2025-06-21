package com.recette.allenchang.backend.services.user;

import java.util.Optional;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.UserRepository;

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
        if (userRepository.findByEmail(email).isPresent()) {
            throw new IllegalArgumentException("Email already in use");
        }
        User user = new User();
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));
        user.setUsername(email.split("@")[0]); // TODO: Implement an actual username system

        return userRepository.save(user);
    }

    /**
     * Validate username and password during login. If authentication is successful
     * (username exists and password matches), it contains the User. If
     * authentication fails, it returns an empty Optional.
     */
    public Optional<User> authenticate(String email, String password) {
        return userRepository.findByEmail(email)
                .filter(user -> passwordEncoder.matches(password, user.getPassword()));
    }

}
