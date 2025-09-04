import SwiftUI

struct AddTagView: View {
    @EnvironmentObject var session: UserSession
    @Binding var showAddTag: Bool
    @State private var newTagName: String = ""

    // Alert state
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSaving = false

    var body: some View {
        ZStack {
            Text("Add Tag").font(.headline)
            HStack {
                Button("Cancel") { showAddTag = false }
                    .foregroundColor(.black)
                    .fontWeight(.light)

                Spacer()

                Button("Save") {
                    let trimmed = newTagName.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }

                    // Optional client-side de-dupe (case-insensitive)
                    if session.availableTags.contains(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) {
                        alertMessage = "That tag already exists."
                        showAlert = true
                        return
                    }

                    isSaving = true
                    session.addTagToUser(tagName: trimmed) { errorMsg in
                        DispatchQueue.main.async {
                            isSaving = false
                            if let errorMsg = errorMsg {
                                // Show server error (e.g., DuplicateTagException message)
                                alertMessage = errorMsg
                                showAlert = true
                            } else {
                                // Success — now close the sheet
                                showAddTag = false
                            }
                        }
                    }
                }
                .disabled(isSaving)
                .foregroundColor(.black)
                .fontWeight(.light)
            }
        }
        .padding()

        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Organize your recipes with the perfect tags.")
                    .font(.title2).fontWeight(.medium)

                Text("Add a tag below to help categorize and find your recipes faster.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fontWeight(.regular)
                    .padding(.bottom, 8)
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    TextField("Tag", text: $newTagName)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(""),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
