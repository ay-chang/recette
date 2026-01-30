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
        let requestIngredients = ingredients.map {
            IngredientDTO(name: $0.name, measurement: $0.measurement)
        }

        let request = UpdateRecipeRequest(
            title: title,
            description: description,
            imageurl: imageurl,
            ingredients: requestIngredients,
            steps: steps,
            tags: Array(selectedTags),
            difficulty: difficulty,
            servingSize: servingSize,
            cookTimeInMinutes: cookTimeInMinutes
        )

        Task {
            do {
                print("EditRecipeModel: Updating recipe via REST API...")
                _ = try await RecipeService.shared.update(id: id, request: request)
                print("EditRecipeModel: Recipe updated successfully")
                await MainActor.run {
                    completion?()
                }
            } catch {
                print("EditRecipeModel ERROR: \(error)")
            }
        }
    }
}

    
    

