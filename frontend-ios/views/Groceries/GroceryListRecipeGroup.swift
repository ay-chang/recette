import SwiftUI

struct GroceryListRecipeGroup: View {
    @ObservedObject var groceriesModel: GroceriesModel
    @ObservedObject var session: UserSession
    let isEditing: Bool
    
    var body: some View {
        /** For loop to get each recipe */
        ForEach(groceriesModel.groupedByRecipe, id: \.id) { group in
            VStack(alignment: .leading) {
                /** Recipe group header*/
                HStack {
                    if isEditing {
                        Button(action: {
                            groceriesModel.removeRecipeFromGroceries(recipeId: group.id)
                            
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red.opacity(0.9))
                                .font(.system(size: 16))
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    
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
                    GroceryListItemRow(item: item, groceriesModel: groceriesModel)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
        }
        .padding(.bottom, 32)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)

    }
}

