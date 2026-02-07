import SwiftUI

struct GrocerySheet: View {
    @Binding var showOptions: Bool
    @Binding var isEditing: Bool

    var body: some View {
        VStack(spacing: 12) {
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(.gray.opacity(0.8))
                .padding(.top, 10)
                .padding(.bottom, 4)

            Text("Groceries")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)

            Divider()
                .padding(.bottom, 4)

            Button(action: {
                showOptions = false
                isEditing.toggle()
            }) {
                HStack {
                    Text("Delete by recipe")
                    Spacer()
                    Image(systemName: "trash")
                }
                .padding(.vertical, 12)
                .foregroundColor(.black)
            }

            Button(action: {
                // TODO: implement delete all
            }) {
                HStack {
                    Text("Delete all")
                    Spacer()
                    Image(systemName: "trash.fill")
                }
                .padding(.vertical, 12)
                .foregroundColor(.red)
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .presentationDetents([.medium])
        .presentationBackground(.white)
    }
}
