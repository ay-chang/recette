import Foundation

struct AuthResponse: Codable {
    let token: String
    let refreshToken: String
}
