import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @EnvironmentObject var session: UserSession

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Log in to your Recette account")
                .font(.title2)
                .bold()
                .padding(.bottom, 36)

            /* Login and Sign up form */
            VStack(spacing: 12) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(10)
                    .overlay( // apply a rounded border
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 1)
                    )

                SecureField("Password", text: $password)
                    .padding(16)
                    .background(Color(.white))
                    .cornerRadius(10)
                    .overlay( // apply a rounded border
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 1)
                    )

                Button(action: {
                    session.logIn(email: email, password: password)
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(hex: "#e9c46a"))
                        .cornerRadius(10)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                if let error = session.loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 4)
                }
            }

            /* Or Divider*/
            HStack {
                Rectangle().frame(height: 1).foregroundColor(.gray)
                Text("or").foregroundColor(.gray).font(.footnote)
                Rectangle().frame(height: 1).foregroundColor(.gray)
            }
            .padding()
            
            /* Social Login buttons */
            VStack(spacing: 12) {
                SocialLoginButton(label: "Continue with Apple", icon: "apple.logo")
                SocialLoginButton(label: "Continue with Google", icon: "globe") // Replace with proper Google icon later
            }

            /* Sign up */
            HStack {
                Text("Don't have an account?")
                Button("Sign up") {
                    showSignUp = true
                }
                .bold()
            }
            .font(.footnote)
            .padding(.top, 16)
            .sheet(isPresented: $showSignUp) {
                SignUpView(showSheet: $showSignUp)
            }

            Spacer()
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            session.clearLoginError()
        }
    }
}

struct SocialLoginButton: View {
    let label: String
    let icon: String

    var body: some View {
        Button(action: {
            // TODO: Handle social login
        }) {
            HStack {
                Image(systemName: icon)
                Text(label)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(10)
            .overlay( // apply a rounded border
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            )
        }
    }
}
