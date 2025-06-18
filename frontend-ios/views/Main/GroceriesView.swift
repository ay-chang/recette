import SwiftUI

struct GroceriesView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var model = GroceriesModel()
    
    var body: some View {
        GroceryList(model: model)
            .onAppear{
                if let email = session.userEmail {
                    print("loaded grocery list...")
                    model.loadGroceries(email: email)
                }
            }
    }
}
