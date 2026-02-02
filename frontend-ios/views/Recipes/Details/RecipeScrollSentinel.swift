import SwiftUI

/* This file makes it so that we can track our scorlling so the white bar fades in*/

struct RecipeScrollSentinel: View {
    let onScroll: (CGFloat) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 400) // Match RecipeHeaderImage height

            Color.clear
                .frame(height: 1)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {} // required for layout
                            .onChange(of: geo.frame(in: .global).minY) {
                                onScroll($1)
                            }
                    }
                )
        }
    }
}
