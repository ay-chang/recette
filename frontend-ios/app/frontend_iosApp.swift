/* Entry point for app */

import SwiftUI

@main
struct frontend_iosApp: App {
    @StateObject private var session = UserSession()
    
    init() {
        session.loadSavedSession()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(session)
        }
    }
}
