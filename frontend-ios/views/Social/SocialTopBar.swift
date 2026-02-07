import SwiftUI

struct SocialTopBar: View {
    @State private var showFriendsListView: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                showFriendsListView = true
            }) {
                Image(systemName: "person.2")
                    .font(.title2)
                    .foregroundColor(Color.gray)
                    .padding(.vertical, 8)
            }
        }
        .padding(.bottom)
        .padding(.horizontal)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.1)),
            alignment: .bottom
        )
        .background(Color.gray.opacity(0.03))
        .fullScreenCover(isPresented: $showFriendsListView) {
            FriendsListView(showFriendsListView: $showFriendsListView)
        }
    }
}
