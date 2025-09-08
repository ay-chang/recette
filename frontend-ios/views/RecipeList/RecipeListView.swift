import SwiftUI

/* This is the basic list of recipes */

struct RecipeListView: View {
    let recipes: [RecipeListItems]                              // passed in from parent view (RecipesView.swift)
    @State private var selectedRecipe: SelectedRecipe? = nil    // recipe to be opened
    
    var body: some View {
        List(recipes, id: \.id) { recipe in
            Button {
                selectedRecipe = SelectedRecipe(id: recipe.id)
            } label: {
                RecipeListCard(
                    imageurl: recipe.imageurl,
                    title: recipe.title,
                    description: recipe.description,
                    difficulty: recipe.difficulty,
                    servingSize: recipe.servingSize,
                    cookTimeInMinutes: recipe.cookTimeInMinutes
                )
            }
            .buttonStyle(PlainButtonStyle())
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(PlainListStyle())
        .fullScreenCover(item: $selectedRecipe) { selected in
            RecipeDetailsCoordinator(recipeModel: RecipeDetailsModel(recipeId: selected.id))
        }
    }
}

