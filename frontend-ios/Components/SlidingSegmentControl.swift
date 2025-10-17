import SwiftUI

struct SlidingSegmentedControl: View {
    let segments: [String]
    @Binding var selection: Int
    @Namespace private var ns

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments.indices, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                        selection = i
                    }
                } label: {
                    Text(segments[i])
                        .font(i == selection ? .headline : .subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(i == selection ? Color(hex: "#e9c46a") : .black.opacity(0.7))
                        .background(
                            ZStack {
                                if i == selection {
                                    Capsule()
                                        .fill(Color.white)
                                        .matchedGeometryEffect(id: "SEGMENT", in: ns)
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }
        }
        .padding(3)
        .background(Color.black.opacity(0.08))
        .clipShape(Capsule())
    }
}
