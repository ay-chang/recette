import SwiftUI

struct UpdateGate<Content: View>: View {
    @StateObject private var updater = UpdateChecker()
    let content: () -> Content

    private let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id6748658964")!

    var body: some View {
        content()
            .task { await updater.check() } // check on first launch
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                Task { await updater.check() } // re-check whenever app returns to foreground
            }
            .alert("Update Required", isPresented: $updater.showAlert) {
                Button("Update") {
                    UIApplication.shared.open(appStoreURL)
                    // If they come back without updating, re-show the alert
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if updater.mustForceUpdate { updater.showAlert = true }
                    }
                }
            } message: {
                Text(updater.alertMessage ?? "A newer version is required to continue.")
            }
    }
}
