import Foundation

struct SendVerificationCodeRequest: Codable {
    let email: String
    let password: String
}