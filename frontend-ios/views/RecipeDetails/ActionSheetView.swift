import SwiftUI

struct ActionSheetView: View {
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack(spacing: 0) {
            
            /** Little thin top gray bar */
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(.gray).opacity(0.8)
                .padding(.top, 10)
            
            /** Title */
            Text("Actions")
                .font(.headline)
                .padding(.vertical, 24)

            /** Light background section */
            VStack(spacing: 0) {
                ActionSheetButton(title: "Edit", icon: "pencil", role: .none) {
                    onEdit()
                }

                Divider()

                ActionSheetButton(title: "Delete Recipe", icon: "trash", role: .destructive) {
                    showDeleteConfirmation = true
                }

            }
            .background(Color(.white))
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.bottom, 24)
        .background(Color(UIColor.systemGroupedBackground))
        .cornerRadius(20)
        .alert("Are you sure you want to delete this recipe?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

struct ActionSheetButton: View {
    var title: String
    var icon: String
    var role: ButtonRole? = nil
    var action: () -> Void

    var body: some View {
        Button(role: role, action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(title)
                Spacer()
            }
            .foregroundColor(role == .destructive ? .red : .primary)
            .padding()
        }
    }
}
