import Foundation

final class SocialService {
    static let shared = SocialService()

    func getFriendsFeed() async throws -> [RecipeResponse] {
        try await RecetteAPI.shared.get([RecipeResponse].self, path: "/api/social/feed")
    }

    func getPublicRecipe(id: String) async throws -> RecipeResponse {
        try await RecetteAPI.shared.get(RecipeResponse.self, path: "/api/social/recipe/\(id)")
    }
}
