package com.recette.allenchang.backend.resolvers.tag;

import java.util.List;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import com.recette.allenchang.backend.models.Tag;
import com.recette.allenchang.backend.services.tag.TagQueryService;

@Controller
public class TagsQueryResolver {
    private final TagQueryService tagsQueryService;

    public TagsQueryResolver(TagQueryService tagsQueryService) {
        this.tagsQueryService = tagsQueryService;
    }

    @QueryMapping
    public List<Tag> userTags(@Argument String email) {
        return tagsQueryService.getTagsByUser(email);
    }

}
