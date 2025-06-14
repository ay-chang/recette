import SwiftUI

/* This file displays recipes with their images */

struct RecipeCardListView: View {
    let recipes: [RecetteSchema.GetUserRecipesFullDetailsQuery.Data.UserRecipe] // passed in from parent view (RecipesView.swift)
    @State private var selectedRecipe: SelectedRecipe? = nil                    // recipe to be opened
    
    var body: some View {
        List(recipes, id: \.id) { recipe in
            Button {
                selectedRecipe = SelectedRecipe(id: recipe.id)
            } label: {
                RecipeCard(
                    title: recipe.title,
                    description: recipe.description,
                    tags: recipe.tags.map { $0.name },
                    imageurl: recipe.imageurl
                )
            }
            .buttonStyle(PlainButtonStyle())
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
        .fullScreenCover(item: $selectedRecipe) { selected in
            RecipeDetailsCoordinator(recipeModel: RecipeDetailsModel(recipeId: selected.id))
        }
    }
}


