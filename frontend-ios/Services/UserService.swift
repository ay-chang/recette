import Foundation

final class UserService {
    static let shared = UserService()

    func getCurrentUser() async throws -> UserResponse {
        return try await RecetteAPI.shared.get(UserResponse.self, path: "/api/users/me")
    }

    func getUsername(email: String) async throws -> String {
        return try await RecetteAPI.shared.get(String.self, path: "/api/users/\(email)/username")
    }

    func updateCurrentUser(firstName: String, lastName: String) async throws -> UserResponse {
        let request = UpdateAccountDetailsRequest(firstName: firstName, lastName: lastName)
        return try await RecetteAPI.shared.put(UserResponse.self, path: "/api/users/me", body: request)
    }

    func deleteCurrentUser() async throws {
        try await RecetteAPI.shared.delete(path: "/api/users/me")
    }
}
