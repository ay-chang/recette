import SwiftUI

struct SearchFriendsView: View {
    @Binding var showSearchView: Bool
    @StateObject private var model = SearchFriendsModel()

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button(action: { showSearchView = false }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("Add Friends")
                    .font(.headline)
                Spacer()
                // Invisible spacer for centering
                Image(systemName: "xmark")
                    .font(.title2)
                    .opacity(0)
            }
            .padding()
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.1)),
                alignment: .bottom
            )

            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search by username", text: $model.query)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onChange(of: model.query) { _ in
                        model.search()
                    }
                if !model.query.isEmpty {
                    Button(action: {
                        model.query = ""
                        model.results = []
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding()

            // Results
            if model.isSearching {
                Spacer()
                ProgressView()
                Spacer()
            } else if model.results.isEmpty && !model.query.isEmpty {
                Spacer()
                Text("No users found")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List(model.results) { result in
                    SearchResultRow(result: result) {
                        model.sendFriendRequest(username: result.username)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
        }
        .task {
            await model.loadContext()
        }
    }
}

struct SearchResultRow: View {
    let result: SearchResult
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 36))
                .foregroundColor(.gray.opacity(0.5))

            VStack(alignment: .leading, spacing: 2) {
                Text(result.username)
                    .font(.body)
                    .fontWeight(.medium)
                if let first = result.firstName {
                    Text(first + (result.lastName.map { " \($0)" } ?? ""))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            switch result.status {
            case .none:
                Button(action: onAdd) {
                    Text("Add")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color.black)
                        .cornerRadius(16)
                }
            case .pending:
                Text("Pending")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
            case .friends:
                Text("Friends")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "#e9c46a"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "#e9c46a").opacity(0.4), lineWidth: 1)
                    )
            }
        }
        .padding(.vertical, 4)
    }
}
