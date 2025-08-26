import SwiftUI

struct FriendsList: View {
    @EnvironmentObject var friendshipsModel: FriendshipsModel

    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("Your Friends")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical)
                Spacer()
                
            }

            
            
            /** List of friend items*/
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
                    FriendsListItem(friend: friend) { friendUsername in
                        withAnimation {
                            friendshipsModel.removeFriend(friendUsername: friendUsername)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
}
