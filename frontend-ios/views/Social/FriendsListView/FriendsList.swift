import SwiftUI

struct FriendsList: View {
    @StateObject private var model = FriendshipListModel()

    var body: some View {
        VStack {
            if model.isLoading {
                ProgressView("Loading friends…")
            } else if let error = model.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if model.friendships.isEmpty {
                Text("No friends yet.")
                    .foregroundColor(.gray)
            } else {
                List(model.friendships) { friend in
                    VStack(alignment: .leading) {
                        Text("@\(friend.friendUsername)")
                            .font(.headline)
                        if let first = friend.friendFirstName,
                           let last = friend.friendLastName,
                           !(first.isEmpty && last.isEmpty) {
                            Text("\(first) \(last)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .onAppear {
            model.loadFriends()
        }
    }
}
