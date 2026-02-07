import Foundation
import Security

class AuthManager {
    static let shared = AuthManager()
    private init() {}

    private let tokenKey = "com.recette.jwtToken"
    private let refreshTokenKey = "com.recette.refreshToken"

    // MARK: - Access Token

    func saveToken(_ token: String) {
        saveToKeychain(key: tokenKey, value: token)
        // Migrate: remove from UserDefaults if still there
        UserDefaults.standard.removeObject(forKey: "jwtToken")
    }

    var jwtToken: String? {
        // Try Keychain first, fall back to UserDefaults for migration
        if let token = readFromKeychain(key: tokenKey) {
            return token
        }
        if let legacy = UserDefaults.standard.string(forKey: "jwtToken") {
            saveToken(legacy) // migrate to Keychain
            return legacy
        }
        return nil
    }

    func clearToken() {
        deleteFromKeychain(key: tokenKey)
        deleteFromKeychain(key: refreshTokenKey)
        UserDefaults.standard.removeObject(forKey: "jwtToken")
    }

    // MARK: - Refresh Token

    func saveRefreshToken(_ token: String) {
        saveToKeychain(key: refreshTokenKey, value: token)
    }

    var refreshToken: String? {
        return readFromKeychain(key: refreshTokenKey)
    }

    // MARK: - Keychain Helpers

    private func saveToKeychain(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        deleteFromKeychain(key: key) // remove old entry first

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    private func readFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func deleteFromKeychain(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
