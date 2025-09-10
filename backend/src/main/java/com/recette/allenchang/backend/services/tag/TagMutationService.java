package com.recette.allenchang.backend.services.tag;

import java.util.List;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.exceptions.DuplicateTagException;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.models.Tag;
import com.recette.allenchang.backend.models.User;
import com.recette.allenchang.backend.repositories.TagRepository;
import com.recette.allenchang.backend.repositories.UserRepository;
import com.recette.allenchang.backend.repositories.RecipeRepository;

import jakarta.transaction.Transactional;

@Service
public class TagMutationService {
    private final TagRepository tagRepository;
    private final UserRepository userRepository;
    private final RecipeRepository recipeRepository;

    public TagMutationService(TagRepository tagRepository, UserRepository userRepository,
            RecipeRepository recipeRepository) {
        this.tagRepository = tagRepository;
        this.userRepository = userRepository;
        this.recipeRepository = recipeRepository;
    }

    public Tag addTag(String email, String tagName) {
        User user = userRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("User not found with email: " + email));
        if (tagRepository.existsByUserAndName(user, tagName)) {
            throw new DuplicateTagException("Tag already exists for this user: " + tagName);
        }
        Tag tag = new Tag(tagName, user);
        return tagRepository.save(tag);
    }

    @Transactional
    public boolean deleteTag(String email, String tagName) {
        User user = userRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("User not found with email: " + email));

        Tag tag = tagRepository.findByUserAndName(user, tagName)
                .orElseThrow(() -> new IllegalArgumentException("Tag not found for user: " + tagName));

        /** Remove this tag from all recipes that contain it */
        List<Recipe> recipesWithTag = recipeRepository.findAllByTagsContaining(tag);
        for (Recipe recipe : recipesWithTag) {
            recipe.getTags().remove(tag);
        }
        recipeRepository.saveAll(recipesWithTag); // persist the changes

        tagRepository.delete(tag); // now it's safe to delete the tag

        return true;
    }

}
