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
    
    func loadUserTags(email: String) {
        let getUserTagsQuery = RecetteSchema.GetUserTagsQuery(email: email)
        
        Network.shared.apollo.fetch(query: getUserTagsQuery) { result in
            switch result {
            case .success(let graphQLResult):
                if let tags = graphQLResult.data?.userTags {
                    DispatchQueue.main.async {
                        self.availableTags = tags.map { $0.name }
                    }
                }
            case .failure(let error):
                print("Failed to load tags: \(error)")
            }
        }
    }
    
    func addTagToUser(email: String, tagName: String) {
        let addTagMutation = RecetteSchema.AddTagMutation(email: email, name: tagName)
        
        Network.shared.apollo.perform(mutation: addTagMutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let data = graphQLResult.data {
                    let newTag = data.addTag.name
                    DispatchQueue.main.async {
                        if !self.availableTags.contains(newTag) {
                            self.availableTags.append(newTag)
                        }
                        self.selectedTags.insert(newTag)
                    }
                } else if let errors = graphQLResult.errors {
                    print("GraphQL errors: \(errors)")
                }
            case .failure(let error):
                print("Failed to add tag: \(error)")
            }
        }
    }
    
    func validate() -> ValidationError? {
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            return ValidationError("Recipe title is required.")
        }
        
        if description.trimmingCharacters(in: .whitespaces).isEmpty {
            return ValidationError("Recipe description is required.")
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
        
        if steps.isEmpty {
            return ValidationError("At least one step is required.")
        }
        
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
