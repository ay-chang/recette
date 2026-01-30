import Foundation

struct CompleteSignUpRequest: Codable {
    let email: String
    let code: String
}