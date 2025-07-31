package com.recette.allenchang.backend.repositories;

import com.recette.allenchang.backend.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.recette.allenchang.backend.models.Friendship.Friendship;
import com.recette.allenchang.backend.models.Friendship.FriendshipId;
import com.recette.allenchang.backend.models.Friendship.FriendshipStatus;

import java.util.Optional;
import java.util.List;

@Repository
public interface FriendshipRepository extends JpaRepository<Friendship, FriendshipId> {

    /** Check if a friendship already exists (in either direction) */
    Optional<Friendship> findByUserAndFriend(User user, User friend);

    /** Find friendships initiated by a user */
    List<Friendship> findByUser(User user);

    /** Find friendships received by a user */
    List<Friendship> findByFriend(User friend);

    /** Find all accepted friendships (user is either sender or receiver) */
    List<Friendship> findByUserOrFriendAndStatus(User user, User friend, FriendshipStatus status);

    /** Find pending requests sent by the user */
    List<Friendship> findByUserAndStatus(User user, FriendshipStatus status);

    /** Optional: find pending requests received by the user */
    List<Friendship> findByFriendAndStatus(User friend, FriendshipStatus status);
}
