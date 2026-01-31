package com.recette.allenchang.backend.models;

import java.io.Serializable;
import java.util.Objects;
import java.util.UUID;

public class FriendshipId implements Serializable {
    private UUID user;
    private UUID friend;

    public FriendshipId() {
    }

    public FriendshipId(UUID user, UUID friend) {
        this.user = user;
        this.friend = friend;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (!(o instanceof FriendshipId))
            return false;
        FriendshipId that = (FriendshipId) o;
        return Objects.equals(user, that.user) &&
                Objects.equals(friend, that.friend);
    }

    @Override
    public int hashCode() {
        return Objects.hash(user, friend);
    }

}
