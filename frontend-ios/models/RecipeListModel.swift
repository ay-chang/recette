import Foundation

struct RecipeListItems: Identifiable {
    let id: String
    var title: String
    var description: String
    var imageurl: String?
    var difficulty: String?
    var servingSize: Int?
    var cookTimeInMinutes: Int?
}

class RecipeListModel: ObservableObject {
    @Published var recipes: [RecipeListItems] = []
    @Published var errorMessage: String?

    /**
     * Loads the full recipe details. By default, Apollo Client uses cache-first fetching,
     * meaning it will: First return cached data (from memory) Only make a network call if
     * cache is empty. This is great for performance, but bad if we just created or deleted
     * data — because we might get stale results.
     */
    func loadRecipes(email: String) {
        errorMessage = nil

        let query = RecetteSchema.GetUserRecipesFullDetailsQuery(email: email)
        
        /**
         * This tells Apollo:
         * Don’t trust cache — always go to the server.
         * That’s why the new recipe shows up, it forced Apollo to re-query the backend,
         * which returned the up-to-date recipe list.
         */
        Network.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            DispatchQueue.main.async {

                switch result {
                case .success(let graphQLResult):
                    if let gqlRecipes = graphQLResult.data?.userRecipes {
                        self.recipes = gqlRecipes.map {
                            RecipeListItems(
                                id: $0.id,
                                title: $0.title,
                                description: $0.description,
                                imageurl: $0.imageurl,
                                difficulty: $0.difficulty,
                                servingSize: $0.servingSize,
                                cookTimeInMinutes: $0.cookTimeInMinutes
                            )
                        }
                    } else {
                        self.errorMessage = "Failed to load recipes."
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
