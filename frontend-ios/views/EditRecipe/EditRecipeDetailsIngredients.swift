import SwiftUI

struct EditRecipeDetailsIngredients: View {
    @Binding var ingredients: [Ingredient]
    @Binding var editingIngredientIndex: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            /** Header */
            HStack {
                Text("Ingredients")
                    .font(.headline)
                Spacer()
            }
            
            /** List of ingredients */
            VStack (alignment: .leading) {
                ForEach($ingredients.indices, id: \.self) { index in
                    let ingredient = $ingredients[index]
                    
                    HStack (spacing: 12) {
                        Button(action: {
                            ingredients.remove(at: index)
                            if editingIngredientIndex == index {
                                editingIngredientIndex = nil
                            } else if let current = editingIngredientIndex, current > index {
                                editingIngredientIndex = current - 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red.opacity(0.9))
                                .font(.system(size: 16))
                        }
                        
                        
                        HStack {
                            if editingIngredientIndex == index {
                                TextField("Name", text: ingredient.name)
                                    .padding(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                                Spacer()
                                TextField("Measurement", text: ingredient.measurement)
                                    .padding(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                            } else {
                                Text(ingredient.wrappedValue.name)
                                Spacer()
                                Text(ingredient.wrappedValue.measurement)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onTapGesture {
                            editingIngredientIndex = index
                        }
                    }
                    .padding(.vertical, 20)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3)),
                        alignment: .bottom
                    )
                    .contentShape(Rectangle())
                }
            }
            
            /** Add Ingredient button */
            Button(action: {
                ingredients.append(Ingredient(name: "", measurement: ""))
                editingIngredientIndex = ingredients.count - 1
            }) {
                HStack {
                    Text("+ Add an ingredient")
                        .font(.callout)
                        .foregroundColor(.black.opacity(0.5))
                    Spacer()
                }
                .padding(.horizontal)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
