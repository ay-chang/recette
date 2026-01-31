import Foundation

struct UserResponse: Codable {
    let id: String
    let username: String
    let email: String
    let firstName: String?
    let lastName: String?
}
