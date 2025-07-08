import SwiftUI

struct EditRecipeDetailsTags: View {
    @Binding var selectedTags: Set<String>
    @Binding var availableTags: [String]
    var onAddTag: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            /** Header */
            HStack {
                Text("Tags")
                    .font(.headline)
                Spacer()
            }

            /** Reusable TagContainerView **/
            TagContainerView(
                selectedTags: $selectedTags,
                availableTags: $availableTags,
                addTagAction: onAddTag
            )
        }
    }
}
