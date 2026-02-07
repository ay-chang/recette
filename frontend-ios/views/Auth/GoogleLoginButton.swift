import SwiftUI
import GoogleSignIn

struct GoogleLoginButton: View {
    let onToken: (String) -> Void
    var onError: ((String) -> Void)?

    var body: some View {
        Button {
            guard let vc = UIApplication.shared.topViewController else { return }
            GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
                if let error = error {
                    onError?(error.localizedDescription)
                    return
                }
                guard let token = result?.user.idToken?.tokenString else {
                    onError?("No ID token received from Google")
                    return
                }
                onToken(token)
            }

        } label: {
            HStack {
                Image("google-g")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .frame(height: 54)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(Text("Continue with Google").fontWeight(.semibold).foregroundColor(.black))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))
        }
    }
}

/** Small helper to present Google’s sheet from SwiftUI */
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

