import SwiftUI

struct RecipeIngredients: View {
    let ingredients: [Ingredient]
    let recipeId: String
    
    @EnvironmentObject var session: UserSession
    @StateObject var groceryModel = GroceriesModel()

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
                        groceryModel.addGroceries(ingredients, email: email, recipeId: recipeId)
                    }
                } label: {
                    Text("+ Add to grocery list")
                        .font(.caption)
                        .foregroundColor(Color.gray)
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
