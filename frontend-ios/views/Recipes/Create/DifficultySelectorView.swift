import SwiftUI

struct DifficultySelectorView: View {
    @Binding var selectedDifficulty: String?
    @Binding var showDifficulty: Bool
    @State private var tempSelection: String = "-"

    let difficultyOptions = ["—", "Easy", "Medium", "Hard"]

    var body: some View {
        VStack {
            Text("Select Difficulty")
                .font(.headline)
                .padding()

            Picker("Difficulty", selection: $tempSelection) {
                ForEach(difficultyOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(height: 150)

            Button("Done") {
                // If user picked "— None —", save nil
                selectedDifficulty = (tempSelection == "—") ? nil : tempSelection
                showDifficulty = false
            }
            .padding()
        }
        .presentationDetents([.height(300)])
        .onAppear {
            // Preload with current selection, fallback to "None"
            tempSelection = selectedDifficulty ?? "—"
        }
    }
}
