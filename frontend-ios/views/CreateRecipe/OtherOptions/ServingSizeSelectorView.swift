import SwiftUI

struct ServingSizeSelectorView: View {
    @Binding var servingSize: Int  // 0 = none
    @Binding var showSheet: Bool
    @State private var tempSelection: String = "—"

    private let options: [String] = ["—"] + (1...20).map { "\($0)" }

    var body: some View {
        VStack {
            Text("Select Serving Size")
                .font(.headline)
                .padding()

            Picker("Serving Size", selection: $tempSelection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(height: 150)

            Button("Done") {
                servingSize = (tempSelection == "—") ? 0 : Int(tempSelection) ?? 0
                showSheet = false
            }
            .padding()
        }
        .presentationDetents([.height(300)])
        .onAppear {
            tempSelection = servingSize == 0 ? "—" : "\(servingSize)"
        }
    }
}
