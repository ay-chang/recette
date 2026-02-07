package com.recette.allenchang.backend.common;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.recette.allenchang.backend.exceptions.EmailAlreadyInUseException;
import com.recette.allenchang.backend.exceptions.InvalidInputException;
import com.recette.allenchang.backend.dto.requests.IngredientRequest;
import com.recette.allenchang.backend.models.Ingredient;
import com.recette.allenchang.backend.models.Tag;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.models.Friendship;
import com.recette.allenchang.backend.models.FriendshipStatus;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.repositories.RecipeRepository;
import com.recette.allenchang.backend.repositories.FriendshipRepository;
import com.recette.allenchang.backend.repositories.UserRepository;
import com.recette.allenchang.backend.repositories.TagRepository;

@Component
public class ServiceUtil {
    private static final Logger log = LoggerFactory.getLogger(ServiceUtil.class);

    private final FriendshipRepository friendshipRepository;
    private final UserRepository userRepository;
    private final RecipeRepository recipeRepository;
    private final TagRepository tagRepository;

    public ServiceUtil(FriendshipRepository friendshipRepository, UserRepository userRepository,
            RecipeRepository recipeRepository, TagRepository tagRepository) {
        this.friendshipRepository = friendshipRepository;
        this.userRepository = userRepository;
        this.recipeRepository = recipeRepository;
        this.tagRepository = tagRepository;
    }

    /** ---------- USER UTILS ---------- */

    /** Finding user by email */
    public User findUserByEmail(String email) {
        return userRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("User not found with email: " + email));
    }

    /** Finding user by username */
    public User findUserByUsername(String username) {
        return userRepository.findByUsername(username.toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("User not found with username: " + username));
    }

    /** Ensure email format is correct */
    public void validateEmailFormat(String email) {
        if (!email.matches("^[\\w.+%-]+@([\\w-]+\\.)+[\\w-]{2,}$")) {
            throw new InvalidInputException("Invalid email format");
        }
    }

    /** Check if email exists */
    public void checkIfEmailExists(String email) {
        if (userRepository.findByEmail(email).isPresent()) {
            throw new EmailAlreadyInUseException("Email already in use");
        }
    }

    /** Ensure password format is correct */
    public void validatePasswordFormat(String password) {
        if (password.length() < 8 || !password.matches(".*[A-Z].*")) {
            throw new InvalidInputException("Password must be at least 8 characters and contain an uppercase letter.");
        }
    }

    /** ---------- FRIENDSHIP UTILS ---------- */

    /** Check if friendship does not exist (could just be a pending invite) */
    public void checkFriendshipDoesNotExist(User user, User friend) {
        Optional<Friendship> existing = friendshipRepository.findByUserAndFriend(user, friend);
        if (existing.isPresent()) {
            throw new RuntimeException("Friendship already exists");
        }
    }

    /** Check if friend request is being sent to self */
    public void checkIfSelfRequest(User user, User friend) {
        if (user.equals(friend)) {
            throw new IllegalArgumentException("You cannot send a friend request to yourself.");
        }
    }

    /** Find the already existing friendship object between two users */
    public Friendship findExistingFriendship(User user, User friend) {
        return friendshipRepository.findByUserAndFriend(user, friend)
                .or(() -> friendshipRepository.findByUserAndFriend(friend, user))
                .orElseThrow(() -> new IllegalArgumentException(
                        "No friendship object found for %s and %s".formatted(user.getUsername(),
                                friend.getUsername())));
    }

    /** Find incoming friendrequest from the friend */
    public Friendship findIncomingFriendRequestFromFriend(User user, User friend) {
        Friendship request = friendshipRepository
                .findByUserAndFriendAndStatus(friend, user, FriendshipStatus.PENDING)
                .orElseThrow(() -> new IllegalArgumentException("No pending request from " + friend));

        log.debug("Incoming friend request: {}", request);

        return request;
    }

    /** Find incoming friend requests for a user */
    public List<Friendship> findIncomingFriendRequests(User friend) {
        List<Friendship> incoming = friendshipRepository.findByFriendAndStatus(friend, FriendshipStatus.PENDING);
        if (incoming.isEmpty()) {
            throw new IllegalArgumentException("No incoming friend requests");
        }
        return incoming;
    }

    /** ---------- RECIPE UTILS ---------- */

    /** Setting the recipe in a mutation function */
    public Recipe findRecipeById(UUID id) {
        return recipeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Recipe not found with id: " + id));
    }

    /** Creating and mapping ingredients */
    public List<Ingredient> mapIngredients(List<IngredientRequest> inputs, Recipe recipe) {
        if (inputs == null || inputs.isEmpty()) {
            throw new IllegalArgumentException("Ingredients cannot be null or empty");
        }
        return inputs.stream()
                .map(i -> new Ingredient(i.name(), i.measurement(), recipe))
                .toList();
    }

    /** Creating and mapping tags */
    public List<Tag> mapTags(List<String> tagNames, User user) {
        if (tagNames == null || tagNames.isEmpty()) {
            return List.of();
        }

        return tagNames.stream()
                .map(name -> tagRepository.findByUserAndName(user, name)
                        .orElseThrow(() -> new IllegalArgumentException("Tag not found for user: " + name)))
                .toList();
    }

}
