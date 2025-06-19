import SwiftUI

struct GroceryListItemRow: View {
    let item: GroceryItem
    @ObservedObject var groceriesModel: GroceriesModel
    
    var body: some View {
        
        /** A grocery item row*/
        HStack {
            Button(action: {
                if let itemIndex = groceriesModel.items.firstIndex(where: { $0.id == item.id }) {
                    groceriesModel.items[itemIndex].isChecked.toggle()
                    let newValue = groceriesModel.items[itemIndex].isChecked
                    groceriesModel.toggleGroceryCheck(id: item.id, checked: newValue)
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
}

