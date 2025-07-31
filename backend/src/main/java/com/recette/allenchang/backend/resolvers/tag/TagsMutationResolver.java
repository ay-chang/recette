package com.recette.allenchang.backend.resolvers.tag;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.models.Tag;
import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.services.tag.TagMutationService;

@Controller
public class TagsMutationResolver {
    private final TagMutationService tagsMutationService;

    public TagsMutationResolver(TagMutationService tagsMutationService) {
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
