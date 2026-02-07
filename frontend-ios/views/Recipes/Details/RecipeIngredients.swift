import SwiftUI

struct RecipeIngredients: View {
    let ingredients: [Ingredient]
    let recipeId: String
    
    @EnvironmentObject var session: UserSession
    @EnvironmentObject var groceryModel: GroceriesModel
    @State private var showAlreadyAddedAlert = false
    @State private var isAddingToGroceries = false


    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack (alignment: .firstTextBaseline){
                Text("Ingredients")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 12)
                
                Spacer()
                
                Button {
                    if let email = session.userEmail {
                        if groceryModel.hasRecipe(recipeId) || isAddingToGroceries {
                            showAlreadyAddedAlert = true
                        } else {
                            isAddingToGroceries = true
                            groceryModel.addGroceries(ingredients, recipeId: recipeId) { success in
                                if success {
                                    groceryModel.loadGroceries(email: email)
                                } else {
                                    isAddingToGroceries = false
                                    print("Failed to add groceries")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "cart.badge.plus")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 14))
                        Text("Add to grocery list")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                    }
                }
                .alert(isPresented: $showAlreadyAddedAlert) {
                    Alert(
                        title: Text("Already Added"),
                        message: Text("This recipe is already in your grocery list."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.3)), alignment: .bottom
            )
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(ingredients) { ingredient in
                    HStack {
                        Text("\(ingredient.name)")
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                        Spacer()
                        Text("\(ingredient.measurement)")
                            .fontWeight(.medium)
                        
                    }
                }
            }
            
        }
    }
}
