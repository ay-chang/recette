import SwiftUI

/* This file displays recipes with their images */

struct RecipeCardListView: View {
    let recipes: [RecipeListItems]                              // passed in from parent view (RecipesView.swift)
    @State private var selectedRecipe: SelectedRecipe? = nil    // recipe to be opened
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(recipes, id: \.id) { recipe in
                        Button {
                            selectedRecipe = SelectedRecipe(id: recipe.id)
                        } label: {
                            RecipeCard(
                                title: recipe.title,
                                description: recipe.description,
                                imageurl: recipe.imageurl,
                                difficulty: recipe.difficulty,
                                servingSize: recipe.servingSize,
                                cookTimeInMinutes: recipe.cookTimeInMinutes
                            )
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    
                    }
                }
                .padding(.vertical)
            }
        }
        .listStyle(PlainListStyle())
        .fullScreenCover(item: $selectedRecipe) { selected in
            RecipeDetailsCoordinator(recipeModel: RecipeDetailsModel(recipeId: selected.id))
        }
    }
}


