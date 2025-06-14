import SwiftUI

/**
 * This files controls whether the basic list or recipe cards list appears. It
 * also loads the recipe into a state variable "recipes" which is passed into
 * the either the recipe list view or recipe card view 
 */

struct RecipesView: View {
    @EnvironmentObject var session: UserSession
    @State private var isListView = false
    @State var recipes: [RecetteSchema.GetUserRecipesFullDetailsQuery.Data.UserRecipe] = []
    @State private var hasLoaded = false
    
    var body: some View {
        VStack {
            MenuBar(isListView: $isListView)
                
            // Decide whether to display list or image view
            if isListView { RecipeListView(recipes: recipes) } else { RecipeCardListView(recipes: recipes) }
        
            Spacer()
        }
        .onAppear {
            if !hasLoaded {
                loadRecipes()
                hasLoaded = true
            }
        }
        .onChange(of: session.shouldRefreshRecipes) {
            if session.shouldRefreshRecipes {
                hasLoaded = false
                loadRecipes()
                session.shouldRefreshRecipes = false
            }
        }
    }
    
    
    /**
     * Loads the full recipe details. By default, Apollo Client uses cache-first fetching,
     * meaning it will: First return cached data (from memory) Only make a network call if
     * cache is empty. This is great for performance, but bad if we just created or deleted
     * data — because we might get stale results.
     */
    func loadRecipes() {
        print("Loading recipes")
        guard let email = session.userEmail else { return }
        let getUserRecipesQuery = RecetteSchema.GetUserRecipesFullDetailsQuery(email: email)
        
        /**
         * This tells Apollo:
         * “Don’t trust your cache — always go to the server.”
         * That’s why the new recipe shows up, it forced Apollo to re-query the backend,
         * which returned the up-to-date recipe list.
         */
        Network.shared.apollo.fetch(
            query: getUserRecipesQuery,
            cachePolicy: .fetchIgnoringCacheCompletely // force latest data
        ) { result in
            switch result {
            case .success(let graphQLResult):
                if let data = graphQLResult.data?.userRecipes {
                    self.recipes = data.compactMap { $0 }
                } else {
                    print("GraphQL error: \(graphQLResult.errors?.first?.message ?? "Unknown error")")
                }
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
            }
        }
    }
}


struct SelectedRecipe: Identifiable {
    let id: String
}
