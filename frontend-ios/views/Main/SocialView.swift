import SwiftUI

struct SocialView: View {
    @StateObject private var friendshipsModel = FriendshipsModel()
    
    var body: some View {
        VStack {
            /** Header */
            SocialTopBar()
            
            /** Main content of friends posts*/
            FriendsPostsView()
            
            Spacer()
        }
        .environmentObject(friendshipsModel)
        
        
    
    }
}
