import SwiftUI

struct TagChipView: View {
    let title: String
    let isSelected: Bool
    let toggleAction: () -> Void

    var body: some View {
        Text(title)
            .font(.callout)
            .lineLimit(1)                                   // Only allow one line
            .minimumScaleFactor(0.5)                        // Scale down text if too large
            .allowsTightening(true)                         // Allow squeezing text slightly before truncating
            .fixedSize(horizontal: true, vertical: false)   // Prevent truncation ("..."), make chip expand horizontally
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .foregroundColor(isSelected ? .white : .black)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color(hex: "#e9c46a") : Color.gray.opacity(0.1))
            )
            .onTapGesture {
                toggleAction()
            }
    }
}
