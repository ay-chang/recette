import SwiftUI

struct FriendsList: View {
    @EnvironmentObject var friendshipsModel: FriendshipsModel

    var body: some View {
        VStack {
            if let error = friendshipsModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if friendshipsModel.friendships.isEmpty {
                Text("No friends yet.")
                    .foregroundColor(.gray)
            } else {
                List(friendshipsModel.friendships) { friend in
                    FriendsListItem(friend: friend)
                }
                .listStyle(.plain)
            }
        }
        .padding()
    }
}
