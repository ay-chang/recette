import SwiftUI

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = -1
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: .white.opacity(0.2), location: 0.0),
                    .init(color: .white.opacity(0.7), location: 0.5),
                    .init(color: .white.opacity(0.2), location: 1.0)
                ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .rotationEffect(.degrees(20))
                .offset(x: phase * 250)
                .blendMode(.screen)
                .mask(content.opacity(1))
            )
            .onAppear {
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    phase = 1.2
                }
            }
    }
}

extension View { func shimmer() -> some View { modifier(Shimmer()) } }


