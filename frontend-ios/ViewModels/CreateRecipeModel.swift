import SwiftUI
import Foundation

class CreateRecipeModel: BaseRecipe {
    
    /* Send recipe details to backend to save */
    func saveRecipe(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let error = validate() {
            completion(.failure(error))
            return
        }

        Task {
            do {
                var imageUrlString: String? = nil
                if let image = selectedImage {
                    imageUrlString = try await S3Manager.uploadImage(image)
                }

                let requestIngredients = ingredients.map {
                    IngredientDTO(name: $0.name, measurement: $0.measurement)
                }

                /** Clean steps */
                let cleanedSteps = steps
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }

                let request = CreateRecipeRequest(
                    title: title,
                    description: description,
                    imageurl: imageUrlString,
                    ingredients: requestIngredients,
                    steps: cleanedSteps,
                    tags: Array(selectedTags),
                    difficulty: difficulty,
                    servingSize: servingSize,
                    cookTimeInMinutes: cookTimeInMinutes,
                    isPublic: isPublic
                )

                print("CreateRecipeModel: Creating recipe via REST API...")
                _ = try await RecipeService.shared.create(request)
                print("CreateRecipeModel: Recipe created successfully")
                completion(.success(()))
            } catch {
                print("CreateRecipeModel ERROR: \(error)")
                completion(.failure(error))
            }
        }
    }
}




