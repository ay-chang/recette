import SwiftUI

struct GroceryListRecipeGroup: View {
    @ObservedObject var groceriesModel: GroceriesModel
    
    var body: some View {
        /** For loop to get each recipe */
        ForEach(groceriesModel.groupedByRecipe, id: \.id) { group in
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

