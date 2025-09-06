import SwiftUI

struct AddIngredientView: View {
    @ObservedObject var recipe: CreateRecipeModel
    @Binding var showAddIngredient: Bool
    @State private var newIngredientName: String = ""
    @State private var newIngredientMeasurement: String = ""

    
    var body: some View {
        // Header with Cancel / Save
        ZStack {
            Text("Add Ingredient")
                .font(.headline)
            HStack {
                Button("Cancel") {
                    showAddIngredient = false
                }
                .foregroundColor(.black)
                .fontWeight(.light)
                
                Spacer()
                
                Button("Save") {
                    if !newIngredientName.trimmingCharacters(in: .whitespaces).isEmpty && !newIngredientMeasurement.trimmingCharacters(in: .whitespaces).isEmpty {
                        recipe.ingredients.append(Ingredient(name: newIngredientName, measurement: newIngredientMeasurement))
                        showAddIngredient = false
                    }
                }
                .foregroundColor(.black)
                .fontWeight(.light)
            }
        }
        .padding()
        
        
        VStack(alignment: .leading, spacing: 24) {
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
            
            // Ingredient input
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    TextField("Ingredient", text: Binding(
                        get: { newIngredientName },
                        set: { newValue in
                            newIngredientName = String(newValue.prefix(50))
                        }
                    ))
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    
                    TextField("Amount", text: $newIngredientMeasurement)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .frame(width: 100)
                }
            }
            Spacer()
        }
        .padding()
    }
}
