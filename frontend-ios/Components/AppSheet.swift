import SwiftUI

// MARK: - Environment key for dismissing custom sheet

private struct SheetDismissKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var dismissSheet: () -> Void {
        get { self[SheetDismissKey.self] }
        set { self[SheetDismissKey.self] = newValue }
    }
}

// MARK: - Bottom Sheet View Modifier

extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.overlay {
            BottomSheetOverlay(isPresented: isPresented, content: content)
        }
    }
}

private struct BottomSheetOverlay<Content: View>: View {
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    @State private var dragOffset: CGFloat = 0

    private func dismiss() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
            isPresented = false
            dragOffset = 0
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if isPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)

                content()
                    .environment(\.dismissSheet, dismiss)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.white
                            .clipShape(
                                .rect(topLeadingRadius: 16, topTrailingRadius: 16)
                            )
                            .ignoresSafeArea(edges: .bottom)
                    )
                    .offset(y: max(dragOffset, 0))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.height
                            }
                            .onEnded { value in
                                if value.translation.height > 120 {
                                    dismiss()
                                } else {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                        dragOffset = 0
                                    }
                                }
                            }
                    )
                    .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea()
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: isPresented)
    }
}

// MARK: - AppSheet

struct AppSheet<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    @Environment(\.dismissSheet) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(.gray.opacity(0.8))
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 12)

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 12)

            Divider()
                .padding(.bottom, 8)

            content()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 44)
    }
}

// MARK: - SheetButton

struct SheetButton: View {
    let title: String
    let icon: String
    var isDestructive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .frame(width: 24)
                Text(title)
                    .font(.body)
                Spacer()
            }
            .foregroundColor(isDestructive ? .red : .primary)
            .padding(.vertical, 10)
        }
    }
}
