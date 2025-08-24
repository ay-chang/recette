import SwiftUI

struct GroceryList: View {
    @EnvironmentObject var groceriesModel: GroceriesModel
    @EnvironmentObject var session: UserSession
    @State private var isEditing = false
    @State private var showInfo = false
    
    var body: some View {
        VStack(alignment: .leading) {
            /** Header */
            HStack {
                Spacer()
                Button (action: {
                    showInfo = true
                }) {
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
            }
            .padding()
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.1)),
                alignment: .bottom
            )
            .background(Color.gray.opacity(0.03))
            
            /** Main content */
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Grocery List")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button (action: {
                        isEditing.toggle()
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(isEditing ? Color(hex: "#e9c46a") : .gray)
                    }
                }
   
                VStack(alignment: .leading) {
                    if groceriesModel.items.isEmpty {
                        VStack (alignment: .center, spacing: 24){
                            Spacer()
//                            Image("empty-groceries-illustration")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 225)
                            Text("Your grocery list is empty.")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        List {
                            GroceryListRecipeGroup(groceriesModel: groceriesModel, session: session, isEditing: isEditing)
                        }
                        .listStyle(.plain)
                        .scrollIndicators(.hidden)
                    }
                }
            }
            .padding(.horizontal)
        }
        .onDisappear {
            isEditing = false
        }
        .fullScreenCover(isPresented: $showInfo) {
            GroceryListInfo(showInfo: $showInfo)
        }
    }
}
