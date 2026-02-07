import SwiftUI

struct SavedRecipesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var model = SavedRecipesModel()
    @State private var selectedRecipe: SelectedRecipe? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Top bar with back button
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.gray)
                }

                Spacer()

                Text("Saved Recipes")
                    .font(.headline)

                Spacer()

                // Placeholder for symmetry
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.clear)
            }
            .padding()

            Divider()

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
                    Image(systemName: "bookmark.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("No saved recipes")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Save recipes from your friends to find them here")
                        .font(.subheadline)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Spacer()
                }
            } else {
                List {
                    ForEach(model.recipes) { recipe in
                        Button {
                            selectedRecipe = SelectedRecipe(id: recipe.id)
                        } label: {
                            SavedRecipeRow(recipe: recipe)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                model.unsaveRecipe(recipeId: recipe.id)
                            } label: {
                                Label("Remove", systemImage: "bookmark.slash")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear { model.loadSavedRecipes() }
        .fullScreenCover(item: $selectedRecipe) { selected in
            SocialRecipeDetailsCoordinator(recipeId: selected.id)
        }
    }
}

struct SavedRecipeRow: View {
    let recipe: SocialRecipeItem

    var body: some View {
        HStack(spacing: 12) {
            if let imageurl = recipe.imageurl, !imageurl.isEmpty {
                AsyncImage(url: URL(string: imageurl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .clipped()
            } else {
                Image("pasta-placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text("by \(recipe.ownerFirstName ?? recipe.ownerUsername)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "bookmark.fill")
                .foregroundColor(Color(hex: "#e9c46a"))
        }
        .padding(.vertical, 4)
    }
}
