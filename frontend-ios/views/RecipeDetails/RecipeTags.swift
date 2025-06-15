import SwiftUI

struct RecipeTags: View {
    let tags: [String]
    
    var body: some View {
        VStack {
            TagContainerView(
                selectedTags: .constant([]), // Not used in read-only mode
                availableTags: .constant(tags), // This is what gets displayed
                isReadOnly: true
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
}
