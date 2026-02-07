import SwiftUI

struct FriendsPostsView: View {
    @StateObject private var model = SocialFeedModel()
    @State private var selectedRecipe: SelectedRecipe? = nil

    var body: some View {
        Group {
            if model.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.2)
                    Spacer()
                }
            } else if model.recipes.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "person.2.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("No recipes from friends yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Add friends to see their public recipes here")
                        .font(.subheadline)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(model.recipes) { recipe in
                            SocialRecipeCard(
                                recipe: recipe,
                                onTap: { selectedRecipe = SelectedRecipe(id: recipe.id) },
                                onBookmarkTap: { model.toggleSave(recipeId: recipe.id) }
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .onAppear { model.loadFeed() }
        .fullScreenCover(item: $selectedRecipe) { selected in
            SocialRecipeDetailsCoordinator(recipeId: selected.id)
        }
    }
}

