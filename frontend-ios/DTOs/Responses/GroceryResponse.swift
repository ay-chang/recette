import Foundation

struct GroceryResponse: Codable {
    let id: String
    let name: String
    let measurement: String
    let checked: Bool
    let recipeId: String?
    let recipeTitle: String
}
