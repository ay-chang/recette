import SwiftUI

struct FriendsListView: View {
    @Binding var showFriendsListView: Bool
    
    var body: some View {
        /** Header */
        FriendsListTopBar(showFriendsListView: $showFriendsListView)
        
        /** Main friends list content*/
        FriendsList()
        
        Spacer()
    }
}
