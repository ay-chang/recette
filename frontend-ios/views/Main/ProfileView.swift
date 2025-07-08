import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: UserSession
    @State private var showEditTags = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            // Profile icon
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
//                .shadow(radius: 2)
            
            // Username
            if let username = session.userUsername {
//                Text(username)
//                    .font(.title)
//                    .fontWeight(.bold)
                
                Text("@\(username)")
                    .foregroundColor(.gray)
            }
            
            /** Edit Tags button */
            Button(action: {
                showEditTags = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Tags")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            
            // Logout button
            Button(action: {
                session.logOut()
            }) {
                HStack {
                    Image(systemName: "arrow.right.square")
                    Text("Logout")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
            .foregroundColor(.black)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showEditTags) {
            ProfileEditUserTags()
                .environmentObject(session)
        }
    }
}
