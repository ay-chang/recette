import SwiftUI

struct SocialTopBar: View {
    var requestCount: Int = 0
    @State private var showFriendsListView: Bool = false

    var body: some View {
        HStack {
            Spacer()

            Button(action: {
                showFriendsListView = true
            }) {
                Image(systemName: "person.2")
                    .font(.system(size: 16, weight: .regular))
                    .frame(width: 20, height: 20)
            }
            .padding(10)
            .foregroundColor(Color.black)
            .overlay(
                Circle()
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
            )
            .overlay(alignment: .topTrailing) {
                if requestCount > 0 {
                    Text("\(requestCount)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(minWidth: 16, minHeight: 16)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 4, y: -4)
                }
            }
        }
        .padding(.bottom)
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showFriendsListView) {
            FriendsListView(showFriendsListView: $showFriendsListView)
        }
    }
}
