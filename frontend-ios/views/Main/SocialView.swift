import SwiftUI

struct SocialView: View {
    var body: some View {
        VStack {
            /** Header */
            SocialTopBar()
            
            /** Main content of friends posts*/
            FriendsPostsView()
            
            Spacer()
        }
        
        
    
    }
}
