import SwiftUI

struct DifficultySelectorView: View {
    @Binding var selectedDifficulty: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Select difficulty")
                .font(.headline)

            HStack(spacing: 16) {
                ForEach(["Easy", "Medium", "Hard"], id: \.self) { level in
                    Button(action: {
                        if selectedDifficulty == level {
                            selectedDifficulty = nil
                        } else {
                            selectedDifficulty = level
                        }
                    }) {
                        HStack {
                            Text(level)
                                .foregroundColor(selectedDifficulty == level ? .white : .black)
                                .font(.callout)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity)
                        .background(selectedDifficulty == level ? Color(hex: "#e9c46a") : Color.white)
                        .cornerRadius(10)
                        .animation(.linear(duration: 0.05), value: selectedDifficulty)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
            }
        }
    }
}
