import SwiftUI

struct GroceryListInfo: View {
    @Binding var showInfo: Bool
    
    var body: some View {
        ZStack {
            Text("Info")
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Button(action: {
                    showInfo = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .foregroundColor(.black)
            .fontWeight(.light)
        }
        .padding()
        
        VStack (alignment: .leading, spacing: 12){
            Text("Grocery List Tips and how to use")
                .font(.title2)
                .fontWeight(.medium)
            Text("Your grocery list includes ingredients from all your saved recipes. You can check items off as you shop. To remove an entire recipe from the list, tap the pencil icon and then the red minus button next to the recipe.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .fontWeight(.regular)
            Spacer()
        }
        .padding ()
    }
}



