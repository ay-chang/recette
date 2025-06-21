package com.recette.allenchang.backend.resolvers.tags;

import java.util.List;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.models.Tag;
import com.recette.allenchang.backend.services.tags.TagsQueryService;

@Controller
public class TagsQueryResolver {
    private final TagsQueryService tagsQueryService;

    public TagsQueryResolver(TagsQueryService tagsQueryService) {
        this.tagsQueryService = tagsQueryService;
    }

    @QueryMapping
    public List<Tag> userTags(@Argument String email) {
        return tagsQueryService.getTagsByUser(email);
    }

}
