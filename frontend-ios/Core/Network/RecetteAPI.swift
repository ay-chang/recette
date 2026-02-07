import Foundation

final class RecetteAPI {
    static let shared = RecetteAPI()

    private let baseURL = URL(string: "\(Config.backendBaseURL)")! // no trailing slash

    /// Callback set by UserSession to handle forced logout on 401
    var onUnauthorized: (() -> Void)?

    private var isRefreshing = false

    private func authToken() -> String? {
        return AuthManager.shared.jwtToken
    }

    private func makeGET(path: String, queryItems: [URLQueryItem] = []) throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        if !queryItems.isEmpty { components.queryItems = queryItems }
        guard let url = components.url else { throw URLError(.badURL) }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = authToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return req
    }

    private func makeRequest(method: String, path: String, body: Encodable? = nil, queryItems: [URLQueryItem] = []) throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        if !queryItems.isEmpty { components.queryItems = queryItems }
        guard let url = components.url else { throw URLError(.badURL) }

        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body = body {
            req.httpBody = try JSONEncoder().encode(body)
        }

        if let token = authToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return req
    }

    private func validate(_ response: URLResponse, data: Data?) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200...299).contains(http.statusCode) else {
            var message = "HTTP \(http.statusCode)"
            if let data = data,
               let body = try? JSONDecoder().decode([String: String].self, from: data),
               let error = body["error"] {
                message = error
            }
            throw NSError(domain: "RecetteAPI", code: http.statusCode, userInfo: [
                NSLocalizedDescriptionKey: message
            ])
        }
    }

    /// Attempt to refresh the access token using the stored refresh token.
    /// Returns true if refresh succeeded.
    private func attemptTokenRefresh() async -> Bool {
        guard !isRefreshing else { return false }
        guard let refreshToken = AuthManager.shared.refreshToken else { return false }

        isRefreshing = true
        defer { isRefreshing = false }

        do {
            let body = RefreshTokenRequest(refreshToken: refreshToken)
            let req = try makeRequest(method: "POST", path: "/api/auth/refresh", body: body)
            let (data, resp) = try await URLSession.shared.data(for: req)
            try validate(resp, data: data)
            let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
            AuthManager.shared.saveToken(authResponse.token)
            AuthManager.shared.saveRefreshToken(authResponse.refreshToken)
            return true
        } catch {
            return false
        }
    }

    /// Handle 401: try refresh, if that fails trigger logout
    private func handle401() async {
        let refreshed = await attemptTokenRefresh()
        if !refreshed {
            DispatchQueue.main.async { [weak self] in
                self?.onUnauthorized?()
            }
        }
    }

    func get<T: Decodable>(_ type: T.Type, path: String, queryItems: [URLQueryItem] = []) async throws -> T {
        var req = try makeGET(path: path, queryItems: queryItems)
        let (data, resp) = try await URLSession.shared.data(for: req)

        if let http = resp as? HTTPURLResponse, http.statusCode == 401 || http.statusCode == 403 {
            let refreshed = await attemptTokenRefresh()
            if refreshed {
                req = try makeGET(path: path, queryItems: queryItems)
                let (retryData, retryResp) = try await URLSession.shared.data(for: req)
                try validate(retryResp, data: retryData)
                return try JSONDecoder().decode(T.self, from: retryData)
            } else {
                await handle401()
            }
        }

        try validate(resp, data: data)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func post<T: Decodable>(_ type: T.Type, path: String, body: Encodable) async throws -> T {
        let req = try makeRequest(method: "POST", path: path, body: body)
        let (data, resp) = try await URLSession.shared.data(for: req)

        if let http = resp as? HTTPURLResponse, http.statusCode == 401 || http.statusCode == 403, !path.contains("/api/auth/") {
            let refreshed = await attemptTokenRefresh()
            if refreshed {
                let retryReq = try makeRequest(method: "POST", path: path, body: body)
                let (retryData, retryResp) = try await URLSession.shared.data(for: retryReq)
                try validate(retryResp, data: retryData)
                return try JSONDecoder().decode(T.self, from: retryData)
            } else {
                await handle401()
            }
        }

        try validate(resp, data: data)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func postEmpty(path: String, body: Encodable? = nil) async throws {
        let req = try makeRequest(method: "POST", path: path, body: body)
        let (data, resp) = try await URLSession.shared.data(for: req)
        try validate(resp, data: data)
    }

    func put<T: Decodable>(_ type: T.Type, path: String, body: Encodable) async throws -> T {
        let req = try makeRequest(method: "PUT", path: path, body: body)
        let (data, resp) = try await URLSession.shared.data(for: req)

        if let http = resp as? HTTPURLResponse, http.statusCode == 401 || http.statusCode == 403 {
            let refreshed = await attemptTokenRefresh()
            if refreshed {
                let retryReq = try makeRequest(method: "PUT", path: path, body: body)
                let (retryData, retryResp) = try await URLSession.shared.data(for: retryReq)
                try validate(retryResp, data: retryData)
                return try JSONDecoder().decode(T.self, from: retryData)
            } else {
                await handle401()
            }
        }

        try validate(resp, data: data)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func delete(path: String) async throws {
        let req = try makeRequest(method: "DELETE", path: path)
        let (data, resp) = try await URLSession.shared.data(for: req)

        if let http = resp as? HTTPURLResponse, http.statusCode == 401 || http.statusCode == 403 {
            let refreshed = await attemptTokenRefresh()
            if refreshed {
                let retryReq = try makeRequest(method: "DELETE", path: path)
                let (retryData, retryResp) = try await URLSession.shared.data(for: retryReq)
                try validate(retryResp, data: retryData)
                return
            } else {
                await handle401()
            }
        }

        try validate(resp, data: data)
    }

    func patch<T: Decodable>(_ type: T.Type, path: String, queryItems: [URLQueryItem] = []) async throws -> T {
        let req = try makeRequest(method: "PATCH", path: path, queryItems: queryItems)
        let (data, resp) = try await URLSession.shared.data(for: req)

        if let http = resp as? HTTPURLResponse, http.statusCode == 401 || http.statusCode == 403 {
            let refreshed = await attemptTokenRefresh()
            if refreshed {
                let retryReq = try makeRequest(method: "PATCH", path: path, queryItems: queryItems)
                let (retryData, retryResp) = try await URLSession.shared.data(for: retryReq)
                try validate(retryResp, data: retryData)
                return try JSONDecoder().decode(T.self, from: retryData)
            } else {
                await handle401()
            }
        }

        try validate(resp, data: data)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
