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

                let gqlIngredients = ingredients.map {
                    RecetteSchema.IngredientInput(name: $0.name, measurement: $0.measurement)
                }

                let input = RecetteSchema.RecipeInput(
                    title: title,
                    description: description,
                    imageurl: imageUrlString != nil ? .some(imageUrlString!) : .null,
                    ingredients: gqlIngredients,
                    steps: steps,
                    user: RecetteSchema.UserInput(email: email),
                    tags: .some(Array(selectedTags)),
                    difficulty: difficulty.isEmpty ? .null : .some(difficulty),
                    cookTimeInMinutes: .some(cookTimeInMinutes),
                    servingSize: .some(servingSize)
                )

                let mutation = RecetteSchema.AddRecipeMutation(input: input)

                Network.shared.apollo.perform(mutation: mutation) { result in
                    switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            print("GraphQL Errors:", errors)
                            completion(.failure(ValidationError("GraphQL error: \(errors.first?.message ?? "Unknown error")")))
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




