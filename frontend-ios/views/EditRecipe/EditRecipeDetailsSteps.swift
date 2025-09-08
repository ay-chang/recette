import SwiftUI

struct EditRecipeDetailsSteps: View {
    @Binding var steps: [String]
    @FocusState private var focusedIndex: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Steps").font(.headline)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 0) {
                /** List of steps to be edited */
                ForEach(steps.indices, id: \.self) { index in
                    /** Red button and text */
                    HStack(alignment: .top) {
                        /** Red button*/
                        Button {
                            steps.remove(at: index)
                            if let f = focusedIndex {
                                if f == index { focusedIndex = nil }
                                else if f > index { focusedIndex = f - 1 }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red.opacity(0.9))
                                .font(.system(size: 16))
                        }

                        /** Actual step text */
                        EditRecipeDetailsStepsContent(text: $steps[index])
                            .focused($focusedIndex, equals: index)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 24) // might need fixing
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3)),
                        alignment: .bottom
                    )
                }
            }

            /** Add step button*/
            Button {
                steps.append("")
                focusedIndex = steps.count - 1 // focus the new step
            } label: {
                HStack {
                    Text("+ Add a step")
                        .font(.callout)
                        .foregroundColor(.black.opacity(0.5))
                    Spacer()
                }
                .padding(.horizontal)
            }
            .buttonStyle(.plain)
        }
        .onAppear { focusedIndex = nil } // so there is no cursor on any step
    }
}

struct EditRecipeDetailsStepsContent: View {
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextEditor(text: $text)
                .padding(.vertical, -8)
                .onChange(of: text) {
                    if text.count > 250 {
                        text = String(text.prefix(250))
                    }
                }
        }
    }
}
