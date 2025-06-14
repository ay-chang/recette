import SwiftUI
import Foundation

struct Ingredient: Identifiable {
    let id = UUID()
    var name: String
    var measurement: String
}

class CreateRecipeModel: ObservableObject, TagManageable {
    @Published var title: String = ""
    @Published var selectedImage: UIImage?
    @Published var ingredients: [Ingredient] = []
    @Published var steps: [String] = []
    @Published var selectedCategories: Set<String> = []
    @Published var description: String = ""
    @Published var availableTags: [String] = []
    @Published var selectedTags: Set<String> = []
    
    func loadUserTags(email: String) {
        print("loadUserTags called with email: \(email)")
        
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
                print("erroloading tags: \(error)")
            }
        }
    }

    func addTagToBackend(email: String, tagName: String) {
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
    
    /* Send recipe details to backend to save */
    func saveRecipe(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Check if a field is empty and notify the user
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
           completion(.failure(ValidationError("Recipe title is required.")))
           return
        }

        guard !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
           completion(.failure(ValidationError("Recipe description is required.")))
           return
        }

        guard !ingredients.isEmpty else {
           completion(.failure(ValidationError("At least one ingredient is required.")))
           return
        }

        guard !steps.isEmpty else {
           completion(.failure(ValidationError("At least one step is required.")))
           return
        }
        
        Task {
            do {
                // 1. Upload image if it exists
                var imageUrlString: String? = nil
                if let image = selectedImage {
                    imageUrlString = try await S3Manager.uploadImage(image)
                }

                // 2. Prepare inputs
                let ingredientsInput = ingredients.map { RecetteSchema.IngredientInput(name: $0.name, measurement: $0.measurement) }

                let input = RecetteSchema.RecipeInput(
                    title: title,
                    description: description,
                    imageurl: imageUrlString != nil ? .some(imageUrlString!) : .null,
                    ingredients: ingredientsInput,
                    steps: steps,
                    user: RecetteSchema.UserInput(email: email),
                    tags: .some(Array(selectedTags))
                )

                // 3. Call mutation
                let addRecipeMutation = RecetteSchema.AddRecipeMutation(input: input)

                Network.shared.apollo.perform(mutation: addRecipeMutation) { result in
                    switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "GraphQL error"])))
                        } else {
                            completion(.success(()))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

}

struct ValidationError: LocalizedError {
    let message: String
    init(_ message: String) { self.message = message }
    var errorDescription: String? { message }
}


