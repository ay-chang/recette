import SwiftUI

struct SocialRecipeDetailsCoordinator: View {
    @Environment(\.dismiss) private var dismiss
    let recipeId: String
    @State private var recipe: RecipeDetails?
    @State private var isSaved: Bool = false
    @State private var isLoading = true

    var body: some View {
        VStack {
            if isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.2)
                    Spacer()
                }
            } else if let recipe = recipe {
                if let imageurl = recipe.imageurl,
                   !imageurl.trimmingCharacters(in: .whitespaces).isEmpty {
                    SocialRecipeDetailsWithImage(
                        recipe: recipe,
                        isSaved: isSaved,
                        onClose: { dismiss() },
                        onBookmarkTap: { toggleSave() }
                    )
                } else {
                    SocialRecipeDetailsNoImage(
                        recipe: recipe,
                        isSaved: isSaved,
                        onClose: { dismiss() },
                        onBookmarkTap: { toggleSave() }
                    )
                }
            }
        }
        .onAppear { loadRecipe() }
    }

    private func loadRecipe() {
        Task {
            do {
                let dto = try await SocialService.shared.getPublicRecipe(id: recipeId)
                await MainActor.run {
                    self.recipe = RecipeDetails(
                        id: dto.id,
                        title: dto.title,
                        description: dto.description,
                        imageurl: dto.imageurl,
                        ingredients: (dto.ingredients).map { Ingredient(name: $0.name, measurement: $0.measurement) },
                        steps: dto.steps,
                        tags: dto.tags,
                        difficulty: dto.difficulty,
                        cookTimeInMinutes: dto.cookTimeInMinutes,
                        servingSize: dto.servingSize,
                        isPublic: dto.isPublic ?? false
                    )
                    self.isSaved = dto.isSavedByCurrentUser ?? false
                    self.isLoading = false
                }
            } catch {
                print("Failed to load social recipe: \(error)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }

    private func toggleSave() {
        Task {
            do {
                if isSaved {
                    try await SavedRecipeService.shared.unsaveRecipe(recipeId: recipeId)
                } else {
                    try await SavedRecipeService.shared.saveRecipe(recipeId: recipeId)
                }
                await MainActor.run {
                    isSaved.toggle()
                }
            } catch {
                print("Failed to toggle save: \(error)")
            }
        }
    }
}

// Simplified version of RecipeDetailsWithImage for social viewing
struct SocialRecipeDetailsWithImage: View {
    let recipe: RecipeDetails
    let isSaved: Bool
    let onClose: () -> Void
    let onBookmarkTap: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if let imageurl = recipe.imageurl {
                        RecipeImage(
                            imageUrlString: imageurl,
                            frameHeight: 350,
                            frameWidth: UIScreen.main.bounds.width
                        )
                    }

                    RecipeDetailsContent(recipe: recipe)
                        .padding(.top, 20)
                }
            }
            .edgesIgnoringSafeArea(.top)

            // Top bar with close and bookmark
            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }

                Spacer()

                Button(action: onBookmarkTap) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSaved ? Color(hex: "#e9c46a") : .white)
                        .padding(10)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .padding(.top, 50)
        }
    }
}

// Simplified version of RecipeDetailsNoImage for social viewing
struct SocialRecipeDetailsNoImage: View {
    let recipe: RecipeDetails
    let isSaved: Bool
    let onClose: () -> Void
    let onBookmarkTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                }

                Spacer()

                Button(action: onBookmarkTap) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSaved ? Color(hex: "#e9c46a") : .gray)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)

            ScrollView {
                RecipeDetailsContent(recipe: recipe)
            }
        }
    }
}
