import SwiftUI

struct RecipeTags: View {
    let tags: [RecetteSchema.GetRecipeByIDQuery.Data.RecipeById.Tag]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                ForEach(tags.compactMap { $0.name }, id: \.self) { tag in
                    Text(tag)
                        .font(.footnote)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .foregroundColor(Color.white)
                        .background(Color(hex: "#e9c46a"))
                        .cornerRadius(8)
                }
            }
        }
    }
}

