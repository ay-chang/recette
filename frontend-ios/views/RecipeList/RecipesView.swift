import SwiftUI

/**
 * This files controls whether the basic list or recipe cards list appears. It
 * also loads the recipe into a state variable "recipes" which is passed into
 * the either the recipe list view or recipe card view 
 */

struct RecipesView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var model = RecipeListModel()
    @StateObject private var filterRecipesModel = FilterRecipesModel()
    @State private var isListView = false
    @State private var hasLoaded = false
    @State private var showFilterSheet = false
    
    var body: some View {
        VStack (spacing: 0) {
            MenuBar(isListView: $isListView, showFilterSheet: $showFilterSheet)

            /** Main content */
            if !model.recipes.isEmpty && isListView {
                RecipeListView(recipes: model.recipes)
            } else if !model.recipes.isEmpty && !isListView {
                RecipeCardListView(recipes: model.recipes)
            } else {
                Spacer()
                Text("You have no recipes.")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .onAppear {
            if let email = session.userEmail {
                if filterRecipesModel.isFilterActive {
                    model.loadFilteredRecipes(email: email, filter: filterRecipesModel)
                } else {
                    model.loadAllUserRecipes(email: email)
                }
            }
        }
        .onChange(of: session.shouldRefreshRecipes) {
            if session.shouldRefreshRecipes {
                if let email = session.userEmail {
                    if filterRecipesModel.isFilterActive {
                        model.loadFilteredRecipes(email: email, filter: filterRecipesModel)
                    } else {
                        model.loadAllUserRecipes(email: email)
                    }
                }
                session.shouldRefreshRecipes = false
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterSheetView(
                filterRecipesModel: filterRecipesModel,
                recipeListModel: model
            ) {
                showFilterSheet = false
            }
        }

    }
}
