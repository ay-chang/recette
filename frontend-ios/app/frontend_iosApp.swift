/* Entry point for app */

import SwiftUI

@main
struct frontend_iosApp: App {
    @StateObject private var session = UserSession()
    @StateObject var groceriesModel = GroceriesModel()

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(session)
                .environmentObject(groceriesModel) 
                .onAppear {
                    session.loadSavedSession()
                }
        }
    }
}
