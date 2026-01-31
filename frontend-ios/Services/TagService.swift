import Foundation

final class TagService {
    static let shared = TagService()

    func getMyTags() async throws -> [TagResponse] {
        return try await RecetteAPI.shared.get([TagResponse].self, path: "/api/tags/mine")
    }

    func createTag(name: String) async throws -> TagResponse {
        let request = CreateTagRequest(name: name)
        return try await RecetteAPI.shared.post(TagResponse.self, path: "/api/tags", body: request)
    }

    func deleteTag(name: String) async throws {
        try await RecetteAPI.shared.delete(path: "/api/tags/\(name)")
    }
}
