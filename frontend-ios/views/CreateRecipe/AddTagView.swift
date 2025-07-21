import SwiftUI

struct AddTagView: View {
    @EnvironmentObject var session: UserSession
    @Binding var showAddTag: Bool
    @State private var newTagName: String = ""
    
    var body: some View {
        /** Header with Cancel / Save */
        ZStack {
            Text("Add Tag")
                .font(.headline)
            HStack {
                Button("Cancel") {
                    showAddTag = false
                }
                .foregroundColor(.black)
                .fontWeight(.light)
                
                Spacer()
                
                Button("Save") {
                    let trimmedTagName = newTagName.trimmingCharacters(in: .whitespaces)
                    if !trimmedTagName.isEmpty {
                        session.addTagToUser(tagName: trimmedTagName)
                        showAddTag = false
                    }
                }
                .foregroundColor(.black)
                .fontWeight(.light)
            }
        }
        .padding()
        
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Organize your recipes with the perfect tags.")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Add a tag below to help categorize and find your recipes faster.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fontWeight(.regular)
                    .padding(.bottom, 8)
            }
            
            /** Tag Input */
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    TextField("Tag", text: $newTagName)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
            }
            Spacer()
        }
        .padding()
    }
}
