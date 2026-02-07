import Foundation

final class SavedRecipeService {
    static let shared = SavedRecipeService()

    func getSavedRecipes() async throws -> [RecipeResponse] {
        try await RecetteAPI.shared.get([RecipeResponse].self, path: "/api/saved-recipes")
    }

    func saveRecipe(recipeId: String) async throws {
        try await RecetteAPI.shared.postEmpty(path: "/api/saved-recipes/\(recipeId)")
    }

    func unsaveRecipe(recipeId: String) async throws {
        try await RecetteAPI.shared.delete(path: "/api/saved-recipes/\(recipeId)")
    }

    func checkSavedStatus(recipeId: String) async throws -> Bool {
        try await RecetteAPI.shared.get(Bool.self, path: "/api/saved-recipes/\(recipeId)/status")
    }
}
