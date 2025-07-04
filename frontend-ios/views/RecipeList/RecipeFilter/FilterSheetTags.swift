import SwiftUI

struct FilterSheetTags: View {
    @ObservedObject var filterRecipesModel: FilterRecipesModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 12) {
            /** Title */
            Text("Tags")
                .font(.title3)
                .bold()
            Divider()
            
            TagContainerView(
                selectedTags: $filterRecipesModel.selectedTags,
                availableTags: $filterRecipesModel.availableTags,
                showsAddTagButton: false
            )
        }
    }
}
