import SwiftUI

struct TagChipView: View {
    let title: String
    var isSelected: Bool = false
    var isReadOnly: Bool = false
    var isInEditMode: Bool = false
    var toggleAction: (() -> Void)? = nil
    var deleteAction: (() -> Void)? = nil
    
    var showsDeleteIcon: Bool {
        isInEditMode && title != "+ Add tag"
    }

    var body: some View {
        HStack (spacing: 4){
            Text(title)
                .font(.callout)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .allowsTightening(true)
                .fixedSize(horizontal: true, vertical: false)
            
            if showsDeleteIcon {
                Button(action: {
                    deleteAction?()
                }) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.6))
                }
                .buttonStyle(BorderlessButtonStyle())
            }

        }
        .padding(.vertical, 4)
        .padding(.horizontal, 10)
        .foregroundColor(isReadOnly ? .white : (isSelected ? .white : .black.opacity(0.7)))
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isReadOnly ? Color(hex: "#e9c46a") : (isSelected ? Color(hex: "#e9c46a") : Color.gray.opacity(0.1)))
        )
        .onTapGesture {
            if !isReadOnly {
                toggleAction?()
            }
        }
    }
}



