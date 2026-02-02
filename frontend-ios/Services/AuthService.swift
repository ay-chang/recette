import Foundation

final class AuthService {
    static let shared = AuthService()

    func login(email: String, password: String) async throws -> AuthResponse {
        let request = LoginRequest(email: email, password: password)
        return try await RecetteAPI.shared.post(AuthResponse.self, path: "/api/auth/login", body: request)
    }

    func loginWithGoogle(idToken: String) async throws -> AuthResponse {
        let request = GoogleLoginRequest(idToken: idToken)
        return try await RecetteAPI.shared.post(AuthResponse.self, path: "/api/auth/login/google", body: request)
    }

    func loginWithApple(idToken: String) async throws -> AuthResponse {
        let request = AppleLoginRequest(idToken: idToken)
        return try await RecetteAPI.shared.post(AuthResponse.self, path: "/api/auth/login/apple", body: request)
    }

    func sendVerificationCode(email: String, password: String) async throws {
        let request = SendVerificationCodeRequest(email: email, password: password)
        let _: EmptyResponse = try await RecetteAPI.shared.post(EmptyResponse.self, path: "/api/auth/signup/send-code", body: request)
    }

    func completeSignUp(email: String, code: String) async throws -> AuthResponse {
        let request = CompleteSignUpRequest(email: email, code: code)
        return try await RecetteAPI.shared.post(AuthResponse.self, path: "/api/auth/signup/complete", body: request)
    }
}

// Helper for endpoints that return no content
private struct EmptyResponse: Codable {}