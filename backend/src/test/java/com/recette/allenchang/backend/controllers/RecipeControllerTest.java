// package com.recette.allenchang.backend.controllers;

// import static org.mockito.Mockito.*;
// import static org.junit.jupiter.api.Assertions.*;

// import com.recette.allenchang.backend.controllers.RecipeController;
// import com.recette.allenchang.backend.models.Recipe;
// import com.recette.allenchang.backend.repositories.RecipeRepository;
// import com.recette.allenchang.backend.services.RecipeService;
// import com.amazonaws.services.s3.AmazonS3;
// import org.junit.jupiter.api.BeforeEach;
// import org.junit.jupiter.api.Test;
// import org.mockito.InjectMocks;
// import org.mockito.Mock;
// import org.mockito.MockitoAnnotations;

// import java.util.List;
// import java.util.Optional;

// /*
// * To run each test individually in terminal use this:
// *
// * mvn test -Dtest=RecipeControllerTest#{TEST-CASE}
// *
// */

// class RecipeControllerTest {

// @Mock
// private RecipeRepository recipeRepository;

// @Mock
// private AmazonS3 amazonS3;

// private RecipeController recipeController;

// private Recipe sampleRecipe;

// @BeforeEach
// void setUp() {
// MockitoAnnotations.openMocks(this);

// // Inject mocks into controller manually
// RecipeService recipeService = new RecipeService(recipeRepository);
// RecipeController controller = new RecipeController(recipeService);

// // Create a sample recipe
// sampleRecipe = new Recipe();
// sampleRecipe.setTitle("Chocolate Cake");
// }

// @Test
// void testGetAllRecipes() {
// when(recipeRepository.findAll()).thenReturn(List.of(sampleRecipe));

// List<Recipe> recipes = recipeController.recipes();

// System.out.println("\n\nTesting retrieval of all recipes...\n\n");
// System.out.println("Recipes returned: " + recipes.size());

// assertNotNull(recipes, "\n\nThe returned recipe list should not be
// null.\n\n");
// assertEquals(1, recipes.size(), "\n\nExpected one recipe in the list.\n\n");
// assertEquals("Chocolate Cake", recipes.get(0).getTitle(), "\n\nRecipe title
// does not match.\n\n");

// verify(recipeRepository, times(1)).findAll();
// System.out.println("\n\nSUCCESS: testGetAllRecipes passed!\n\n");
// }

// /**
// * Test fetching a recipe by ID
// */
// @Test
// void testGetRecipeById() {
// when(recipeRepository.findById(1)).thenReturn(Optional.of(sampleRecipe));

// Recipe recipe = recipeController.recipeById(1);

// System.out.println("\n\nTesting getting Recipe by ID");

// assertNotNull(recipe);
// assertEquals("Chocolate Cake", recipe.getTitle(), "\n\nRecipe ID does not
// match\n\n");

// verify(recipeRepository, times(1)).findById(1);
// System.out.println("\n\nSUCCESS: testGetRecipeById passed!\n\n");
// }

// /**
// * Test fetching a recipe by ID when not found
// */
// @Test
// void testGetRecipeById_NotFound() {
// when(recipeRepository.findById(99)).thenReturn(Optional.empty());

// Recipe recipe = recipeController.recipeById(99);

// assertNull(recipe);
// verify(recipeRepository, times(1)).findById(99);
// }
// }
