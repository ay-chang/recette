/**
 * Decides whether or not user is logged in which determines
 * whether or not we are on the login screen
 */

import SwiftUI

struct AppView: View {
    @EnvironmentObject var session: UserSession
    @StateObject var groceriesModel = GroceriesModel()
    var body: some View {
        Group {
            if session.isLoggedIn {
                MainTabView()
                    .environmentObject(groceriesModel)
            } else {
                LoginView()
            }
        }
    }
}
