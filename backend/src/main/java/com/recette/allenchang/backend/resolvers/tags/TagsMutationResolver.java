package com.recette.allenchang.backend.resolvers.tags;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.models.Tag;
import com.recette.allenchang.backend.services.tags.TagsMutationService;
import com.recette.allenchang.backend.security.JwtUtil;

@Controller
public class TagsMutationResolver {
    private final TagsMutationService tagsMutationService;

    public TagsMutationResolver(TagsMutationService tagsMutationService) {
        this.tagsMutationService = tagsMutationService;
    }

    @MutationMapping
    public Tag addTag(@Argument String name) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        return tagsMutationService.addTag(userEmail, name);
    }

    @MutationMapping
    public boolean deleteTag(@Argument String name) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        return tagsMutationService.deleteTag(userEmail, name);
    }
}
