import SwiftUI

struct ProfileView : View {
    @EnvironmentObject var session: UserSession
    
    var body: some View {
        VStack(spacing: 20) {
            if let username = session.userUsername {
                Text("Welcome \(username)")
            }
            
            Button(action: {
                session.logOut()
            }) {
            Text("Log out")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(10)
                .font(.headline)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}


//#Preview {
//    ProfileView()
//}
