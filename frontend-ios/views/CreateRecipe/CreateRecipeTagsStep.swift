import SwiftUI

struct CreateRecipeTagsStep: View {
    @ObservedObject var recipe: CreateRecipeModel
    @EnvironmentObject var session: UserSession
    var onNext: () -> Void
    var onBack: () -> Void
    var onCancel: () -> Void
    
    @State private var showAddTag: Bool = false
    
    var body: some View {
        ZStack {
            Text("Description & Tags")
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
        .padding()
        
        /** Intro Box */
        Text("Give your recipe a description and organize them with tags.")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
        
        /** Description box, tags, and nav buttons */
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Give your recipe a description")
                    .font(.headline)
                TextEditor(text: Binding(
                    get: { String(recipe.description.prefix(250)) },
                    set: { newValue in
                        recipe.description = String(newValue.prefix(250))
                    }
                ))
                    .frame(height: 150)
                    .padding(8)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                CharacterCountView(currentCount: recipe.description.count, maxCount: 250)
            }
            
            /** Tags */
            VStack(alignment: .leading, spacing: 12) {
                Text("Organize your recipe with tags")
                    .font(.headline)
                
                TagContainerView(
                    selectedTags: $recipe.selectedTags,
                    availableTags: $session.availableTags,
                    addTagAction: {
                        showAddTag = true
                    }
                )
            }
            
            Spacer()
            
            /** Navigation Buttons */
            HStack {
                Button(action: onBack) {
                    Text("Back")
                        .padding()
                        .foregroundColor(.black)
                        .underline()
                }
                
                Spacer()

                Button(action: onNext) {
                    Text("Next")
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.top, 4)
        }
        .padding()
        .fullScreenCover(isPresented: $showAddTag) {
            AddTagView(showAddTag: $showAddTag)
        }
    }
}
