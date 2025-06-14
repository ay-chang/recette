import SwiftUI

struct RecipeCard: View {
    let title: String
    let description: String
    let tags: [String]
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
                .padding(.top)
                .padding(.horizontal)
            
            if tags.isEmpty {
                Text("No Tags")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#e9c46a"))
                                .foregroundColor(Color.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 4)
    }
}


