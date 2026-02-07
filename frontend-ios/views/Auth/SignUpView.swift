import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var session: UserSession
    @State private var email = ""
    @State private var password = ""
    @State private var showVerifyCode = false
    @State private var isPasswordVisible = false
    @Binding var showSheet: Bool

    private var isPasswordValid: Bool {
        password.count >= 8 && password.range(of: "[A-Z]", options: .regularExpression) != nil
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    session.clearLoginError()
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

                
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: password.count >= 8 ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(password.count >= 8 ? .green : .gray)
                            .font(.caption)
                        Text("At least 8 characters")
                            .font(.caption)
                            .foregroundColor(password.count >= 8 ? .green : .gray)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: password.range(of: "[A-Z]", options: .regularExpression) != nil ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(password.range(of: "[A-Z]", options: .regularExpression) != nil ? .green : .gray)
                            .font(.caption)
                        Text("Contains a capital letter")
                            .font(.caption)
                            .foregroundColor(password.range(of: "[A-Z]", options: .regularExpression) != nil ? .green : .gray)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: {
                    session.sendVerificationCode(email: email, password: password) { success in
                        if success {
                            showVerifyCode = true
                        }
                    }
                }) {
                    Group {
                        if session.isAuthLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sign up")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(isPasswordValid ? Color(hex: "#e9c46a") : Color(hex: "#e9c46a").opacity(0.5))
                    .cornerRadius(10)
                    .font(.title3)
                    .fontWeight(.semibold)
                }
                .disabled(!isPasswordValid || session.isAuthLoading)
                
                if let error = session.loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 4)
                }
            }
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
