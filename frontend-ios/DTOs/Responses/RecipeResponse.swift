import Foundation

struct RecipeResponse: Codable {
    let id: String
    let title: String
    let description: String
    let imageurl: String?
    let ingredients: [IngredientDTO]
    let steps: [String]
    let tags: [String]
    let difficulty: String?
    let servingSize: Int?
    let cookTimeInMinutes: Int?
    let isPublic: Bool?
    let owner: UserResponse?
    let isSavedByCurrentUser: Bool?
}