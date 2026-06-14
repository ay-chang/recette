import Foundation
import Combine

struct SearchResult: Identifiable {
    let id: String
    let username: String
    let firstName: String?
    let lastName: String?
    var status: FriendStatus

    enum FriendStatus {
        case none
        case pending
        case friends
    }
}

@MainActor
class SearchFriendsModel: ObservableObject {
    @Published var query = ""
    @Published var results: [SearchResult] = []
    @Published var isSearching = false

    private var friendUsernames: Set<String> = []
    private var sentUsernames: Set<String> = []
    private var searchTask: Task<Void, Never>?

    func loadContext() async {
        do {
            async let friendsReq = RecetteAPI.shared.get([UserResponse].self, path: "/api/friendships/friends")
            async let sentReq = RecetteAPI.shared.get([UserResponse].self, path: "/api/friendships/sent")
            let (friends, sent) = try await (friendsReq, sentReq)
            friendUsernames = Set(friends.map { $0.username })
            sentUsernames = Set(sent.map { $0.username })
        } catch {
            print("SearchFriendsModel: failed to load context: \(error)")
        }
    }

    func search() {
        searchTask?.cancel()
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            results = []
            return
        }

        isSearching = true
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms debounce
            guard !Task.isCancelled else { return }

            do {
                let users = try await RecetteAPI.shared.get(
                    [UserResponse].self,
                    path: "/api/users/search",
                    queryItems: [URLQueryItem(name: "query", value: trimmed)]
                )
                guard !Task.isCancelled else { return }
                self.results = users.map { user in
                    let status: SearchResult.FriendStatus
                    if friendUsernames.contains(user.username) {
                        status = .friends
                    } else if sentUsernames.contains(user.username) {
                        status = .pending
                    } else {
                        status = .none
                    }
                    return SearchResult(
                        id: user.id,
                        username: user.username,
                        firstName: user.firstName,
                        lastName: user.lastName,
                        status: status
                    )
                }
            } catch {
                if !Task.isCancelled {
                    print("SearchFriendsModel: search error: \(error)")
                }
            }
            self.isSearching = false
        }
    }

    func sendFriendRequest(username: String) {
        Task {
            do {
                let body = SendFriendRequestBody(friendUsername: username)
                try await RecetteAPI.shared.postEmpty(path: "/api/friendships/send", body: body)
                sentUsernames.insert(username)
                if let idx = results.firstIndex(where: { $0.username == username }) {
                    results[idx].status = .pending
                }
            } catch {
                print("SearchFriendsModel: send request error: \(error)")
            }
        }
    }
}

private struct SendFriendRequestBody: Encodable {
    let friendUsername: String
}
