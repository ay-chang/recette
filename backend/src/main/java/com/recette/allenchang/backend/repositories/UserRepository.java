package com.recette.allenchang.backend.repositories;

import com.recette.allenchang.backend.models.*;

import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    Optional<User> findByAppleId(String appleId);

    boolean existsByUsername(String username);

    List<User> findByUsernameContainingIgnoreCaseAndEmailNot(String username, String email, Pageable pageable);
}
