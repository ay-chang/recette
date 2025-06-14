import SwiftUI

/* This is the basic list of recipes */

struct RecipeListView: View {
    let recipes: [RecetteSchema.GetUserRecipesFullDetailsQuery.Data.UserRecipe] // passed in from parent view (RecipesView.swift)
    @State private var selectedRecipe: SelectedRecipe? = nil                    // recipe to be opened
    
    var body: some View {
        List(recipes, id: \.id) { recipe in
            Button {
                selectedRecipe = SelectedRecipe(id: recipe.id)
            } label: {
                RecipeListCard(
                    title: recipe.title,
                    description: recipe.description
                )
                .frame(maxWidth: .infinity, alignment: .leading)
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

