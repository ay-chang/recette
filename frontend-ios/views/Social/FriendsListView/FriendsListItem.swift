import SwiftUI

struct FriendsListItem: View {
    let friend: FriendshipItem

    var body: some View {
        HStack() {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 45, height: 45)
                .foregroundColor(.gray)
                .padding(.trailing, 4)

            
            VStack (alignment: .leading){
                Text("\(friend.friendUsername)")
                    .font(.headline)
                if let first = friend.friendFirstName,
                   let last = friend.friendLastName,
                   !(first.isEmpty && last.isEmpty) {
                    Text("\(first) \(last)")
                        .font(.headline)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text("Unadd")
                .font(.callout)
            
        }
        .listRowInsets(EdgeInsets()) // removes default padding
        .listRowSeparator(.hidden)   // hides separator lines
        .background(Color.clear)     // removes background behind each row
        
        
    }
}
