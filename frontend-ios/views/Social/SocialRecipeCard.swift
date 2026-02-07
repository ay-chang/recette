import SwiftUI

struct SocialRecipeCard: View {
    let recipe: SocialRecipeItem
    let onTap: () -> Void
    let onBookmarkTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                if let imageurl = recipe.imageurl, !imageurl.isEmpty {
                    GeometryReader { geometry in
                        RecipeImage(
                            imageUrlString: imageurl,
                            frameHeight: 250,
                            frameWidth: geometry.size.width
                        )
                    }
                    .frame(height: 250)
                } else {
                    Image("pasta-placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                }

                // Owner info and bookmark
                HStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                    Text(recipe.ownerFirstName ?? recipe.ownerUsername)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Spacer()

                    // Bookmark button
                    Button(action: onBookmarkTap) {
                        Image(systemName: recipe.isSaved ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 20))
                            .foregroundColor(recipe.isSaved ? Color(hex: "#e9c46a") : .gray)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)

                Text(recipe.title)
                    .foregroundColor(Color.black)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 8)
                    .padding(.horizontal)

                if recipe.difficulty != nil ||
                   (recipe.cookTimeInMinutes ?? 0) > 0 ||
                   (recipe.servingSize ?? 0) > 0 {
                    OthersBarView(
                        difficulty: recipe.difficulty,
                        servingSize: recipe.servingSize,
                        cookTimeInMinutes: recipe.cookTimeInMinutes,
                        iconSize: 18,
                        fontSize: 12,
                        itemSpacing: 8
                    )
                    .padding(.top, 8)
                    .padding(.horizontal)
                }

                if !recipe.description.isEmpty {
                    Text(recipe.description)
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
