package com.recette.allenchang.backend.controllers;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.services.*;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.recette.allenchang.backend.dto.requests.SendFriendRequestRequest;
import com.recette.allenchang.backend.dto.responses.FriendshipResponse;
import com.recette.allenchang.backend.mappers.FriendshipMapper;
import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.dto.responses.UserResponse;
import com.recette.allenchang.backend.mappers.UserMapper;

@RestController
@RequestMapping("/api/friendships")
public class FriendshipController {

    private final FriendshipMutationService friendshipMutationService;
    private final FriendshipQueryService friendshipQueryService;

    public FriendshipController(FriendshipMutationService friendshipMutationService,
            FriendshipQueryService friendshipQueryService) {
        this.friendshipMutationService = friendshipMutationService;
        this.friendshipQueryService = friendshipQueryService;
    }

    /** GET: Get list of friends for logged in user */
    @GetMapping("/friends")
    public List<UserResponse> getFriends() {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        List<User> friends = friendshipQueryService.getFriends(userEmail);
        return friends.stream()
                .map(UserMapper::toResponse)
                .toList();
    }

    /** GET: Get incoming friend requests for logged in user */
    @GetMapping("/requests")
    public List<UserResponse> getIncomingFriendRequests() {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        List<User> requests = friendshipQueryService.getIncomingFriendRequests(userEmail);
        return requests.stream()
                .map(UserMapper::toResponse)
                .toList();
    }

    /** POST: Send a friend request */
    @PostMapping("/send")
    public FriendshipResponse sendFriendRequest(@RequestBody SendFriendRequestRequest request) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        Friendship friendship = friendshipMutationService.sendFriendRequest(userEmail, request.friendUsername());
        return FriendshipMapper.toResponse(friendship);
    }

    /** POST: Accept a friend request */
    @PostMapping("/accept/{friendUsername}")
    public FriendshipResponse acceptFriendRequest(@PathVariable String friendUsername) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        Friendship friendship = friendshipMutationService.acceptFriendRequest(userEmail, friendUsername);
        return FriendshipMapper.toResponse(friendship);
    }

    /** DELETE: Decline a friend request */
    @DeleteMapping("/decline/{friendUsername}")
    public ResponseEntity<Void> declineFriendRequest(@PathVariable String friendUsername) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        friendshipMutationService.declineFriendRequest(userEmail, friendUsername);
        return ResponseEntity.noContent().build();
    }

    /** DELETE: Remove a friend */
    @DeleteMapping("/remove/{friendUsername}")
    public ResponseEntity<Void> removeFriend(@PathVariable String friendUsername) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        friendshipMutationService.removeFriend(userEmail, friendUsername);
        return ResponseEntity.noContent().build();
    }
}
