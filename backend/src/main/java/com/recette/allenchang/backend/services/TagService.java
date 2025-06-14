package com.recette.allenchang.backend.services;

import com.recette.allenchang.backend.models.Tag;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.TagRepository;
import com.recette.allenchang.backend.repositories.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TagService {
  private final TagRepository tagRepository;
  private final UserRepository userRepository;

  public TagService(TagRepository tagRepository, UserRepository userRepository) {
    this.tagRepository = tagRepository;
    this.userRepository = userRepository;
  }

  public List<Tag> getTagsByUser(String email) {
    User user = userRepository.findByEmail(email)
        .orElseThrow(() -> new IllegalArgumentException("User not found with email: " + email));
    return tagRepository.findByUser(user);
  }

  public Tag addTag(String email, String tagName) {
    User user = userRepository.findByEmail(email)
        .orElseThrow(() -> new IllegalArgumentException("User not found with email: " + email));
    if (tagRepository.existsByUserAndName(user, tagName)) {
      throw new IllegalArgumentException("Tag already exists for this user: " + tagName);
    }

    Tag tag = new Tag(tagName, user);
    return tagRepository.save(tag);
  }
}
