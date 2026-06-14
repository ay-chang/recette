import SwiftUI

struct SocialView: View {
    @StateObject private var friendshipsModel = FriendshipsModel()
    @StateObject private var friendRequestsModel = FriendRequestsModel()
    @State private var selectedSegment = 0

    var body: some View {
        VStack(spacing: 0) {
            /** Header */
            SocialTopBar(requestCount: friendRequestsModel.requestCount)

            /** Segmented control */
            SlidingSegmentedControl(
                segments: ["Friends", "Explore"],
                selection: $selectedSegment
            )
            .padding(.horizontal)
            .padding(.vertical, 8)

            /** Tab content */
            if selectedSegment == 0 {
                FriendsPostsView()
            } else {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "sparkles")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("Coming soon")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Discover trending and featured recipes")
                        .font(.subheadline)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Spacer()
                }
            }

            Spacer()
        }
        .environmentObject(friendshipsModel)
        .onAppear {
            friendRequestsModel.loadRequests()
        }
    }
}
