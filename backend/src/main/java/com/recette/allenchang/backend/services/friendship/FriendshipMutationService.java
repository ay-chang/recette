package com.recette.allenchang.backend.services.friendship;

import java.util.Optional;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.repositories.FriendshipRepository;
import com.recette.allenchang.backend.repositories.UserRepository;
import com.recette.allenchang.backend.models.Friendship.Friendship;
import com.recette.allenchang.backend.models.Friendship.FriendshipStatus;
import com.recette.allenchang.backend.models.User;

@Service
public class FriendshipMutationService {
    private final FriendshipRepository friendshipRepository;
    private final UserRepository userRepository;

    public FriendshipMutationService(FriendshipRepository friendshipRepository, UserRepository userRepository) {
        this.friendshipRepository = friendshipRepository;
        this.userRepository = userRepository;
    }

    /** Create a friendship object in database with status pending */
    public Friendship sendFriendRequest(String userEmail, String friendUsername) {
        User user = findUserByEmail(userEmail);
        User friend = findUserByUsername(friendUsername);
        checkIfSelfRequest(user, friend);
        checkFriendshipDoesNotExist(user, friend);

        Friendship friendship = new Friendship();
        friendship.setUser(user);
        friendship.setFriend(friend);
        friendship.setStatus(FriendshipStatus.PENDING);
        return friendshipRepository.save(friendship);
    }

    /** -------------------- Private helper functions -------------------- */

    /** Setting the user in a mutation function */
    private User findUserByEmail(String email) {
        return userRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("User not found with email: " + email));
    }

    private User findUserByUsername(String username) {
        return userRepository.findByUsername(username.toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("User not found with username: " + username));
    }

    private void checkFriendshipDoesNotExist(User user, User friend) {
        Optional<Friendship> existing = friendshipRepository.findByUserAndFriend(user, friend);
        if (existing.isPresent()) {
            throw new RuntimeException("Friendship already exists");
        }
    }

    private void checkIfSelfRequest(User user, User friend) {
        if (user.equals(friend)) {
            throw new IllegalArgumentException("You cannot send a friend request to yourself.");
        }
    }

}
