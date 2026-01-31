package com.recette.allenchang.backend.controllers;

import com.recette.allenchang.backend.models.*;
import com.recette.allenchang.backend.services.*;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.recette.allenchang.backend.models.Tag;
import com.recette.allenchang.backend.security.JwtUtil;
import com.recette.allenchang.backend.services.TagMutationService;
import com.recette.allenchang.backend.services.TagQueryService;
import com.recette.allenchang.backend.dto.requests.CreateTagRequest;
import com.recette.allenchang.backend.dto.responses.TagResponse;
import com.recette.allenchang.backend.mappers.TagMapper;

@RestController
@RequestMapping("/api/tags")
public class TagController {

    private final TagQueryService tagQueryService;
    private final TagMutationService tagMutationService;

    public TagController(TagQueryService tagQueryService, TagMutationService tagMutationService) {
        this.tagQueryService = tagQueryService;
        this.tagMutationService = tagMutationService;
    }

    @GetMapping("/mine")
    public List<TagResponse> getMyTags() {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        List<Tag> tags = tagQueryService.getTagsByUser(userEmail);
        return tags.stream()
                .map(TagMapper::toResponse)
                .collect(Collectors.toList());
    }

    @PostMapping
    public TagResponse createTag(@RequestBody CreateTagRequest request) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        Tag tag = tagMutationService.addTag(userEmail, request.name());
        return TagMapper.toResponse(tag);
    }

    @DeleteMapping("/{name}")
    public ResponseEntity<Void> deleteTag(@PathVariable String name) {
        String userEmail = JwtUtil.getLoggedInUserEmail();
        tagMutationService.deleteTag(userEmail, name);
        return ResponseEntity.noContent().build();
    }
}
