package com.recette.allenchang.backend.recipes.dto.requests;

import java.util.List;

/**
 * Request payload for filtering the authenticated user's recipes.
 * All fields are optional; null/empty lists mean no filtering on that field.
 */
public record FilterRecipeRequest(
                List<String> tags,
                List<String> difficulties,
                Integer maxCookTimeInMinutes) {
}
