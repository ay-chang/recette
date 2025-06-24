import SwiftUI

struct RecipeCard: View {
    let title: String
    let description: String
    let imageurl: String?
    let difficulty: String?
    let servingSize: Int?
    let cookTimeInMinutes: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RecipeImage(imageUrlString: imageurl, frameHeight: 300, frameWidth: CGFloat?.none)

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
                .padding(.horizontal)
            
            /** Check if any of the properties even exist and then display others bar*/
            if difficulty != nil ||
               (cookTimeInMinutes ?? 0) > 0 ||
                (servingSize ?? 0) > 0 {
                OthersBarView(
                    difficulty: difficulty,
                    servingSize: servingSize,
                    cookTimeInMinutes: cookTimeInMinutes,
                    iconSize: 22,
                    fontSize: 14
                )
                .padding(.top)
                .padding(.horizontal)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(Color.gray)
                .lineLimit(2)
                .truncationMode(.tail)
                .padding(.vertical)
                .padding(.horizontal)
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 4)
    }
}


