import SwiftUI

struct GrocerySheet: View {
    @ObservedObject var groceriesModel: GroceriesModel
    @Environment(\.dismissSheet) private var dismissSheet

    @State private var showDeleteAllConfirmation = false

    var body: some View {
        AppSheet(title: "Groceries") {
            SheetButton(title: "Delete by recipe", icon: "trash") {
                dismissSheet()
                groceriesModel.isEditing.toggle()
            }

            SheetButton(title: "Delete all", icon: "trash.fill", isDestructive: true) {
                showDeleteAllConfirmation = true
            }
        }
        .alert("Are you sure you want to delete all groceries?", isPresented: $showDeleteAllConfirmation) {
            Button("Delete All", role: .destructive) {
                groceriesModel.deleteAllGroceries()
                dismissSheet()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}
