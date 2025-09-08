import SwiftUI

struct RecipeListCard: View {
    let imageurl: String?
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                if let imageurl = imageurl {
                    GeometryReader { geometry in
                        RecipeImage(
                            imageUrlString: imageurl,
                            frameHeight: 75,
                            frameWidth: 75
                        )
                    }
                   .frame(height: 75)
                }
                
                Spacer ()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(title)
                        .font(.headline)

                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                        .lineLimit(2)
                        .truncationMode(.tail)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray.opacity(0.3))
                        
                }
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color(.white))
    }
}


