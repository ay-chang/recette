import SwiftUI
import Foundation

class BaseRecipe: ObservableObject, TagManageable {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedImage: UIImage?
    @Published var ingredients: [Ingredient] = []
    @Published var steps: [String] = []
    @Published var selectedTags: Set<String> = []
    @Published var availableTags: [String] = []
    @Published var difficulty: String? = nil
    @Published var servingSize: Int = 0
    @Published var cookTimeInMinutes: Int = 0
    @Published var isPublic: Bool = false
    
    func validate() -> ValidationError? {
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            return ValidationError("Recipe title is required.")
        }

        if ingredients.isEmpty {
            return ValidationError("At least one ingredient is required.")
        }
        
        for ingredient in ingredients {
                if ingredient.name.trimmingCharacters(in: .whitespaces).isEmpty ||
                    ingredient.measurement.trimmingCharacters(in: .whitespaces).isEmpty {
                    return ValidationError("Ingredient name or measurement cannot be empty.")
                }
            }
        
//        if steps.isEmpty {
//            return ValidationError("At least one step is required.")
//        }
        
        for step in steps {
            if step.trimmingCharacters(in: .whitespaces).isEmpty {
                return ValidationError("Step cannot be empty.")
            }
        }
        
        return nil
    }
}

struct ValidationError: LocalizedError {
    let message: String
    init(_ message: String) { self.message = message }
    var errorDescription: String? { message }
}
