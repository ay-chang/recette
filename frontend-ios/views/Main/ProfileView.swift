import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: UserSession
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            /** Profile Image */
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            
            /** Username **/
            if let username = session.userUsername {
                Text("@\(username)")
                    .foregroundColor(.gray)
                    .padding(.bottom, 24)
            }
            
            
            /** Profiile Options */
            ProfileOptionsList()
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
