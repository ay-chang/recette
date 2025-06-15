import SwiftUI
import Foundation

class EditRecipeModel: ObservableObject, TagManageable {
    @Published var title: String
    @Published var description: String
    @Published var imageurl: String?
    @Published var selectedImage: UIImage? = nil
    @Published var steps: [String] = []
    @Published var ingredients: [Ingredient] = []
    @Published var selectedTags: Set<String>
    @Published var availableTags: [String] = []

    
    let id: String // Immutable, used for mutation
    
    init(recipe: RecetteSchema.GetRecipeByIDQuery.Data.RecipeById) {
        self.id = recipe.id
        self.title = recipe.title
        self.description = recipe.description
        self.imageurl = recipe.imageurl
        self.steps = recipe.steps
        self.ingredients = recipe.ingredients.map {
            Ingredient(name: $0.name, measurement: $0.measurement)
        }
        self.selectedTags = Set(recipe.tags.compactMap { $0.name })
    }
    
    func updateRecipe(completion: (() -> Void)? = nil) {
        let selectedImage = self.selectedImage
        let oldImageUrl = self.imageurl
        
        Task.detached(priority: nil) {
            if let selectedImage {
                if let oldImageUrl {
                    print("Selected Image: \(selectedImage)")
                    print("Old Image: \(oldImageUrl)")
                    
                    S3Manager.deleteImage(at: oldImageUrl)
                }

                do {
                    let newImageUrl = try await S3Manager.uploadImage(selectedImage)
                    await MainActor.run {
                        self.imageurl = newImageUrl
                        self.performGraphQLUpdate(completion: completion)
                    }
                } catch {
                    print("Image upload failed: \(error)")
                }
            } else {
                await MainActor.run {
                    self.performGraphQLUpdate(completion: completion)
                }
            }
        }
    }

    
    private func performGraphQLUpdate(completion: (() -> Void)? = nil) {
        let gqlIngredients = ingredients.map {
            RecetteSchema.IngredientInput(name: $0.name, measurement: $0.measurement)
        }

        let input = RecetteSchema.UpdateRecipeInput(
            id: id,
            title: title,
            description: description,
            imageurl: imageurl != nil ? .some(imageurl!) : .null,
            ingredients: gqlIngredients,
            steps: steps,
            tags: .some(Array(selectedTags))
        )

        let mutation = RecetteSchema.UpdateRecipeMutation(input: input)

        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let updatedRecipe = graphQLResult.data?.updateRecipe {
                    print("Updated recipe: \(updatedRecipe)")
                    completion?()
                } else if let errors = graphQLResult.errors {
                    print("GraphQL Errors: \(errors)")
                }
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
            }
        }
    }

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
    
    
}
