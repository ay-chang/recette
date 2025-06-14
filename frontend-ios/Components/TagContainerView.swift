import SwiftUI

struct TagContainerView: View {
    @Binding var selectedTags: Set<String>
    @Binding var availableTags: [String]
    var addTagAction: (() -> Void)? = nil
    var isReadOnly: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(getRows().enumerated().map { RowWrapper(index: $0.offset, row: $0.element) }) { rowWrapper in
                HStack(alignment: .center, spacing: 8) {
                    ForEach(rowWrapper.row, id: \.self) { tag in
                        if tag == "+ Add tag", !isReadOnly, let action = addTagAction {
                            Button(action: action) {
                                Text("+ Add tag")
                                    .font(.callout)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .foregroundColor(.black)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.1))
                                    )
                            }
                        } else {
                            TagChipView(
                                title: tag,
                                isSelected: selectedTags.contains(tag),
                                isReadOnly: isReadOnly,
                                toggleAction: {
                                    if selectedTags.contains(tag) {
                                        selectedTags.remove(tag)
                                    } else {
                                        selectedTags.insert(tag)
                                    }
                                }
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func getRows() -> [[String]] {
        var rows: [[String]] = []
        var currentRow: [String] = []
        var rowWidth: CGFloat = 0
        let padding: CGFloat = 5
        let maxWidth = UIScreen.main.bounds.width - 16

        let allTags = isReadOnly ? Array(availableTags) : (availableTags + ["+ Add tag"])

        for tag in allTags {
            let itemWidth = textWidth(for: tag)
            if rowWidth + itemWidth > maxWidth {
                rows.append(currentRow)
                currentRow = [tag]
                rowWidth = itemWidth
            } else {
                currentRow.append(tag)
                rowWidth += itemWidth + padding
            }
        }

        if !currentRow.isEmpty {
            rows.append(currentRow)
        }

        return rows
    }

    private func textWidth(for text: String) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: UIFont.systemFontSize)
        ]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width + 30
    }
}


struct RowWrapper: Identifiable {
    let id = UUID()
    let index: Int
    let row: [String]
}
