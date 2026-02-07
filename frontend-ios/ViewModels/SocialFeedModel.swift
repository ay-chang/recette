import Foundation

struct SocialRecipeItem: Identifiable {
    let id: String
    let title: String
    let description: String
    let imageurl: String?
    let difficulty: String?
    let servingSize: Int?
    let cookTimeInMinutes: Int?
    let ownerUsername: String
    let ownerFirstName: String?
    let ownerLastName: String?
    var isSaved: Bool
}

@MainActor
class SocialFeedModel: ObservableObject {
    @Published var recipes: [SocialRecipeItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadFeed() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let dtos = try await SocialService.shared.getFriendsFeed()
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
                        isSaved: dto.isSavedByCurrentUser ?? false
                    )
                }
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func toggleSave(recipeId: String) {
        guard let index = recipes.firstIndex(where: { $0.id == recipeId }) else { return }
        let wasSaved = recipes[index].isSaved

        Task {
            do {
                if wasSaved {
                    try await SavedRecipeService.shared.unsaveRecipe(recipeId: recipeId)
                } else {
                    try await SavedRecipeService.shared.saveRecipe(recipeId: recipeId)
                }
                recipes[index].isSaved = !wasSaved
            } catch {
                print("Failed to toggle save: \(error)")
            }
        }
    }
}
