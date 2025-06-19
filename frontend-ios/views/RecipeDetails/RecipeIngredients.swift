import SwiftUI

struct RecipeIngredients: View {
    let ingredients: [Ingredient]
    let recipeId: String
    
    @EnvironmentObject var session: UserSession
    @EnvironmentObject var groceryModel: GroceriesModel
    @State private var showAlreadyAddedAlert = false


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
                            print("🛒 Attempting to add recipe \(recipeId) for user \(email)")
                            
                            if groceryModel.hasRecipe(recipeId) {
                                print("⚠️ Recipe already exists in grocery list. Showing alert.")
                                showAlreadyAddedAlert = true
                            } else {
                                print("✅ Recipe not found in grocery list. Proceeding to add.")
                                groceryModel.addGroceries(ingredients, email: email, recipeId: recipeId)
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
            .overlay(Rectangle().frame(height: 1).foregroundColor(Color.gray.opacity(0.3)), alignment: .bottom)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(ingredients) { ingredient in
                    Text("\(ingredient.measurement) \(ingredient.name)")
                        .font(.system(size: 16))
                        .fontWeight(.light)                    
                }
            }
        }
    }
}
