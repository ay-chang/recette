package com.recette.allenchang.backend.repositories;

/* 
 * Remember, a repository is how Spring allows us interact with the database. We can think
 * of it as a helper that writes SQL for us. It talks to the entities (models) and the 
 * database tables under the hood.
 */

import com.recette.allenchang.backend.models.Tag;
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
