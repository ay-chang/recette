import SwiftUI
import GoogleSignIn


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @State private var showForgotPassword = false
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 1)
                    )

                SecureField("Password", text: $password)
                    .padding(16)
                    .background(Color(.white))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 1)
                    )

                Button(action: {
                    session.logIn(email: email, password: password)
                }) {
                    Group {
                        if session.isAuthLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Continue")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(hex: "#e9c46a"))
                    .cornerRadius(10)
                    .font(.title3)
                    .fontWeight(.semibold)
                }
                .disabled(session.isAuthLoading)
                if let error = session.loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 4)
                }

                Button("Forgot password?") {
                    showForgotPassword = true
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .sheet(isPresented: $showForgotPassword) {
                    ForgotPasswordView(showSheet: $showForgotPassword)
                }
            }
            
            // OR separator
            HStack {
                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.2))
                Text("or").foregroundColor(.secondary)
                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.2))
            }
            .padding(.vertical, 4)
            
            
            // Google button
            GoogleLoginButton(onToken: {
                session.logInWithGoogle(idToken: $0)
            }, onError: { error in
                session.loginError = error
            })

            // Apple button
            SignInWithAppleButtonView(onToken: {
                session.logInWithApple(idToken: $0)
            }, onError: { error in
                session.loginError = error
            })

            /* Sign up */
            HStack (alignment: .center) {
                Text("Don't have an account?")
                Button("Sign up") {
                    showSignUp = true
                }
                .bold()
            }
            .font(.subheadline)
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
