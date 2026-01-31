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
            if let imageurl = imageurl, !imageurl.isEmpty {
                GeometryReader { geometry in
                    RecipeImage(
                        imageUrlString: imageurl,
                        frameHeight: 350,
                        frameWidth: geometry.size.width
                    )
                }
                .frame(height: 350)
            } else {
                Image("pasta-placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 350)
                    .clipped()
            }

            Text(title)
                .foregroundColor(Color.black)
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
                    iconSize: 18,
                    fontSize: 12,
                    itemSpacing: 8
                )
                .padding(.top)
                .padding(.horizontal)
            }
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(Color.gray)
                .lineLimit(2)
                .truncationMode(.tail)
                .padding(.vertical)
                .padding(.horizontal)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 4)
    }
}


