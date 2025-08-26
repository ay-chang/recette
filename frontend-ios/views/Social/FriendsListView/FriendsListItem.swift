import SwiftUI

struct FriendsListItem: View {
    let friend: FriendshipItem
    let onRemove: (String) -> Void 

    var body: some View {
        HStack() {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 45, height: 45)
                .foregroundColor(.gray)
                .padding(.trailing, 4)

            
            VStack (alignment: .leading){
                Text("\(friend.friendUsername)")
                    .font(.callout)
                if let first = friend.friendFirstName,
                   let last = friend.friendLastName,
                   !(first.isEmpty && last.isEmpty) {
                    Text("\(first) \(last)")
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Button(action: {
                onRemove(friend.friendUsername)
            }) {
                Text("Unadd")
                    .font(.footnote)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    )
                    .cornerRadius(15)
            }
        }
        .listRowInsets(EdgeInsets()) // removes default padding
        .listRowSeparator(.hidden)   // hides separator lines
        .background(Color.clear)     // removes background behind each row
        
        
    }
}
