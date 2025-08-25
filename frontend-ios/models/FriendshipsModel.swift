import Foundation
import Apollo

struct FriendshipItem: Identifiable {
    let friendId: String
    let friendFirstName: String?
    let friendLastName: String?
    let friendUsername: String

    var id: String { friendId }  // Identifiable
}

class FriendshipsModel: ObservableObject {
    @Published var friendships: [FriendshipItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadFriends(currentUserId: String? = nil) {
        isLoading = true
        errorMessage = nil
        
        let query = RecetteSchema.FriendsQuery() // operation defined in friends.graphql
        
        Network.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let graphQLResult):
                if let users = graphQLResult.data?.friends {
                    let mapped: [FriendshipItem] =
                        (graphQLResult.data?.friends ?? [])
                        .compactMap { $0 } // unwrap [Friend?] -> [Friend]
                        .compactMap { u -> FriendshipItem? in
                            guard let username = u.username else { return nil }

                            let friendId = String(describing: u.id) // works for String or GraphQLID
                            return FriendshipItem(
                                friendId: friendId,
                                friendFirstName: u.firstName,
                                friendLastName: u.lastName,
                                friendUsername: username
                            )
                        }

                    DispatchQueue.main.async {
                        self.friendships = mapped
                        self.isLoading = false
                    }
                } else if let errors = graphQLResult.errors {
                    DispatchQueue.main.async {
                        self.errorMessage = errors.compactMap { $0.message }.joined(separator: "\n")
                        self.isLoading = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Unexpected: no data and no errors."
                        self.isLoading = false
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
