import SwiftUI

struct ProfileOptionsList: View {
    @EnvironmentObject var session: UserSession
    @State private var showEditTags = false
    @State private var showAccountDetails = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
            /** Edit Tags Button*/
            ProfileOptionsButton(
                buttonText: "Edit Tags",
                buttonImage: "pencil",
                buttonAction: { showEditTags = true }
            )
            
            /** Settings Button*/
            ProfileOptionsButton(
                buttonText: "Account Settings",
                buttonImage: "gearshape",
                buttonAction: { showAccountDetails = true }
            )
            
            /** Logout Button*/
            Button (action: {
                session.logOut()
            }) {
                HStack (spacing: 8){
                    Image(systemName: "arrow.right.square")
                    Text("Logout")
                }
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 12)
                .foregroundColor(Color.black)
            }
            .overlay(alignment: .top) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.3))
            }

            
        }
        .fullScreenCover(isPresented: $showEditTags) {
            ProfileEditUserTags()
                .environmentObject(session)
        }
        .fullScreenCover(isPresented: $showAccountDetails) {
            ProfileAccountSettingsView()
                .environmentObject(session)
        }
    }
}
