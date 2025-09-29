import SwiftUI
import GoogleSignIn

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
            
            // OR separator
            HStack {
                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.2))
                Text("or").foregroundColor(.secondary)
                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.2))
            }
            .padding(.vertical, 4)
            
            
            // Google button
            GoogleLoginButton {
                // Send the Google ID token to your backend
                session.logInWithGoogle(idToken: $0)
            }

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

/** Reusable Google button */
struct GoogleLoginButton: View {
    let onToken: (String) -> Void

    var body: some View {
        Button {
            guard let vc = UIApplication.shared.topViewController else { return }
            GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
                if let error = error {
                    print("Google sign-in failed:", error.localizedDescription)
                    return
                }
                guard let token = result?.user.idToken?.tokenString else {
                    print("No ID token from Google")
                    return
                }
                print("ID token length: \(token.count)")
                onToken(token) // your LoginView passes this to session.logInWithGoogle
            }

        } label: {
            HStack(spacing: 8) {
                Image(systemName: "g.circle.fill")
                Text("Continue with Google").fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))
        }
    }
}

// Small helper to present Google’s sheet from SwiftUI
import UIKit
extension UIApplication {
    var topViewController: UIViewController? {
        connectedScenes.compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController?.presentedViewController
        ??
        connectedScenes.compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
