import Foundation

final class RecipeService {
    static let shared = RecipeService()

    func getMine() async throws -> [RecipeResponse] {
        print("RecipeService: Calling GET /api/recipes/mine")
        let response = try await RecetteAPI.shared.get([RecipeResponse].self, path: "/api/recipes/mine")
        print("RecipeService: Received \(response.count) recipes")
        return response
    }

    func getMineFiltered(filter: FilterRecipesModel) async throws -> [RecipeResponse] {
        var query: [URLQueryItem] = []

        // /mine/filter?tag=a&tag=b
        for tag in filter.selectedTags.sorted() {
            query.append(URLQueryItem(name: "tag", value: tag))
        }

        // /mine/filter?difficulty=EASY&difficulty=HARD
        for diff in filter.selectedDifficulties {
            query.append(URLQueryItem(name: "difficulty", value: diff))
        }

        if let max = filter.maxCookTimeInMinutes?.minutesValue {
            query.append(URLQueryItem(name: "maxCookTimeInMinutes", value: String(max)))
        }

        return try await RecetteAPI.shared.get([RecipeResponse].self, path: "/api/recipes/mine/filter", queryItems: query)
    }

    func getById(_ id: String) async throws -> RecipeResponse {
        try await RecetteAPI.shared.get(RecipeResponse.self, path: "/api/recipes/\(id)")
    }

    func create(_ request: CreateRecipeRequest) async throws -> RecipeResponse {
        try await RecetteAPI.shared.post(RecipeResponse.self, path: "/api/recipes", body: request)
    }

    func update(id: String, request: UpdateRecipeRequest) async throws -> RecipeResponse {
        try await RecetteAPI.shared.put(RecipeResponse.self, path: "/api/recipes/\(id)", body: request)
    }

    func delete(id: String) async throws {
        try await RecetteAPI.shared.delete(path: "/api/recipes/\(id)")
    }

    func toggleVisibility(id: String, isPublic: Bool) async throws -> RecipeResponse {
        let queryItems = [URLQueryItem(name: "isPublic", value: "\(isPublic)")]
        return try await RecetteAPI.shared.patch(RecipeResponse.self, path: "/api/recipes/\(id)/visibility", queryItems: queryItems)
    }

    func updateImage(id: String, imageUrl: String) async throws -> RecipeResponse {
        let queryItems = [URLQueryItem(name: "imageUrl", value: imageUrl)]
        return try await RecetteAPI.shared.patch(RecipeResponse.self, path: "/api/recipes/\(id)/image", queryItems: queryItems)
    }
}
