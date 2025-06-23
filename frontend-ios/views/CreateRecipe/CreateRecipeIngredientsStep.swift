import SwiftUI

struct CreateRecipeIngredientsStep: View {
    @ObservedObject var recipe: CreateRecipeModel
    var onNext: () -> Void
    var onBack: () -> Void
    var onCancel: () -> Void

    @State private var showAddIngredient = false
    @State private var isEditing = false
    @State private var editingIndex: Int? = nil

    var body: some View {
        // Header
        ZStack {
            Text("Ingredients")
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
        Text("A recipe would be nothing without ingredients! What goes in your dish?")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))

        /** Ingredient List and Add Button */
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Ingredient List")
                    .font(.headline)
                Spacer()
                Button(action: {
                    isEditing.toggle()
                    if !isEditing {
                        editingIndex = nil
                    }
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(isEditing ? Color(hex: "#e9c46a") : .gray)
                }
            }
 

            List {
                if !recipe.ingredients.isEmpty {
                    ForEach(recipe.ingredients.indices, id: \.self) { index in
                        IngredientRow(
                            ingredient: $recipe.ingredients[index],
                            index: index,
                            isEditing: isEditing,
                            editingIndex: $editingIndex,
                            onDelete: {
                                recipe.ingredients.remove(at: index)
                                if editingIndex == index {
                                    editingIndex = nil
                                }
                            }
                        )
                    }
                    .listRowInsets(EdgeInsets()) // removes default padding
                    .listRowSeparator(.hidden)   // hides separator lines
                    .background(Color.clear)     // removes background behind each row
                }

                // Add an ingredient button
                Button(action: {
                    showAddIngredient = true
                }) {
                    HStack {
                        Text("+ Add an ingredient")
                            .font(.callout)
                            .foregroundColor(.black.opacity(0.5))
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, recipe.ingredients.isEmpty ? 20 : 0)
                    .overlay(alignment: .top) {
                        if recipe.ingredients.isEmpty {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray.opacity(0.3))
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .background(Color.clear)
            }
            .listStyle(.plain)

            // Navigation Buttons
            HStack {
                Button(action: onBack) {
                    Text("Back")
                        .padding()
                        .foregroundColor(.black)
                        .underline()
                }
                
                Spacer()

                Button(action: onNext) {
                    Text("Next")
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
        .fullScreenCover(isPresented: $showAddIngredient) {
            AddIngredientView(recipe: recipe, showAddIngredient: $showAddIngredient)
        }
    }
}

struct IngredientRow: View {
    @Binding var ingredient: Ingredient
    let index: Int
    let isEditing: Bool
    @Binding var editingIndex: Int?
    let onDelete: () -> Void

    var body: some View {
        HStack {
            if isEditing && editingIndex == index {
                VStack(alignment: .leading, spacing: 4) {
                    TextField("Ingredient", text: $ingredient.name)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit { editingIndex = nil }

                    TextField("Amount", text: $ingredient.measurement)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit { editingIndex = nil }
                }
            } else {
                if isEditing {
                    Button(action: onDelete) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red.opacity(0.9))
                            .font(.system(size: 16))
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                Text(ingredient.name)
                    .onTapGesture {
                        if isEditing {
                            editingIndex = index
                        }
                    }
                Spacer()
                Text(ingredient.measurement)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        if isEditing {
                            editingIndex = index
                        }
                    }
            }
        }
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .bottom
        )
        .contentShape(Rectangle())
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .background(Color.clear)
    }
}


