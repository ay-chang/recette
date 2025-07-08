import SwiftUI

struct CreateRecipeTagsStep: View {
    @ObservedObject var recipe: CreateRecipeModel
    @EnvironmentObject var session: UserSession
    var onBack: () -> Void
    var onFinish: () -> Void
    var onCancel: () -> Void
    
    @State private var showAddTag: Bool = false
    
    var body: some View {
        ZStack {
            Text("Tags")
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
        Text("Organize your recipe with tags, select as many as you want or create more!")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
        
        /** Description box, tags, and nav buttons */
        VStack(alignment: .leading, spacing: 24) {
            
            
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
            AddTagView(showAddTag: $showAddTag)
        }
    }
}
