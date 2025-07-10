import SwiftUI

struct ProfileAccountSettingsView: View {
    @EnvironmentObject var session: UserSession
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""

    var body: some View {
        // Header Bar "X"
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Account Settings")
                .font(.title)
                .fontWeight(.semibold)
                
            /** First Name Field */
            VStack(alignment: .leading, spacing: 8) {
                Text("First Name")
                    .font(.headline)
                TextField("First Name", text: $firstName)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
            }

            /** Last Name Field */
            VStack(alignment: .leading, spacing: 8) {
                Text("Last Name")
                    .font(.headline)
                TextField("Last Name", text: $lastName)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
            }

            Spacer()

            HStack {
                Spacer()
                Button("Save") {
                    session.updateAccountDetails(firstName: firstName, lastName: lastName) {
                        dismiss()
                    }
                    session.refreshUserDetails()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(.black)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .onAppear {
            firstName = session.userFirstName ?? ""
            lastName = session.userLastName ?? ""
        }
    }
}
