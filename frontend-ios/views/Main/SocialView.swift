import SwiftUI

struct SocialView: View {
    @StateObject private var friendshipsModel = FriendshipsModel()
    
    var body: some View {
        VStack (spacing: 0) {
            /** Header */
            SocialTopBar()
            
            /** Main content of friends posts*/
            FriendsPostsView()
            
            Spacer()
        }
        .environmentObject(friendshipsModel)
        
        
    
    }
}
