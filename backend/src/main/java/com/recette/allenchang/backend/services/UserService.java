package com.recette.allenchang.backend.services;

/* 
* This file is responsible for the business logic:
* Registration: It checks if the username already exists. If not, it encrypts the password 
* and saves the new user in the database.
* Authentication: It retrieves the user by username and checks if the provided 
* password matches the stored (encoded) password. 
*/

import com.recette.allenchang.backend.repositories.UserRepository;
import com.recette.allenchang.backend.models.User;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.Optional;

/**
 * The @Service is a Spring annotation that marks a class as a service layer
 * component. It indicates that the class contains business logic (e.g., user
 * registration, authentication). Spring automatically detects it during
 * component scanning and makes it available for dependency injection. When you
 * annotate UserService with @Service, Spring creates an instance of it and
 * allows other components (like UserController) to use it by injecting it via
 * the constructor.
 */
@Service
public class UserService {
  private final UserRepository userRepository;
  private final PasswordEncoder passwordEncoder;

  public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
    this.userRepository = userRepository;
    this.passwordEncoder = passwordEncoder;
  }

  /**
   * Registers the user with the given a user given email and a user given
   * password that is encoded.
   * 
   * @param email
   * @param password
   * @return
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
   * 
   * @param email
   * @param password
   * @return
   */
  public Optional<User> authenticate(String email, String password) {
    return userRepository.findByEmail(email)
        .filter(user -> passwordEncoder.matches(password, user.getPassword()));
  }

}
