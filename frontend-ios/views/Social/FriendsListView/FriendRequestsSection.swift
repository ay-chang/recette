import SwiftUI

struct FriendRequestsSection: View {
    @ObservedObject var model: FriendRequestsModel

    var body: some View {
        if !model.requests.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                Text("Friend Requests")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical)

                ForEach(model.requests) { request in
                    FriendRequestRow(request: request,
                        onAccept: { model.acceptRequest(username: request.username) },
                        onDecline: { model.declineRequest(username: request.username) }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct FriendRequestRow: View {
    let request: FriendRequestItem
    let onAccept: () -> Void
    let onDecline: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 36))
                .foregroundColor(.gray.opacity(0.5))

            VStack(alignment: .leading, spacing: 2) {
                Text(request.username)
                    .font(.body)
                    .fontWeight(.medium)
                if let first = request.firstName {
                    Text(first + (request.lastName.map { " \($0)" } ?? ""))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Button(action: onAccept) {
                Text("Accept")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Color.black)
                    .cornerRadius(16)
            }

            Button(action: onDecline) {
                Image(systemName: "xmark")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(8)
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
            }
        }
        .padding(.vertical, 4)
    }
}
