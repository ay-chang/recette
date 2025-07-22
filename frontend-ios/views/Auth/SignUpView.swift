import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var session: UserSession
    @State private var email = ""
    @State private var password = ""
    @State private var showVerifyCode = false
    @State private var isPasswordVisible = false
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
            VStack(alignment: .leading, spacing: 12) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))


                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                            .font(.system(size: 17))
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, !isPasswordVisible ? 16 : 15.5)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))

                
                
                Text("Must contain at least 8 characters and have a capital letter")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                Button(action: {
                    session.sendVerificationCode(email: email, password: password) { success in
                        if success {
                            showVerifyCode = true
                        }
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
                
                if let error = session.loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }

            /* Or divider */
//            HStack {
//                Rectangle().frame(height: 1).foregroundColor(.gray)
//                Text("or").foregroundColor(.gray).font(.footnote)
//                Rectangle().frame(height: 1).foregroundColor(.gray)
//            }
//            .padding()

//            VStack(spacing: 12) {
//                SocialLoginButton(label: "Continue with Apple", icon: "apple.logo")
//                SocialLoginButton(label: "Continue with Google", icon: "globe")
//            }

            Spacer()
        }
        .sheet(isPresented: $showVerifyCode) {
            VerifyCodeView(email: email, password: password, showVerifyCode: $showVerifyCode)
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            session.clearLoginError()
        }

    }
}
