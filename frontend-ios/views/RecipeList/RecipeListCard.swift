import SwiftUI

struct RecipeListCard: View {
    let title: String
    let description: String
    let tags: [String]

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

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
                }
            }
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.3))
        }
        .background(Color(.white))
    }
}


