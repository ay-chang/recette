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

    /** Find a user and friend and by status, used for acceping friend requests */
    Optional<Friendship> findByUserAndFriendAndStatus(User user, User friend, FriendshipStatus status);

    /** Find friendships initiated by a user */
    List<Friendship> findByUser(User user);

    /** Find friendships received by a user */
    List<Friendship> findByFriend(User friend);

    /** Find pending requests sent by the user */
    List<Friendship> findByUserAndStatus(User user, FriendshipStatus status);

    /** Find pending requests received by the user */
    List<Friendship> findByFriendAndStatus(User friend, FriendshipStatus status);

    /** Used to find by status */
    List<Friendship> findByStatusAndUserOrStatusAndFriend(
            FriendshipStatus status1, User user1,
            FriendshipStatus status2, User user2);

}
