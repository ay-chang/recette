import SwiftUI

struct GroceriesView: View {
    @EnvironmentObject var session: UserSession
    @EnvironmentObject var groceriesModel: GroceriesModel
    
    var body: some View {
        GroceryList()
            .onAppear{
                if let email = session.userEmail {
                    print("loaded grocery list...")
                    groceriesModel.loadGroceries(email: email)
                }
            }
    }
}
