package com.recette.allenchang.backend.services.friendship;

import java.util.List;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.models.Friendship.Friendship;
import com.recette.allenchang.backend.models.Friendship.FriendshipStatus;
import com.recette.allenchang.backend.repositories.FriendshipRepository;
import com.recette.allenchang.backend.services.ServiceUtil;

@Service
public class FriendshipQueryService {
    private final FriendshipRepository friendshipRepository;
    private final ServiceUtil serviceUtil;

    public FriendshipQueryService(FriendshipRepository friendshipRepository, ServiceUtil serviceUtil) {
        this.friendshipRepository = friendshipRepository;
        this.serviceUtil = serviceUtil;
    }

    /** Search for a list of users that are friends with the user */
    public List<User> getFriends(String userEmail) {
        User user = serviceUtil.findUserByEmail(userEmail);
        List<Friendship> friendships = friendshipRepository.findByStatusAndUserOrStatusAndFriend(
                FriendshipStatus.ACCEPTED, user,
                FriendshipStatus.ACCEPTED, user);
        return friendships.stream()
                .map(f -> f.getUser().equals(user) ? f.getFriend() : f.getUser())
                .toList();
    }

    /** Return a list of people that are sending requests to the user */
    public List<User> getIncomingFriendRequests(String userEmail) {
        User user = serviceUtil.findUserByEmail(userEmail);
        List<Friendship> friendships = friendshipRepository.findByFriendAndStatus(user, FriendshipStatus.PENDING);
        return friendships.stream()
                .map(Friendship::getUser) // get the sender of each request
                .toList();
    }

}
