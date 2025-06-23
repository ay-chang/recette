import SwiftUI
import Foundation

class EditRecipeModel: BaseRecipe {
    let id: String
    var imageurl: String?

    init(recipe: RecipeDetails) {
        self.id = recipe.id
        super.init()
        self.title = recipe.title
        self.description = recipe.description
        self.imageurl = recipe.imageurl
        self.steps = recipe.steps
        self.ingredients = recipe.ingredients
        self.selectedTags = Set(recipe.tags)
        self.difficulty = recipe.difficulty
        self.servingSize = recipe.servingSize ?? 0
        self.cookTimeInMinutes = recipe.cookTimeInMinutes ?? 0
    }

    func updateRecipe(
        onSuccess: (() -> Void)? = nil,
        onError: ((ValidationError) -> Void)? = nil
    ) {
        if let error = validate() {
            onError?(error)
            return
        }

        Task.detached { [self] in
            if let selectedImage {
                if let oldImageUrl = self.imageurl {
                    S3Manager.deleteImage(at: oldImageUrl)
                }

                do {
                    let newImageUrl = try await S3Manager.uploadImage(selectedImage)
                    await MainActor.run {
                        self.imageurl = newImageUrl
                        self.performGraphQLUpdate(completion: onSuccess)
                    }
                } catch {
                    print("Image upload failed: \(error)")
                }
            } else {
                await MainActor.run {
                    self.performGraphQLUpdate(completion: onSuccess)
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
            tags: .some(Array(selectedTags)),
            difficulty: difficulty != nil ? .some(difficulty!) : .null,
            servingSize: .some(servingSize),
            cookTimeInMinutes: .some(cookTimeInMinutes)
        )

        let mutation = RecetteSchema.UpdateRecipeMutation(input: input)

        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.data?.updateRecipe != nil {
                    print("Updated recipe")
                    completion?()
                } else if let errors = graphQLResult.errors {
                    print("GraphQL Errors: \(errors)")
                }
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
            }
        }
    }
}

    
    

