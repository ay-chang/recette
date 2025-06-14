import SwiftUI

struct RecipeTags: View {
    let tags: [RecetteSchema.GetRecipeByIDQuery.Data.RecipeById.Tag]

    var body: some View {
        VStack {
            TagContainerView(
                selectedTags: .constant([]), // Not used in read-only mode
                availableTags: .constant(tags.compactMap { $0.name }), // This is what gets displayed
                isReadOnly: true
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
}
