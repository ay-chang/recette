import SwiftUI

struct GroceryList: View {
    @EnvironmentObject var groceriesModel: GroceriesModel
    
    var body: some View {
        VStack(alignment: .leading) {
            /** Header */
            HStack {
                Spacer()
                Text("Info")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .foregroundColor(Color.black)
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                        )
                        .cornerRadius(15)
            }
            .padding()
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.1)),
                alignment: .bottom
            )
            .background(Color.gray.opacity(0.03))
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Grocery List")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading) {
                    List {
                        GroceryListRecipeGroup(groceriesModel: groceriesModel)
                    }
                    .listStyle(.plain)
                }
            }
            .padding(.horizontal)
            
          
        }
    }
}
