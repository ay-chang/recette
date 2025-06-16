import SwiftUI

struct EditRecipeDetailsDescription: View {
    @Binding var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            /** Header */
            HStack {
                Text("Description")
                    .font(.headline)
                Spacer()
            }
            
            TextField("Description", text: $description, axis: .vertical)
                .font(.system(size: 16, weight: .light))
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .onChange(of: description) {
                    if description.count > 250 {
                        description = String(description.prefix(250))
                    }
                }
            
             CharacterCountView(currentCount: description.count, maxCount: 250)
        }
    }
}
