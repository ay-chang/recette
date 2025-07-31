package com.recette.allenchang.backend.services.tag;

import java.util.List;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.models.Tag;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.TagRepository;
import com.recette.allenchang.backend.repositories.UserRepository;

@Service
public class TagQueryService {
    private final TagRepository tagRepository;
    private final UserRepository userRepository;

    public TagQueryService(TagRepository tagRepository, UserRepository userRepository) {
        this.tagRepository = tagRepository;
        this.userRepository = userRepository;
    }

    public List<Tag> getTagsByUser(String email) {
        User user = userRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("User not found with email: " + email));
        return tagRepository.findByUser(user);
    }
}
