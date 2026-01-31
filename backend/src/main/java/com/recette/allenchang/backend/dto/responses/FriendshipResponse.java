package com.recette.allenchang.backend.dto.responses;

public record FriendshipResponse(
    String userId,
    String userUsername,
    String friendId,
    String friendUsername,
    String status,
    String createdAt
) {
}
