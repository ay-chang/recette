import SwiftUI

struct VerifyCodeView: View {
    @EnvironmentObject var session: UserSession
    let email: String
    let password: String
    @Binding var showVerifyCode: Bool
    @State private var codeDigits: [String] = Array(repeating: "", count: 6)
    @State private var isResending = false
    @State private var resendMessage: String?
    @State private var cooldownRemaining = 0
    @State private var cooldownTimer: Timer? = nil
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
                            .foregroundColor(.gray)
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
                                if success {
                                    resendMessage = "Verification code resent to your email."
                                    startCooldown(seconds: 120) // Start 30-second cooldown
                                } else {
                                    resendMessage = session.loginError ?? "Failed to resend code."
                                }
                            }
                        }) {
                            if cooldownRemaining > 0 {
                                Text("Resend Code in \(cooldownRemaining)s")
                                    .foregroundColor(.gray)
                            } else {
                                Text("Resend")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                            }
                        }
                        .disabled(isResending || cooldownRemaining > 0)
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

            Button(action: {
                session.completeSignUpWithCode(email: email, code: fullCode)
            }) {
                Group {
                    if session.isAuthLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Verify")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "#e9c46a"))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(fullCode.count < 6 || session.isAuthLoading)
        }
        .padding()
        .onDisappear {
            cooldownTimer?.invalidate()
            cooldownTimer = nil
        }
    }
    
    
    func startCooldown(seconds: Int) {
        cooldownRemaining = seconds
        cooldownTimer?.invalidate() // cancel existing timer if needed
        
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            cooldownRemaining -= 1
            if cooldownRemaining <= 0 {
                timer.invalidate()
                cooldownTimer = nil
            }
        }
    }

}
