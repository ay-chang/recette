import Foundation

final class GroceryService {
    static let shared = GroceryService()

    func getMyGroceries() async throws -> [GroceryResponse] {
        return try await RecetteAPI.shared.get([GroceryResponse].self, path: "/api/groceries/mine")
    }

    func addGroceries(groceries: [GroceryInput], recipeId: String?) async throws -> [GroceryResponse] {
        let request = AddGroceriesRequest(groceries: groceries, recipeId: recipeId)
        return try await RecetteAPI.shared.post([GroceryResponse].self, path: "/api/groceries", body: request)
    }

    func toggleGroceryCheck(id: String, checked: Bool) async throws -> GroceryResponse {
        let queryItems = [URLQueryItem(name: "checked", value: "\(checked)")]
        return try await RecetteAPI.shared.patch(GroceryResponse.self, path: "/api/groceries/\(id)/toggle", queryItems: queryItems)
    }

    func removeRecipeFromGroceries(recipeId: String) async throws {
        try await RecetteAPI.shared.delete(path: "/api/groceries/recipe/\(recipeId)")
    }
}
