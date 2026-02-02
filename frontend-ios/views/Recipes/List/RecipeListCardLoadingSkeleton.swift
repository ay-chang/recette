import SwiftUI

struct RecipeListCardLoadingSkeleton: View {
    private let imageWidth: CGFloat = 100
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                /** Image */
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.gray.opacity(0.2))
                
                VStack(alignment: .leading, spacing: 8) {
                    /** Title*/
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 200, height: 16)
                        .foregroundStyle(.gray.opacity(0.2))
                    
                    /** Tags bar*/
                    HStack (spacing: 8) {
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: 50, height: 10)
                            .foregroundStyle(.gray.opacity(0.2))
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: 50, height: 10)
                            .foregroundStyle(.gray.opacity(0.2))
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: 50,height: 10)
                            .foregroundStyle(.gray.opacity(0.2))
                    }
                    
                    /** Description */
                    RoundedRectangle(cornerRadius: 6)
                        .frame(height: 12)
                        .foregroundStyle(.gray.opacity(0.2))
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 125, height: 12)
                        .foregroundStyle(.gray.opacity(0.2))
                }
                Spacer()
            }
        }
        .frame(height: imageWidth + 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .redacted(reason: .placeholder)
        .shimmer()
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .padding(.leading, 20 + imageWidth + 8) // 20 (horizontal padding) + image + spacing
                .padding(.trailing, 16)
        }
        
    }
}
