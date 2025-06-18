import SwiftUI

struct GroceryList: View {
    @ObservedObject var model: GroceriesModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Grocery List")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                List {
                    /** For loop to get each recipe */
                    ForEach(model.groupedByRecipe, id: \.id) { group in
                        VStack(alignment: .leading) {
                            
                            /** Recipe group header*/
                            HStack {
                                Text(group.title)
                                    .font(.headline)
                                Spacer()
                                Text("\(group.items.count) Ingredients")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 12)
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color.gray.opacity(0.3)),
                                alignment: .bottom
                            )
                            
                            /** For loop to get items in a recipe */
                            ForEach(group.items.indices, id: \.self) { index in
                                let item = group.items[index]
                                
                                /** A grocery item row*/
                                HStack {
                                    Button(action: {
                                        if let itemIndex = model.items.firstIndex(where: { $0.id == item.id }) {
                                            model.items[itemIndex].isChecked.toggle()
                                            let newValue = model.items[itemIndex].isChecked
                                            model.toggleGroceryCheck(id: item.id, checked: newValue)
                                        }
                                    }) {
                                        Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                                            .foregroundColor(.black)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    
                                    Text(item.name)
                                        .strikethrough(item.isChecked)
                                        .foregroundColor(item.isChecked ? .gray : .black)
                                    
                                    Spacer()
                                    
                                    Text(item.measurement)
                                        .foregroundColor(.black)
                                }
                                .padding(.vertical, 12)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color.gray.opacity(0.3)),
                                    alignment: .bottom
                                )
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }
                    }
                    .padding(.bottom, 32)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
            .padding()
        }
    }
}
