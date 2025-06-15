import SwiftUI

struct RecipeDetails: Identifiable, Equatable {
    let id: String
    var title: String
    var description: String
    var imageurl: String?
    var ingredients: [Ingredient]
    var steps: [String]
    var tags: [String]
}

class RecipeDetailsModel: ObservableObject {
    @Published var recipe: RecipeDetails?
    @Published var selectedImage: UIImage?

    let recipeId: String
    init(recipeId: String) {
        self.recipeId = recipeId
    }

    
    func loadRecipe() {
        let query = RecetteSchema.GetRecipeByIDQuery(id: RecetteSchema.ID(recipeId))
        Network.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let graphQLResult):
                    if let gql = graphQLResult.data?.recipeById {
                        self.recipe = RecipeDetails(
                            id: gql.id,
                            title: gql.title,
                            description: gql.description,
                            imageurl: gql.imageurl,
                            ingredients: gql.ingredients.map {
                                Ingredient(name: $0.name, measurement: $0.measurement)
                            },
                            steps: gql.steps,
                            tags: gql.tags.map { $0.name }
                        )
                    }
                case .failure(let error):
                    print("Failed to load recipe: \(error)")
                }
            }
        }
    }

    func deleteRecipe(completion: @escaping (Bool) -> Void) {
            if let imageurl = recipe?.imageurl {
                S3Manager.deleteImage(at: imageurl)
            }

            let mutation = RecetteSchema.DeleteRecipeMutation(id: RecetteSchema.ID(recipeId))
            Network.shared.apollo.perform(mutation: mutation) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let gqlResult):
                        completion(gqlResult.data?.deleteRecipe == true)
                    case .failure:
                        completion(false)
                    }
                }
            }
        }

        func updateRecipeImage(image: UIImage, email: String, completion: @escaping (Bool) -> Void) {
            Task {
                do {
                    let imageurl = try await S3Manager.uploadImage(image)
                    let mutation = RecetteSchema.UpdateRecipeImageMutation(
                        recipeId: RecetteSchema.ID(recipeId),
                        imageurl: imageurl
                    )

                    Network.shared.apollo.perform(mutation: mutation) { result in
                        switch result {
                        case .success(let gqlResult):
                            if gqlResult.errors == nil {
                                DispatchQueue.main.async {
                                    self.loadRecipe()
                                    completion(true)
                                }
                            } else {
                                completion(false)
                            }
                        case .failure:
                            completion(false)
                        }
                    }
                } catch {
                    completion(false)
                }
            }
        }
}

struct SelectedRecipe: Identifiable {
    let id: String
}
