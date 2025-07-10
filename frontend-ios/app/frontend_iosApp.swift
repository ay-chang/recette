/* Entry point for app */

import SwiftUI

@main
struct frontend_iosApp: App {
    @StateObject private var session = UserSession()
    
    init() {
        UIView.appearance().overrideUserInterfaceStyle = .light // force lightmode
    }


    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(session)
                .onAppear {
                    session.loadSavedSession()
                }
        }
    }
}
