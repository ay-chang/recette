import SwiftUI

struct RecipeCard: View {
    let title: String
    let description: String
    let imageurl: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RecipeImage(imageUrlString: imageurl, frameHeight: 300, frameWidth: CGFloat?.none)

            Text(title)
                .font(.headline)
                .padding(.top)
                .padding(.horizontal)
            
            Text(description)
                .font(.subheadline)
                .lineLimit(3)
                .truncationMode(.tail)
                .padding(.vertical)
                .padding(.horizontal)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 4)
    }
}


