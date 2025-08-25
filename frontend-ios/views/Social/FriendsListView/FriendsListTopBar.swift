import SwiftUI

struct FriendsListTopBar: View {
    @Binding var showFriendsListView: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                showFriendsListView = false
            }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(Color.gray)
                    .padding(.vertical, 8)
            }
            Spacer()
        }
        .padding()
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.1)),
            alignment: .bottom
        )
        .background(Color.gray.opacity(0.03))
    }
}

