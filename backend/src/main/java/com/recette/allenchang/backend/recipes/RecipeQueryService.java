package com.recette.allenchang.backend.recipes;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import com.recette.allenchang.backend.inputs.RecipeFilterInput;
import com.recette.allenchang.backend.models.Recipe;
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
    public List<Recipe> mine(String email) {
        return userRepository.findByEmail(email.toLowerCase())
                .map(user -> recipeRepository.findByUserId(
                        user.getId(),
                        Sort.by(Sort.Direction.DESC, "createdAt")))
                .orElse(List.of());
    }

    /** Take a recipe id as an arg and returns a single Recipe */
    public Recipe getRecipeById(UUID id) {
        return recipeRepository.findById(id).orElse(null);
    }

    /**
     * Return recipes owned by a user, applies optional filters, currently tags
     * difficulties, and maxCookTimeInMinutes. We fetch the user tags efficiently
     * avoiding the (N + 1) problem and if there are no filters, return all recipes
     * owned by the user
     */
    public List<Recipe> getUserFilteredRecipes(String email, RecipeFilterInput recipeFilterInput) {
        return userRepository.findByEmail(email.toLowerCase()).map(user -> {
            CriteriaBuilder cb = entityManager.getCriteriaBuilder();
            CriteriaQuery<Recipe> query = cb.createQuery(Recipe.class);
            Root<Recipe> root = query.from(Recipe.class);

            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("user").get("id"), user.getId()));

            if (recipeFilterInput.getDifficulties() != null && !recipeFilterInput.getDifficulties().isEmpty()) {
                predicates.add(root.get("difficulty").in(recipeFilterInput.getDifficulties()));
            }

            if (recipeFilterInput.getMaxCookTimeInMinutes() != null) {
                predicates.add(
                        cb.lessThanOrEqualTo(root.get("cookTimeInMinutes"),
                                recipeFilterInput.getMaxCookTimeInMinutes()));
            }

            if (recipeFilterInput.getTags() != null && !recipeFilterInput.getTags().isEmpty()) {
                Join<Object, Object> tagJoin = root.join("tags", JoinType.INNER); // INNER join for filtering
                predicates.add(tagJoin.get("name").in(recipeFilterInput.getTags()));
                // OR behavior: do not group or use having — this will include any recipe with
                // any of the tags
            } else {
                root.fetch("tags", JoinType.LEFT);
            }

            query.select(root).where(cb.and(predicates.toArray(new Predicate[0]))).distinct(true);
            return entityManager.createQuery(query).getResultList();
        }).orElse(List.of());
    }

}
