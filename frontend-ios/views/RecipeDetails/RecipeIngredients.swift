import SwiftUI

struct RecipeIngredients: View {
    let ingredients: [Ingredient]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients")
                .font(.title3)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 12)
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
