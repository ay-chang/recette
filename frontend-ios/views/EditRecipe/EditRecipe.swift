import SwiftUI

struct EditRecipe: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var session: UserSession
    @StateObject var model: EditRecipeModel
    @State private var editingIngredientIndex: Int? = nil
    @State private var editingStepIndex: Int? = nil
    @State private var showAddTag: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showErrorAlert: Bool = false


    
    var body: some View {
        /** Header Bar "X" and Create Recipe */
        ZStack {
            Text("Edit your Recipe")
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.black)
                .fontWeight(.light)
                
                Spacer()
                Button(action: {
                    model.updateRecipe(
                        onSuccess: { dismiss() },
                        onError: { error in
                            errorMessage = error.localizedDescription
                            showErrorAlert = true
                        }
                    )
                }) {
                    Text("Save")
                        .foregroundColor(.black)
                        .fontWeight(.light)
                }
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
                    availableTags: $session.availableTags,
                    onAddTag: {
                        showAddTag = true
                    }
                )
                
                /** Ingredients*/
                EditRecipeDetailsIngredients(
                    ingredients: $model.ingredients,
                )
                
                /** Steps */
                EditRecipeDetailsSteps(
                    steps: $model.steps,
                )
                
                /** Other options */
                EditRecipeOthers(
                    difficulty: $model.difficulty,
                    servingSize: $model.servingSize,
                    cookTimeInMinutes: $model.cookTimeInMinutes
                )
                
 
            }
            .keyboardToolbarWithDone()
            .padding()
        }
        .onAppear {
            if let email = session.userEmail {
                session.loadUserTags(email: email)
            }
        }
        .fullScreenCover(isPresented: $showAddTag) {
            AddTagView(showAddTag: $showAddTag)
        }
        .alert("Error", isPresented: $showErrorAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(errorMessage ?? "Something went wrong.")
        })

        
        
        Spacer()
    }
}
