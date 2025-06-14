import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var session: UserSession
    @State private var email = ""
    @State private var password = ""
    @Binding var showSheet: Bool

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    showSheet = false
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .padding()
                        .foregroundColor(.gray)
                }
            }
            
            Text("Sign up with Recette")
                .font(.title2)
                .bold()
                .padding(.bottom, 36)

            /* Sign up form */
            VStack(spacing: 12) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))

                SecureField("Password", text: $password)
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))

                Button(action: {
                    session.signUp(email: email, password: password)
                    if let error = session.loginError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                }) {
                    Text("Sign up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(hex: "#e9c46a"))
                        .cornerRadius(10)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
            }

            /* Or divider */
            HStack {
                Rectangle().frame(height: 1).foregroundColor(.gray)
                Text("or").foregroundColor(.gray).font(.footnote)
                Rectangle().frame(height: 1).foregroundColor(.gray)
            }
            .padding()

            VStack(spacing: 12) {
                SocialLoginButton(label: "Continue with Apple", icon: "apple.logo")
                SocialLoginButton(label: "Continue with Google", icon: "globe")
            }

            Spacer()
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
    }
}
