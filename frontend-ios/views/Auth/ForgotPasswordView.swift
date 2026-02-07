import SwiftUI

struct ForgotPasswordView: View {
    @Binding var showSheet: Bool
    @State private var email = ""
    @State private var code = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var step: Step = .enterEmail
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var successMessage: String?

    private enum Step {
        case enterEmail
        case enterCode
    }

    private var isNewPasswordValid: Bool {
        newPassword.count >= 8 && newPassword.range(of: "[A-Z]", options: .regularExpression) != nil
    }

    private var passwordsMatch: Bool {
        !confirmPassword.isEmpty && newPassword == confirmPassword
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: { showSheet = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .padding()
                        .foregroundColor(.gray)
                }
            }

            Text(step == .enterEmail ? "Reset Password" : "Enter Reset Code")
                .font(.title2)
                .bold()
                .padding(.bottom, 12)

            if step == .enterEmail {
                emailStepView
            } else {
                codeStepView
            }

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }

            if let success = successMessage {
                Text(success)
                    .foregroundColor(.green)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }

            Spacer()
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
    }

    private var emailStepView: some View {
        VStack(spacing: 12) {
            Text("Enter your email and we'll send you a reset code.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))

            Button(action: sendResetCode) {
                Group {
                    if isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Send Reset Code")
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
            .disabled(email.isEmpty || isLoading)
        }
    }

    private var codeStepView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Enter the 6-digit code sent to \(email)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            TextField("Reset Code", text: $code)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))

            HStack {
                if isPasswordVisible {
                    TextField("New Password", text: $newPassword)
                } else {
                    SecureField("New Password", text: $newPassword)
                }
                Button(action: { isPasswordVisible.toggle() }) {
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

            SecureField("Confirm Password", text: $confirmPassword)
                .padding(16)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: newPassword.count >= 8 ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(newPassword.count >= 8 ? .green : .gray)
                        .font(.caption)
                    Text("At least 8 characters")
                        .font(.caption)
                        .foregroundColor(newPassword.count >= 8 ? .green : .gray)
                }
                HStack(spacing: 4) {
                    Image(systemName: newPassword.range(of: "[A-Z]", options: .regularExpression) != nil ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(newPassword.range(of: "[A-Z]", options: .regularExpression) != nil ? .green : .gray)
                        .font(.caption)
                    Text("Contains a capital letter")
                        .font(.caption)
                        .foregroundColor(newPassword.range(of: "[A-Z]", options: .regularExpression) != nil ? .green : .gray)
                }
                if !confirmPassword.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(passwordsMatch ? .green : .red)
                            .font(.caption)
                        Text("Passwords match")
                            .font(.caption)
                            .foregroundColor(passwordsMatch ? .green : .red)
                    }
                }
            }
            .padding(.horizontal)

            Button(action: resetPassword) {
                Group {
                    if isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Reset Password")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(isNewPasswordValid && passwordsMatch ? Color(hex: "#e9c46a") : Color(hex: "#e9c46a").opacity(0.5))
                .cornerRadius(10)
                .font(.title3)
                .fontWeight(.semibold)
            }
            .disabled(code.count < 6 || !isNewPasswordValid || !passwordsMatch || isLoading)
        }
    }

    private func sendResetCode() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await AuthService.shared.forgotPassword(email: email)
                DispatchQueue.main.async {
                    isLoading = false
                    successMessage = "If an account exists for this email, a reset code has been sent."
                    step = .enterCode
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func resetPassword() {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        Task {
            do {
                try await AuthService.shared.resetPassword(email: email, code: code, newPassword: newPassword)
                DispatchQueue.main.async {
                    isLoading = false
                    successMessage = "Password reset successfully! You can now log in."
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSheet = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
