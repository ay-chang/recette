/* Entry point for app */

import SwiftUI
import GoogleSignIn

@main
struct frontend_iosApp: App {
    @StateObject private var session = UserSession()
    
    init() {
        UIView.appearance().overrideUserInterfaceStyle = .light // force lightmode
        GIDSignIn.sharedInstance.configuration =
            GIDConfiguration(clientID: "278664357213-h81cbda29r1ti17j1h5gbuh9eop729c4.apps.googleusercontent.com")
        print("GID clientID:", GIDSignIn.sharedInstance.configuration?.clientID ?? "nil")
    }

    var body: some Scene {
        WindowGroup {
            UpdateGate {
                AppView()
                    .environmentObject(session)
                    .onAppear {
                        session.loadSavedSession()
                    }
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
            }
        }
    }
}
