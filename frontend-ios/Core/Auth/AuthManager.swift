import Foundation

class AuthManager {
    static let shared = AuthManager()
    private init() {}

    private let tokenKey = "jwtToken"

    /** Save token persistently in UserDefaults */
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        Network.refresh()  // Ensure Apollo uses the new token
    }

    /** Retrieve token */
    var jwtToken: String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }

    /** Clear token on logout or delete */
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        Network.refresh()  // Ensure Apollo no longer sends old token
    }
}
