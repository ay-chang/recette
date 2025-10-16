import Foundation

struct UpdateConfig: Decodable {
    let minSupportedVersion: String
    let latestVersion: String?
    let message: String?
}

@MainActor
final class UpdateChecker: ObservableObject {
    @Published var mustForceUpdate = false
    @Published var alertMessage: String?
    @Published var showAlert = false

    private let configURL = URL(string: "\(Config.backendBaseURL)/api/app-config")!
    private let current = AppVersion(currentShortVersion())

    func check() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: configURL)
            let cfg = try JSONDecoder().decode(UpdateConfig.self, from: data)

            let min = AppVersion(cfg.minSupportedVersion)
            mustForceUpdate = current < min
            alertMessage = (cfg.message?.isEmpty == false) ? cfg.message : "Please update to continue."
            showAlert = mustForceUpdate
        } catch {
            // Fail-open on errors so users aren’t locked out when offline
            mustForceUpdate = false
            showAlert = false
        }
    }
}
