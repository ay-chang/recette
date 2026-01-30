import Foundation

struct UpdateRecipeRequest: Codable {
    let title: String
    let description: String
    let imageurl: String?
    let ingredients: [IngredientDTO]
    let steps: [String]
    let tags: [String]
    let difficulty: String?
    let servingSize: Int?
    let cookTimeInMinutes: Int?
}