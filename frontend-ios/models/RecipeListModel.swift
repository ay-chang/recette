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
    func loadAllUserRecipes(email: String) {
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
    
    func loadFilteredRecipes(email: String, filter: FilterRecipesModel) {
        errorMessage = nil

        let gqlFilterInput = RecetteSchema.RecipeFilterInput(
            tags: filter.selectedTags.isEmpty ? nil : .some(Array(filter.selectedTags)),
            maxCookTimeInMinutes: filter.maxCookTimeInMinutes != nil ? .some(filter.maxCookTimeInMinutes!.minutesValue) : nil,
            difficulties: filter.selectedDifficulties.isEmpty ? nil : .some(filter.selectedDifficulties)
        )

        let query = RecetteSchema.GetUserFilteredRecipesQuery(
            email: email,
            recipeFilterInput: gqlFilterInput
        )

        Network.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let graphQLResult):
                    if let gqlRecipes = graphQLResult.data?.filterUserRecipes {
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
                    } else if let errors = graphQLResult.errors {
                        self.errorMessage = errors.map { $0.localizedDescription }.joined(separator: "\n")
                    } else {
                        self.errorMessage = "No recipes found."
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

}

enum TimeOption: String, CaseIterable {
    case under30 = "30 mins or less"
    case under1 = "1 hour or less"
    case under2 = "2 hours or less"
    case over2 = "2+ hours"

    var minutesValue: Int {
        switch self {
        case .under30: return 30
        case .under1: return 60
        case .under2: return 120
        case .over2: return 10000
        }
    }
}

