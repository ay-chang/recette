import SwiftUI

struct EditRecipe: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var session: UserSession
    @StateObject var model: EditRecipeModel
    @State private var editingIngredientIndex: Int? = nil
    @State private var editingStepIndex: Int? = nil
    @State private var showAddTag: Bool = false

    
    var body: some View {
        /** Header Bar "X" and Create Recipe */
        ZStack {
            Text("Edit your Recipe")
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
        .padding()
        
        /** Main editing content */
        ScrollView {
            /** Image */
            EditRecipeDetailsImage(
                selectedImage: $model.selectedImage,
                imageUrlString: model.imageurl
            )
            
            VStack(alignment: .leading, spacing: 32) {
                
                /** Title */
                EditRecipeDetailsTitle(
                    title: $model.title,
                )
                
                /** Description */
                EditRecipeDetailsDescription(
                    description: $model.description
                )
                
                /** Tags */
                EditRecipeDetailsTags(
                    selectedTags: $model.selectedTags,
                    availableTags: $model.availableTags,
                    onAddTag: {
                        showAddTag = true
                    }
                )
                
                /** Ingredients*/
                EditRecipeDetailsIngredients(
                    ingredients: $model.ingredients,
                    editingIngredientIndex: $editingIngredientIndex
                )
                
                /** Steps */
                EditRecipeDetailsSteps(
                    steps: $model.steps,
                    editingStepIndex: $editingStepIndex
                )
                
            }
            .padding()
            
            /** Save Recipe Button */
            Button(action: {
                model.updateRecipe()
                dismiss()
            }) {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#e9c46a"))
                    .cornerRadius(12)
                    .padding()
            }
        }
        .onAppear {
            if let email = session.userEmail {
                model.loadUserTags(email: email)
            }
        }
        .fullScreenCover(isPresented: $showAddTag) {
            AddTagView(recipe: model, showAddTag: $showAddTag)
        }
        
        
        Spacer()
    }
}
