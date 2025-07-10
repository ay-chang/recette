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
                HStack {
                    Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                        .foregroundColor(item.isChecked ? Color(hex: "#e9c46a") : .black)
                    Text(item.name)
                        .strikethrough(item.isChecked)
                        .foregroundColor(item.isChecked ? .gray : .black)
                        .font(.callout)
                }
            }
            .buttonStyle(BorderlessButtonStyle())

            Spacer()
            
            Text(item.measurement)
                .foregroundColor(.black)
                .font(.callout)
                .fontWeight(.medium)
        }
        .padding(.top, 8)       // hardcoded to make spacing even
        .padding(.bottom, 16)   // hardcoded to make spacing even
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .bottom
        )
        
    }
}

