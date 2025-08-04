package com.recette.allenchang.backend.services.friendship;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.recette.allenchang.backend.repositories.FriendshipRepository;
import com.recette.allenchang.backend.models.Friendship.Friendship;
import com.recette.allenchang.backend.models.Friendship.FriendshipStatus;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.services.ServiceUtil;

@Service
public class FriendshipMutationService {
    private final FriendshipRepository friendshipRepository;
    private final ServiceUtil serviceUtil;

    public FriendshipMutationService(FriendshipRepository friendshipRepository, ServiceUtil serviceUtil) {
        this.friendshipRepository = friendshipRepository;
        this.serviceUtil = serviceUtil;
    }

    /** Create a friendship object in database with status pending */
    public Friendship sendFriendRequest(String userEmail, String friendUsername) {
        User user = serviceUtil.findUserByEmail(userEmail);
        User friend = serviceUtil.findUserByUsername(friendUsername);
        serviceUtil.checkIfSelfRequest(user, friend);
        serviceUtil.checkFriendshipDoesNotExist(user, friend);

        Friendship friendship = new Friendship();
        friendship.setUser(user);
        friendship.setFriend(friend);
        friendship.setStatus(FriendshipStatus.PENDING);
        return friendshipRepository.save(friendship);
    }

    /** Change the status of a friendship object for user and friend to true */
    public Friendship acceptFriendRequest(String userEmail, String friendUsername) {
        User user = serviceUtil.findUserByEmail(userEmail);
        User friend = serviceUtil.findUserByUsername(friendUsername);
        Friendship friendship = serviceUtil.findIncomingFriendRequestFromFriend(user, friend);

        friendship.setStatus(FriendshipStatus.ACCEPTED);
        return friendshipRepository.save(friendship);
    }

    /** Remove friendship object for user and friend */
    @Transactional
    public boolean removeFriend(String userEmail, String friendUsername) {
        User user = serviceUtil.findUserByEmail(userEmail);
        User friend = serviceUtil.findUserByUsername(friendUsername);
        Friendship friendship = serviceUtil.findExistingFriendship(user, friend);

        friendshipRepository.delete(friendship);
        return true;
    }

}
