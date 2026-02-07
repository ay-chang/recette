import SwiftUI

struct GroceryList: View {
    @EnvironmentObject var groceriesModel: GroceriesModel
    @EnvironmentObject var session: UserSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            /** Header */
            HStack {
                Spacer()
                Button (action: {
                    groceriesModel.showOptions = true
                }) {
                    Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .regular))
                    .frame(width: 20, height: 20)
                }
                .padding(10)
                .foregroundColor(Color.black)
                .overlay(
                Circle()
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
            )
            }
            .padding(.bottom)
            .padding(.horizontal)

            
            /** Main content */
            VStack(alignment: .leading, spacing: 0) {
                /** Title*/
                HStack {
                    Text("Grocery List")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.vertical, 4)
                .padding(.bottom, 8)
   
                VStack(alignment: .leading) {
                    if groceriesModel.items.isEmpty {
                        VStack (alignment: .center, spacing: 24){
                            Spacer()
                            Text("Your grocery list is empty.")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        List {
                            GroceryListRecipeGroup(groceriesModel: groceriesModel, session: session, isEditing: groceriesModel.isEditing)
                        }
                        .listStyle(.plain)
                        .scrollIndicators(.hidden)
                    }
                }
            }
            .padding(.horizontal)
        }
        .onDisappear {
            groceriesModel.isEditing = false
        }
    }
}
