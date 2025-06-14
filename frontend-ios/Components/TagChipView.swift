import SwiftUI

struct TagChipView: View {
    let title: String
    var isSelected: Bool = false
    var isReadOnly: Bool = false
    var toggleAction: (() -> Void)? = nil

    var body: some View {
        Text(title)
            .font(.callout)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .allowsTightening(true)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .foregroundColor(isReadOnly ? .white : (isSelected ? .white : .black))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isReadOnly ? Color(hex: "#e9c46a") : (isSelected ? Color(hex: "#e9c46a") : Color.gray.opacity(0.1)))
            )
            .onTapGesture {
                if !isReadOnly {
                    toggleAction?()
                }
            }
    }
}



