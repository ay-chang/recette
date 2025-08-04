package com.recette.allenchang.backend.resolvers.friendship;

import java.util.List;

import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.models.Friendship.Friendship;
import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.services.friendship.FriendshipQueryService;

@Controller
public class FriendshipQueryResolver {
    private final FriendshipQueryService friendshipQueryService;

    public FriendshipQueryResolver(FriendshipQueryService friendshipQueryService) {
        this.friendshipQueryService = friendshipQueryService;
    }

    /** GET: friends for current user */
    @QueryMapping
    public List<User> friends() {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        return friendshipQueryService.getFriends(userEmail);
    }

    /** GET: incoming friend requests */
    // @QueryMapping
    // public List<User> incomingFriendRequests() {
    // return friendshipQueryService.getIncomingFriendRequests(userEmail);
    // }
}
