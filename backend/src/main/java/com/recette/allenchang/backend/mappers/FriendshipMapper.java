package com.recette.allenchang.backend.mappers;

import com.recette.allenchang.backend.models.Friendship;
import com.recette.allenchang.backend.dto.responses.FriendshipResponse;

public class FriendshipMapper {

    public static FriendshipResponse toResponse(Friendship friendship) {
        return new FriendshipResponse(
                friendship.getUser().getId().toString(),
                friendship.getUser().getUsername(),
                friendship.getFriend().getId().toString(),
                friendship.getFriend().getUsername(),
                friendship.getStatus().name(),
                friendship.getCreatedAt().toString());
    }
}
