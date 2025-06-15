import SwiftUI

struct AddTagView<Model: TagManageable & ObservableObject>: View {
    @ObservedObject var recipe: Model
    @Binding var showAddTag: Bool
    @State private var newTagName: String = ""
    
    var body: some View {
        // Header with Cancel / Save
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
                        if let email = UserDefaults.standard.string(forKey: "loggedInEmail") {
                            recipe.addTagToUser(email: email, tagName: trimmedTagName)
                            showAddTag = false
                        } else {
                            print("Error: No logged in email found")
                        }
                    }
                }
                .foregroundColor(.black)
                .fontWeight(.light)
            }
        }
        .padding()
        
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Every great dish starts with the right ingredients.")
                    .font(.title2)
                    .fontWeight(.medium)// Options: .ultraLight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black
                
                Text("Add them here, one at a time, along with how much you’ll need.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fontWeight(.regular)
                    .padding(.bottom, 8)
            }
            
            // Tag Input
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
