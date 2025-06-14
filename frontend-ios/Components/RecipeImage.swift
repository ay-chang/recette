import SwiftUI

struct RecipeImage: View {
    let imageUrlString: String?
    let frameHeight: CGFloat
    let frameWidth: CGFloat?
    

    var body: some View {
        if let imageURLString = imageUrlString,
           let imageURL = URL(string: imageURLString) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.1)
                        .frame(height: frameHeight)
                        .clipShape(Rectangle())
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: frameHeight)
                        .frame(width: frameWidth)
                        .clipped()
                case .failure(_):
                    Color.gray.opacity(0.1)
                        .frame(height: frameHeight)
                        .frame(width: frameWidth)
                @unknown default:
                    Color.gray.opacity(0.1)
                        .frame(height: frameHeight)
                        .frame(width: frameWidth)
                }
            }
            .frame(height: frameHeight)
            .frame(maxWidth: .infinity)
        }
    }
}
