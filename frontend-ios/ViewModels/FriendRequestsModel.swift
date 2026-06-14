import Foundation

@MainActor
class FriendRequestsModel: ObservableObject {
    @Published var requests: [FriendRequestItem] = []
    @Published var isLoading = false

    var requestCount: Int { requests.count }

    func loadRequests() {
        isLoading = true
        Task {
            do {
                let users = try await RecetteAPI.shared.get([UserResponse].self, path: "/api/friendships/requests")
                self.requests = users.map { user in
                    FriendRequestItem(
                        id: user.id,
                        username: user.username,
                        firstName: user.firstName,
                        lastName: user.lastName
                    )
                }
            } catch {
                print("FriendRequestsModel: failed to load requests: \(error)")
            }
            self.isLoading = false
        }
    }

    func acceptRequest(username: String) {
        Task {
            do {
                try await RecetteAPI.shared.postEmpty(path: "/api/friendships/accept/\(username)")
                self.requests.removeAll { $0.username == username }
            } catch {
                print("FriendRequestsModel: accept error: \(error)")
            }
        }
    }

    func declineRequest(username: String) {
        Task {
            do {
                try await RecetteAPI.shared.delete(path: "/api/friendships/decline/\(username)")
                self.requests.removeAll { $0.username == username }
            } catch {
                print("FriendRequestsModel: decline error: \(error)")
            }
        }
    }
}

struct FriendRequestItem: Identifiable {
    let id: String
    let username: String
    let firstName: String?
    let lastName: String?
}
