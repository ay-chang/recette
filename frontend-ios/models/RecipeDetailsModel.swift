import SwiftUI

class RecipeDetailsModel: ObservableObject {
    @Published var recipe: RecetteSchema.GetRecipeByIDQuery.Data.RecipeById?
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil
    @Published var selectedImage: UIImage?

    let recipeId: String
    init(recipeId: String) {
        self.recipeId = recipeId
    }

    func loadRecipe() {
        isLoading = true
        errorMessage = nil

        let query = RecetteSchema.GetRecipeByIDQuery(id: RecetteSchema.ID(recipeId))
        Network.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let graphQLResult):
                    self.recipe = graphQLResult.data?.recipeById
                    self.errorMessage = self.recipe == nil ? "No recipe found." : nil
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }
    }

    func deleteRecipe(completion: @escaping (Bool) -> Void) {
        // First delete the image from S3 if recipe has an image
        if let imageurl = recipe?.imageurl {
            S3Manager.deleteImage(at: imageurl)
        }

        let mutation = RecetteSchema.DeleteRecipeMutation(id: RecetteSchema.ID(recipeId))
        Network.shared.apollo.perform(mutation: mutation) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let graphQLResult):
                    completion(graphQLResult.data?.deleteRecipe == true)
                case .failure(let error):
                    print("Delete error: \(error)")
                    completion(false)
                }
            }
        }
    }

    func updateRecipeImage(image: UIImage, email: String, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                // Upload to S3
                let imageUrl = try await S3Manager.uploadImage(image)
                print("Uploaded image to S3: \(imageUrl)")

                // Prepare GraphQL mutation
                let mutation = RecetteSchema.UpdateRecipeImageMutation(
                    recipeId: RecetteSchema.ID(recipeId),
                    imageurl: imageUrl
                )

                Network.shared.apollo.perform(mutation: mutation) { result in
                    switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            print("GraphQL errors: \(errors)")
                            completion(false)
                        } else {
                            print("GraphQL mutation succeeded")
                            self.loadRecipe() // refresh the recipe
                            completion(true)
                        }
                    case .failure(let error):
                        print("Network error: \(error.localizedDescription)")
                        completion(false)
                    }
                }
            } catch {
                print("Failed to upload image: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    

}
