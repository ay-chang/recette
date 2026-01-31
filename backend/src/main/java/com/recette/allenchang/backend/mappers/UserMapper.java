package com.recette.allenchang.backend.mappers;

import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.dto.responses.UserResponse;

public class UserMapper {

    public static UserResponse toResponse(User user) {
        return new UserResponse(
            user.getId().toString(),
            user.getUsername(),
            user.getEmail(),
            user.getFirstName(),
            user.getLastName()
        );
    }
}
