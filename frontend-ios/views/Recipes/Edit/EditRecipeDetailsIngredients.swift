import SwiftUI

struct EditRecipeDetailsIngredients: View {
    @Binding var ingredients: [Ingredient]

    // Focus both which field (name/measurement) and which row (index)
    @FocusState private var focus: Field?
    private enum Field: Hashable {
        case name(Int), measurement(Int)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            /** Header */
            HStack {
                Text("Ingredients").font(.headline)
                Spacer()
            }

            /** List of ingredients */
            VStack(alignment: .leading) {
                ForEach(ingredients.indices, id: \.self) { index in
                    /** Row for each minus, ingredient, and measurement*/
                    HStack(spacing: 12) {
                        /** Minus button */
                        Button {
                            ingredients.remove(at: index)

                            if let f = focus {
                                switch f {
                                case .name(let i) where i == index,
                                     .measurement(let i) where i == index:
                                    focus = nil
                                case .name(let i) where i > index:
                                    focus = .name(i - 1)
                                case .measurement(let i) where i > index:
                                    focus = .measurement(i - 1)
                                default:
                                    break
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red.opacity(0.9))
                                .font(.system(size: 16))
                        }
                        TextField("Name", text: $ingredients[index].name)
                            .focused($focus, equals: .name(index))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onSubmit { focus = .measurement(index) }

                        TextField("Measurement", text: $ingredients[index].measurement)
                            .focused($focus, equals: .measurement(index))
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 20)
                    .overlay(
                        Rectangle().frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3)),
                        alignment: .bottom
                    )
                }
            }

            /** Add Ingredient button */
            Button {
                ingredients.append(Ingredient(name: "", measurement: ""))
                focus = .name(ingredients.count - 1) // auto-focus new row’s name
            } label: {
                HStack {
                    Text("+ Add an ingredient")
                        .font(.callout)
                        .foregroundColor(.black.opacity(0.5))
                    Spacer()
                }
                .padding(.horizontal)
            }
            .buttonStyle(.plain)
        }
        .onAppear { focus = nil } // start with no cursor if you like
    }
}
