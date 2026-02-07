import Foundation

struct ResetPasswordRequest: Codable {
    let email: String
    let code: String
    let newPassword: String
}
