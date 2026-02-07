import SwiftUI

struct ActionSheetView: View {
    let onDelete: () -> Void
    let onEdit: () -> Void
    @ObservedObject var recipeModel: RecipeDetailsModel
    @Environment(\.dismissSheet) private var dismissSheet

    @State private var showDeleteConfirmation = false

    var body: some View {
        AppSheet(title: "Actions") {
            SheetButton(title: "Edit", icon: "pencil") {
                dismissSheet()
                onEdit()
            }

            SheetButton(title: "Delete Recipe", icon: "trash") {
                showDeleteConfirmation = true
            }

            // TODO: Re-enable share toggle when social features are ready
            // Divider()
            //     .padding(.vertical, 4)
            // Toggle(isOn: Binding(
            //     get: { recipeModel.recipe?.isPublic ?? false },
            //     set: { newValue in
            //         recipeModel.toggleVisibility(newValue)
            //     }
            // )) {
            //     Text("Share with friends")
            //         .foregroundColor(.black)
            // }
            // .tint(Color(hex: "#e9c46a"))
        }
        .alert("Are you sure you want to delete this recipe?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}
