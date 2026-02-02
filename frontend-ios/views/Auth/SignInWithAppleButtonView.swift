import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonView: View {
    let onToken: (String) -> Void

    var body: some View {
        Button {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let delegate = AppleSignInDelegate(onToken: onToken)
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = delegate
            controller.presentationContextProvider = delegate
            controller.performRequests()
        } label: {
            HStack {
                Image("apple-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 9)
            .frame(height: 54)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(Text("Continue with Apple").fontWeight(.semibold).foregroundColor(.black))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))
        }
    }
}

/// Delegate for ASAuthorizationController. Held alive via a static reference
/// until the auth sheet completes, since the controller does not retain its delegate.
private class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    static var current: AppleSignInDelegate?

    let onToken: (String) -> Void

    init(onToken: @escaping (String) -> Void) {
        self.onToken = onToken
        super.init()
        AppleSignInDelegate.current = self
    }

    func authorizationController(controller: ASAuthorizationController, didFailWithError error: Error) {
        print("Apple sign-in failed:", error.localizedDescription)
        AppleSignInDelegate.current = nil
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        defer { AppleSignInDelegate.current = nil }
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let idToken = String(data: credential.identityToken ?? Data(), encoding: .utf8) else {
            print("No ID token from Apple")
            return
        }
        onToken(idToken)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}
