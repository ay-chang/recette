import SwiftUI

struct ServingSizeSelectorView: View {
    @Binding var servingSize: Int
    @Binding var showSheet: Bool
    @State private var tempSelection: Int = 0

    private let options: [Int] = [0] + Array(1...10)  // 0 maps to "—", 1–10 are real values

    var body: some View {
        VStack {
            Text("Select Serving Size")
                .font(.headline)
                .padding()

            Picker("Serving Size", selection: $tempSelection) {
                ForEach(options, id: \.self) { option in
                    Text(displayText(for: option)).tag(option)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(height: 150)

            Button("Done") {
                servingSize = tempSelection
                showSheet = false
            }
            .padding()
        }
        .presentationDetents([.height(300)])
        .onAppear {
            tempSelection = servingSize
        }
    }

    private func displayText(for option: Int) -> String {
        switch option {
        case 0: return "—"
        case 10: return "10+"
        default: return "\(option)"
        }
    }
}
