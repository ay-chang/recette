import SwiftUI

struct RecipeTagsStep: View {
    @ObservedObject var recipe: CreateRecipeModel
    var onBack: () -> Void
    var onFinish: () -> Void
    var onCancel: () -> Void
    
    @State private var prepTime: String = ""
    @State private var showAddTag: Bool = false

    var body: some View {
        // Header
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
        
        // Intro Box
        Text("Describe your recipe and keep it organized with tags")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
        
        // Description
        VStack(alignment: .leading, spacing: 8) {
            Text("Give your recipe a description")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
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
            }
            
            // Character count
            HStack {
                Spacer()
                Text("\(recipe.description.count) / 250")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            
            /** Tags */
            VStack(alignment: .leading, spacing: 12) {
                Text("Organize your recipe with tags")
                    .font(.headline)
                
                TagContainerView(recipe: recipe, addTagAction: {
                    showAddTag = true
                })
            }
            
            Spacer()
            
            // Navigation Buttons
            HStack {
                Button(action: onBack) {
                    Text("Back")
                        .padding()
                        .foregroundColor(.black)
                        .underline()
                }
                
                Spacer()

                Button(action: onFinish) {
                    Text("Finish")
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
            AddTagView(recipe: recipe, showAddTag: $showAddTag)
        }
    }
}
