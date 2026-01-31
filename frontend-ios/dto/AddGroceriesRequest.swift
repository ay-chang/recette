import Foundation

struct AddGroceriesRequest: Codable {
    let groceries: [GroceryInput]
    let recipeId: String?
}
