import SwiftUI

struct RecipeListCard: View {
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .lineLimit(3)
                    .truncationMode(.tail)
                    
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


