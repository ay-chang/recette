import SwiftUI

struct FriendsListView: View {
    @EnvironmentObject var friendshipsModel: FriendshipsModel
    @Binding var showFriendsListView: Bool
    @StateObject private var friendRequestsModel = FriendRequestsModel()
    @State private var showSearchView = false

    var body: some View {
        VStack(spacing: 0) {
            /** Header */
            FriendsListTopBar(
                showFriendsListView: $showFriendsListView,
                showSearchView: $showSearchView
            )

            ScrollView {
                VStack(spacing: 0) {
                    /** Friend requests section (shown at top if any pending) */
                    FriendRequestsSection(model: friendRequestsModel)

                    /** Main friends list content */
                    FriendsList()
                }
            }
        }
        .onAppear {
            friendshipsModel.loadFriends()
            friendRequestsModel.loadRequests()
        }
        .fullScreenCover(isPresented: $showSearchView) {
            SearchFriendsView(showSearchView: $showSearchView)
        }
    }
}
