import SwiftUI

struct TagContainerView: View {
    @Binding var selectedTags: Set<String>
    @Binding var availableTags: [String]
    var addTagAction: (() -> Void)? = nil
    var isReadOnly: Bool = false
    var showsAddTagButton: Bool = true
    var isInEditMode: Bool = false
    var deleteAction: ((String) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(getRows().enumerated().map { RowWrapper(index: $0.offset, row: $0.element) }) { rowWrapper in
                HStack(alignment: .center, spacing: 8) {
                    ForEach(rowWrapper.row, id: \.self) { tag in
                        if tag == "+ Add tag", !isReadOnly, showsAddTagButton, let action = addTagAction {
                            TagChipView(
                                title: tag,
                                isSelected: false,
                                isReadOnly: false,
                                isInEditMode: false,
                                toggleAction: action,
                                deleteAction: nil
                            )
                        } else {
                            TagChipView(
                                title: tag,
                                isSelected: selectedTags.contains(tag),
                                isReadOnly: isReadOnly,
                                isInEditMode: isInEditMode,
                                toggleAction: {
                                    if selectedTags.contains(tag) {
                                        selectedTags.remove(tag)
                                    } else {
                                        selectedTags.insert(tag)
                                    }
                                },
                                deleteAction: {
                                        deleteAction?(tag)
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

        let allTags: [String]
        if isReadOnly {
            allTags = availableTags
        } else if showsAddTagButton {
            allTags = availableTags + ["+ Add tag"]
        } else {
            allTags = availableTags
        }

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
        
        let baseWidth = size.width + 30 // original chip padding

        let screenWidth = UIScreen.main.bounds.width

        let xIconWidth: CGFloat
        if isInEditMode {
            xIconWidth = screenWidth >= 430 ? 28 : 25
        } else {
            xIconWidth = 12
        }

        return baseWidth + xIconWidth
    }

}

struct RowWrapper: Identifiable {
    let id = UUID()
    let index: Int
    let row: [String]
}
