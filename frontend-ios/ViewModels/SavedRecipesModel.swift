import Foundation

@MainActor
class SavedRecipesModel: ObservableObject {
    @Published var recipes: [SocialRecipeItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadSavedRecipes() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let dtos = try await SavedRecipeService.shared.getSavedRecipes()
                self.recipes = dtos.map { dto in
                    SocialRecipeItem(
                        id: dto.id,
                        title: dto.title,
                        description: dto.description,
                        imageurl: dto.imageurl,
                        difficulty: dto.difficulty,
                        servingSize: dto.servingSize,
                        cookTimeInMinutes: dto.cookTimeInMinutes,
                        ownerUsername: dto.owner?.username ?? "Unknown",
                        ownerFirstName: dto.owner?.firstName,
                        ownerLastName: dto.owner?.lastName,
                        isSaved: true
                    )
                }
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func unsaveRecipe(recipeId: String) {
        Task {
            do {
                try await SavedRecipeService.shared.unsaveRecipe(recipeId: recipeId)
                recipes.removeAll { $0.id == recipeId }
            } catch {
                print("Failed to unsave: \(error)")
            }
        }
    }
}
