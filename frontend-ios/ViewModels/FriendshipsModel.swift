import Foundation

struct FriendshipItem: Identifiable {
    let friendId: String
    let friendFirstName: String?
    let friendLastName: String?
    let friendUsername: String

    var id: String { friendId }
}

@MainActor
class FriendshipsModel: ObservableObject {
    @Published var friendships: [FriendshipItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadFriends() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let users = try await RecetteAPI.shared.get([UserResponse].self, path: "/api/friendships/friends")

                self.friendships = users.map { user in
                    FriendshipItem(
                        friendId: user.id,
                        friendFirstName: user.firstName,
                        friendLastName: user.lastName,
                        friendUsername: user.username
                    )
                }
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func removeFriend(friendUsername: String) {
        Task {
            do {
                try await RecetteAPI.shared.delete(path: "/api/friendships/remove/\(friendUsername)")
                self.friendships.removeAll { $0.friendUsername == friendUsername }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
