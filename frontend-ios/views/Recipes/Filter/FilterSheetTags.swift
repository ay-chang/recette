import SwiftUI

struct FilterSheetTags: View {
    @ObservedObject var filterRecipesModel: FilterRecipesModel
    @EnvironmentObject var session: UserSession
    
    var body: some View {
        VStack (alignment: .leading, spacing: 12) {
            /** Title */
            Text("Tags")
                .font(.title3)
                .bold()

            TagContainerView(
                selectedTags: $filterRecipesModel.selectedTags,
                availableTags: $session.availableTags,
                showsAddTagButton: false
            )
        }
    }
}
