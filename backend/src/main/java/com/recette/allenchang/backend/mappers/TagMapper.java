package com.recette.allenchang.backend.mappers;

import com.recette.allenchang.backend.models.Tag;
import com.recette.allenchang.backend.dto.responses.TagResponse;

public class TagMapper {

    public static TagResponse toResponse(Tag tag) {
        return new TagResponse(
            tag.getId().toString(),
            tag.getName()
        );
    }
}
