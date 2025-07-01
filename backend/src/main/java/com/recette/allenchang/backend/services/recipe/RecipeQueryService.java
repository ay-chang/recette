package com.recette.allenchang.backend.services.recipe;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.recette.allenchang.backend.inputs.RecipeFilterInput;
import com.recette.allenchang.backend.models.Recipe;
import com.recette.allenchang.backend.repositories.RecipeRepository;
import com.recette.allenchang.backend.repositories.UserRepository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.criteria.*;

@Service
public class RecipeQueryService {
    private final RecipeRepository recipeRepository;
    private final UserRepository userRepository;

    @PersistenceContext
    private EntityManager entityManager;

    public RecipeQueryService(RecipeRepository recipeRepository, UserRepository userRepository) {
        this.recipeRepository = recipeRepository;
        this.userRepository = userRepository;
    }

    /** Returns a list of all recipes */
    public List<Recipe> getAllRecipes() {
        return recipeRepository.findAll();
    }

    /** Returns all recipes for user with matching email */
    public List<Recipe> getRecipesByUserEmail(String email) {
        return userRepository.findByEmail(email)
                .map(user -> recipeRepository.findByUserId(user.getId()))
                .orElse(List.of());
    }

    /** Take a recipe id as an arg and returns a single Recipe */
    public Recipe getRecipeById(String id) {
        return recipeRepository.findById(Integer.parseInt(id)).orElse(null);
    }

    /**
     * Return recipes owned by a user, applies optional filters, currently tags
     * difficulties, and maxCookTimeInMinutes. We fetch the user tags efficiently
     * avoiding the (N + 1) problem and if there are no filters, return all recipes
     * owned by the user
     */
    public List<Recipe> getUserFilteredRecipes(String email, RecipeFilterInput recipeFilterInput) {
        return userRepository.findByEmail(email).map(user -> {
            /**
             * CriteriaBuilder is used to construct conditions (predicates), ordering, etc.
             * CriteriaQuery<Recipe> means that the query will return Recipe objects.
             * Root<Recipe> is the base table (or entity) for your query, we can think of it
             * as FROM Recipe.
             */
            CriteriaBuilder cb = entityManager.getCriteriaBuilder();
            CriteriaQuery<Recipe> query = cb.createQuery(Recipe.class);
            Root<Recipe> root = query.from(Recipe.class);

            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("user").get("id"), user.getId()));

            if (recipeFilterInput.getDifficulties() != null && !recipeFilterInput.getDifficulties().isEmpty()) {
                predicates.add(root.get("difficulty").in(recipeFilterInput.getDifficulties()));
            }

            if (recipeFilterInput.getCookTimeInMinutes() != null) {
                predicates.add(
                        cb.lessThanOrEqualTo(root.get("cookTimeInMinutes"), recipeFilterInput.getCookTimeInMinutes()));
            }

            if (recipeFilterInput.getTags() != null && !recipeFilterInput.getTags().isEmpty()) {
                Join<Object, Object> tagJoin = root.join("tags", JoinType.INNER); // INNER join for filtering
                predicates.add(tagJoin.get("name").in(recipeFilterInput.getTags()));
                query.groupBy(root.get("id"));
                query.having(cb.equal(cb.countDistinct(tagJoin.get("name")), recipeFilterInput.getTags().size()));
            } else {
                root.fetch("tags", JoinType.LEFT); // Only fetch when no tag filter — to avoid duplicate join issue
            }

            query.select(root).where(predicates.toArray(new Predicate[0]));

            return entityManager.createQuery(query).getResultList();

        }).orElse(List.of());
    }

}
