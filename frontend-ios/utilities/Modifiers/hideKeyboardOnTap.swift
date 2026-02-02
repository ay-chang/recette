import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        modifier(HideKeyboardOnTapModifier())
    }
}

struct HideKeyboardOnTapModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .gesture(
                TapGesture()
                    .onEnded {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    }
            )
    }
}
