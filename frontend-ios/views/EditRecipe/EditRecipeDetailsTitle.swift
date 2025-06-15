import SwiftUI

struct EditRecipeDetailsTitle: View {
    @Binding var title: String
    
    var body: some View {
        /** Header */
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Title")
                    .font(.headline)
                Spacer()
            }
            
            
            TextField("Title", text: $title)
                .font(.system(size: 28, weight: .medium))
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            // CharacterCountView(currentCount: $model.title.count, maxCount: 55)
        }
    }
}
