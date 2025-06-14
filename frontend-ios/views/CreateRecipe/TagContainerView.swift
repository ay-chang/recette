import SwiftUI

struct TagContainerView: View {
    @ObservedObject var recipe: CreateRecipeModel
    var addTagAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(getRows().enumerated().map { RowWrapper(index: $0.offset, row: $0.element) }) { rowWrapper in
                HStack(alignment: .center, spacing: 8) {
                    ForEach(rowWrapper.row, id: \.self) { tag in
                        if tag == "+ Add tag" {
                            Button(action: addTagAction) {
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
                                isSelected: recipe.selectedTags.contains(tag),
                                toggleAction: {
                                    if recipe.selectedTags.contains(tag) {
                                        recipe.selectedTags.remove(tag)
                                    } else {
                                        recipe.selectedTags.insert(tag)
                                    }
                                }
                            )
                        }
                    }
                }
            }
        }
    }

    private func getRows() -> [[String]] {
        var rows: [[String]] = []
        var currentRow: [String] = []
        var rowWidth: CGFloat = 0
        let padding: CGFloat = 5
        let maxWidth = UIScreen.main.bounds.width - 16  // Matches padding in parent view

        let allTags = recipe.availableTags + ["+ Add tag"]

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
        return size.width + 30 // padding for chip
    }
}

struct RowWrapper: Identifiable {
    let id = UUID()
    let index: Int
    let row: [String]
}
