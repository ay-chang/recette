import SwiftUI

struct RecipeListCard: View {
    let imageurl: String?
    let title: String
    let description: String
    let difficulty: String?
    let servingSize: Int?
    let cookTimeInMinutes: Int?
    private let imageWidth: CGFloat = 100

    var body: some View {
        VStack (alignment: .leading) {
            HStack(alignment: .top, spacing: 12) { // spacing between image and text
                if let imageurl = imageurl {
                    RecipeImage(
                        imageUrlString: imageurl,
                        frameHeight: imageWidth,
                        frameWidth: imageWidth
                    )
                    .cornerRadius(12)
                    .frame(maxWidth: imageWidth, maxHeight: imageWidth)
                } else {
                    Image("pasta-placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth, height: imageWidth)
                            .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.headline)
                    
                    /** Check if any of the properties even exist and then display others bar*/
                    if difficulty != nil ||
                       (cookTimeInMinutes ?? 0) > 0 ||
                        (servingSize ?? 0) > 0 {
                        OthersBarView(
                            difficulty: difficulty,
                            servingSize: servingSize,
                            cookTimeInMinutes: cookTimeInMinutes,
                            iconSize: 12,
                            fontSize: 12,
                            itemSpacing: 4
                        )
                    }

                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
            }
            .frame(height: imageWidth + 8)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                    .padding(.leading, 20 + imageWidth + 8) // 20 (horizontal padding) + image + spacing
                    .padding(.trailing, 16)
            }
        }
    }
}
