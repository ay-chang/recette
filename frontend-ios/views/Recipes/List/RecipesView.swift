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
    @State private var isListView = true
    @State private var hasLoaded = false
    @State private var showFilterSheet = false
    @State private var showSavedRecipes = false

    var body: some View {
        VStack (spacing: 0) {
            MenuBar(isListView: $isListView, showFilterSheet: $showFilterSheet, showSavedRecipes: $showSavedRecipes)

            HStack (alignment: .bottom, spacing: 16){
                Text("Your Recipes")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.vertical, 4)
            .padding(.bottom, 8)
            .padding(.horizontal)
            // Loading skeletons
            if model.isLoading && !hasLoaded {
                List(0..<10, id: \.self) { _ in
                    RecipeListCardLoadingSkeleton()
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(.plain)

            // Loaded with data
            } else if !model.recipes.isEmpty && isListView {
                RecipeListView(recipes: model.recipes)

            } else if !model.recipes.isEmpty && !isListView {
                RecipeCardListView(recipes: model.recipes)

            // 3) Loaded but empty
            } else if hasLoaded {
                Spacer()
                Text("You have no recipes.")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .onAppear {
            guard let email = session.userEmail else { return }
            fetch(email: email)
        }
        .onChange(of: session.shouldRefreshRecipes) {
            if session.shouldRefreshRecipes, let email = session.userEmail {
                fetch(email: email)
                session.shouldRefreshRecipes = false
            }
        }
        // Flip hasLoaded when first load completes
        .onChange(of: model.isLoading) { new in
            if hasLoaded == false && new == false { hasLoaded = true }
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterSheetView(
                filterRecipesModel: filterRecipesModel,
                recipeListModel: model
            ) { showFilterSheet = false }
        }
        .fullScreenCover(isPresented: $showSavedRecipes) {
            SavedRecipesView()
        }
    }

    private func fetch(email: String) {
        if filterRecipesModel.isFilterActive {
            model.loadFilteredRecipes(filter: filterRecipesModel)
        } else {
            model.loadAllUserRecipes()
        }
    }
}

