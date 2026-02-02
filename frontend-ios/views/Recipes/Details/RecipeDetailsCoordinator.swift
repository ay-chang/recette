import SwiftUI

/**
 * Check if recipe details has an image, if not then load RecipeDetailsNoImage
 * otherwise just load RecipeDetailsWithImage. The data is loaded in from either
 * the RecipeCardListView or the RecipeListView which we then pass into either
 * the RecipeDetailsWithImage or the RecipeDetailsNoImage. Also controls whether
 * or not the action sheet (delete, edit) is being displayed.
 */

struct RecipeDetailsCoordinator: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var session: UserSession
    @StateObject var recipeModel: RecipeDetailsModel
    @State private var showWhiteTopBar = false
    @State private var showActionSheet = false
    @State private var showEditRecipe = false


    var body: some View {
        VStack {
            if let recipe = recipeModel.recipe {
                if let imageurl = recipe.imageurl,
                   !imageurl.trimmingCharacters(in: .whitespaces).isEmpty {
                    RecipeDetailsWithImage(
                        recipe: recipe,
                        onClose: {
                            dismiss()
                            session.shouldRefreshRecipes = true
                        },
                        onEllipsisTap: { showActionSheet = true }
                    )
                } else {
                    RecipeDetailsNoImage(
                        recipe: recipe,
                        selectedImage: { image in
                            if let email = session.userEmail {
                                recipeModel.updateRecipeImage(image: image, email: email) { success in
                                    if success {
                                        recipeModel.loadRecipe()
                                    } else {
                                        print("Failed to update image.")
                                    }
                                }
                            }
                        },
                        onClose: {
                            dismiss()
                            session.shouldRefreshRecipes = true
                        },
                        onEllipsisTap: { showActionSheet = true }
                    )
                }
            }
        }
        .onAppear {
            recipeModel.loadRecipe()
        }
        .onChange(of: recipeModel.recipe) {
            if let imageurl = recipeModel.recipe?.imageurl,
               !imageurl.trimmingCharacters(in: .whitespaces).isEmpty {
                showWhiteTopBar = false
            } else {
                showWhiteTopBar = true
            }
        }
        .sheet(isPresented: $showActionSheet) {
            ActionSheetView(
                onDelete: {
                    recipeModel.deleteRecipe { success in
                        if success {
                            session.shouldRefreshRecipes = true
                            dismiss()
                        }
                    }
                },
                onEdit: {
                    showActionSheet = false
                    showEditRecipe = true
                    session.shouldRefreshRecipes = true
                }
            )
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .fullScreenCover(isPresented: $showEditRecipe, onDismiss: {
            recipeModel.loadRecipe()
        }) {
            if let recipe = recipeModel.recipe {
                EditRecipe(model: EditRecipeModel(recipe: recipe))
            }
        }

    }
}


/** Helps keep track of scrolling to see when the white bar comes in */
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


