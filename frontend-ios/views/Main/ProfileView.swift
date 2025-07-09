import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: UserSession
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            /** Profile Image, name, and username*/
            VStack () {
                /** Profile Image */
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
                
                /** First and Last Name */
//                if let firstName = session.userFirstName,
//                   let lastName = session.userLastName {
//                    Text("\(firstName) \(lastName)")
//                        .foregroundColor(Color.black)
//                        .font(.headline)
//                }
                
                /** Username **/
                if let username = session.userUsername {
                    Text("@\(username)")
                        .foregroundColor(.gray)
                        .padding(.bottom, 24)
                }
                
            }
            
            
            
            /** Profiile Options */
            ProfileOptionsList()
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
