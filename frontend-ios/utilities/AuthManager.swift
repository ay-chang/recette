import Foundation

class AuthManager {
    static let shared = AuthManager()
    private init() {}

    private let tokenKey = "jwtToken"

    /** Save token persistently in UserDefaults */
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    /** Retrieve token */
    var jwtToken: String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }

    /** Optional: clear token on logout */
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
