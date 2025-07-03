import SwiftUI

/**
 * This files controls whether the basic list or recipe cards list appears. It
 * also loads the recipe into a state variable "recipes" which is passed into
 * the either the recipe list view or recipe card view 
 */

struct RecipesView: View {
    @EnvironmentObject var session: UserSession
    @State private var isListView = false
    @StateObject private var model = RecipeListModel()
    @State private var hasLoaded = false
    @State private var showFilterSheet = false
    
    var body: some View {
        VStack (spacing: 0){
            MenuBar(isListView: $isListView, showFilterSheet: $showFilterSheet)
                
            // Decide whether to display list or image view
            if isListView {
                RecipeListView(recipes: model.recipes)
            } else {
                RecipeCardListView(recipes: model.recipes)
            }
        
            Spacer()
        }
        .onAppear {
            if let email = session.userEmail {
                model.loadRecipes(email: email)
            }
        }
        .onChange(of: session.shouldRefreshRecipes) {
            if session.shouldRefreshRecipes {
                if let email = session.userEmail {
                    model.loadRecipes(email: email)
                    session.shouldRefreshRecipes = false
                }
            }
        }
    }
}
