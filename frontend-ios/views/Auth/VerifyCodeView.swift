import SwiftUI

struct VerifyCodeView: View {
    @EnvironmentObject var session: UserSession
    let email: String
    let password: String
    @Binding var showVerifyCode: Bool
    @State private var codeDigits: [String] = Array(repeating: "", count: 6)
    @State private var isResending = false
    @State private var resendMessage: String?
    @FocusState private var focusedField: Int?

    var fullCode: String {
        codeDigits.joined()
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Button(action: {
                            showVerifyCode = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .padding()
                                .foregroundColor(.gray)
                        }
                    }

                    Text("Verification Code")
                        .font(.title2)
                        .bold()

                    Text("Enter the 6-digit code sent to your email \(email)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    CodeInputFields(
                        codeDigits: $codeDigits,
                        loginError: session.loginError,
                        focusedField: $focusedField
                    )

                    if let error = session.loginError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 4)
                    }
                    
                    if let resendMessage = resendMessage {
                        Text(resendMessage)
                            .font(.footnote)
                            .foregroundColor(.green)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }
                    
                    HStack (alignment: .bottom) {
                        Text("Didn't receive the code?")
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            isResending = true
                            resendMessage = nil
                            session.sendVerificationCode(email: email, password: password) { success in
                                isResending = false
                                resendMessage = success ? "Verification code resent to your email." : (session.loginError ?? "Failed to resend code.")
                            }
                        }) {
                            Text(isResending ? "Resending..." : "Resend")
                                .fontWeight(.semibold)
                                .underline()
                                .foregroundColor(.black)
                        }
                        .disabled(isResending)
                        .padding(.top, 8)
                    }
                    .font(.subheadline)
                    
                }
            }
            .onAppear {
                focusedField = 0
            }
            .navigationTitle("Verify Email")

            Spacer()

            Button("Verify") {
                session.completeSignUpWithCode(email: email, code: fullCode)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "#e9c46a"))
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(fullCode.count < 6)
        }
        .padding()
    }
}
