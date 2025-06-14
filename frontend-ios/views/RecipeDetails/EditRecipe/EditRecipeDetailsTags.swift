import SwiftUI

struct EditRecipeDetailsTags: View {
    @Binding var selectedTags: Set<String>
    @Binding var availableTags: [String]
    var onAddTag: () -> Void
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16){
            /** Header */
            HStack {
                Text("Tags")
                    .font(.headline)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(getRows().enumerated().map { RowWrapper(index: $0.offset, row: $0.element) }) { rowWrapper in
                    HStack(alignment: .center, spacing: 8) {
                        ForEach(rowWrapper.row, id: \.self) { tag in
                            if tag == "+ Add tag" {
                                Button(action: onAddTag) {
                                    Text("+ Add tag")
                                        .font(.body)
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
                }
            }
            
        }
        
    }


    private func getRows() -> [[String]] {
        var rows: [[String]] = []
        var currentRow: [String] = []
        var rowWidth: CGFloat = 0
        let padding: CGFloat = 5
        let maxWidth = UIScreen.main.bounds.width - 16  // approximate screen width, adjust with size of tag

        let allTags = availableTags + ["+ Add tag"]

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

