import Foundation

final class RecetteAPI {
    static let shared = RecetteAPI()

    private let baseURL = URL(string: "\(Config.backendBaseURL)")! // no trailing slash

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

    func get<T: Decodable>(_ type: T.Type, path: String, queryItems: [URLQueryItem] = []) async throws -> T {
        let req = try makeGET(path: path, queryItems: queryItems)
        let hasToken = req.value(forHTTPHeaderField: "Authorization") != nil
        print("RecetteAPI GET: \(req.url?.absoluteString ?? "unknown") | Auth: \(hasToken ? "YES" : "NO")")
        let (data, resp) = try await URLSession.shared.data(for: req)
        try validate(resp, data: data)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func post<T: Decodable>(_ type: T.Type, path: String, body: Encodable) async throws -> T {
        let req = try makeRequest(method: "POST", path: path, body: body)
        let (data, resp) = try await URLSession.shared.data(for: req)
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
        try validate(resp, data: data)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func delete(path: String) async throws {
        let req = try makeRequest(method: "DELETE", path: path)
        let (data, resp) = try await URLSession.shared.data(for: req)
        try validate(resp, data: data)
    }

    func patch<T: Decodable>(_ type: T.Type, path: String, queryItems: [URLQueryItem] = []) async throws -> T {
        let req = try makeRequest(method: "PATCH", path: path, queryItems: queryItems)
        let (data, resp) = try await URLSession.shared.data(for: req)
        try validate(resp, data: data)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
