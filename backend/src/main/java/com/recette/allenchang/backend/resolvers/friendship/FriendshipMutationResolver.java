package com.recette.allenchang.backend.resolvers.friendship;

import org.springframework.stereotype.Controller;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;

import com.recette.allenchang.backend.models.Friendship.Friendship;
import com.recette.allenchang.backend.services.friendship.FriendshipMutationService;
import com.recette.allenchang.backend.security.JwtUtil;

@Controller
public class FriendshipMutationResolver {
    private final FriendshipMutationService friendshipMutationService;

    public FriendshipMutationResolver(FriendshipMutationService friendshipMutationService) {
        this.friendshipMutationService = friendshipMutationService;
    }

    /** POST: a friend request */
    @MutationMapping
    public Friendship sendFriendRequest(@Argument String friendUsername) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        return friendshipMutationService.sendFriendRequest(userEmail, friendUsername);
    }

}
