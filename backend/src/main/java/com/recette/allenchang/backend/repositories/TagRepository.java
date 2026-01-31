package com.recette.allenchang.backend.repositories;

import com.recette.allenchang.backend.models.*;

import com.recette.allenchang.backend.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface TagRepository extends JpaRepository<Tag, UUID> {
    List<Tag> findByUser(User user);

    Optional<Tag> findByName(String name);

    boolean existsByUserAndName(User user, String name);

    Optional<Tag> findByUserAndName(User user, String name);
}
