import SwiftUI

struct VerifyCodeView: View {
    @EnvironmentObject var session: UserSession
    let email: String
    @State private var code = ""
    @Binding var showVerifyCode: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter the 6-digit code sent to \(email)")
                .multilineTextAlignment(.center)

            TextField("Verification Code", text: $code)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))

            Button("Verify") {
                session.completeSignUpWithCode(email: email, code: code)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "#e9c46a"))
            .foregroundColor(.white)
            .cornerRadius(10)

            if let error = session.loginError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Verify Email")
    }
}
