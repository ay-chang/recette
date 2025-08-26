import SwiftUI

struct FriendsListView: View {
    @EnvironmentObject var friendshipsModel: FriendshipsModel
    @Binding var showFriendsListView: Bool
    
    var body: some View {
        VStack(spacing: 0)  {
            /** Header */
            FriendsListTopBar(showFriendsListView: $showFriendsListView)
            
            /** Main friends list content*/
            FriendsList()
                .onAppear {
                    (friendshipsModel.loadFriends())
                }
            
            
            Spacer()
        }
            
    }

}
