package com.recette.allenchang.backend.controllers;

import com.recette.allenchang.backend.models.Tag;
import com.recette.allenchang.backend.services.TagService;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class TagController {

  private final TagService tagService;

  public TagController(TagService tagService) {
    this.tagService = tagService;
  }

  @QueryMapping
  public List<Tag> userTags(@Argument String email) {
    return tagService.getTagsByUser(email);
  }

  @MutationMapping
  public Tag addTag(@Argument String email, @Argument String name) {
    return tagService.addTag(email, name);
  }

}
