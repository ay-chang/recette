import SwiftUI

struct CodeInputFields: View {
    @Binding var codeDigits: [String]
    var loginError: String?
    @FocusState.Binding var focusedField: Int?

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<6, id: \.self) { index in
                TextField("", text: $codeDigits[index])
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 45, height: 55)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(loginError != nil ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .focused($focusedField, equals: index)
                    .onTapGesture {
                        focusedField = index
                    }
                    .onChange(of: codeDigits[index]) {
                        let filtered = codeDigits[index].filter { $0.isNumber }
                        if filtered != codeDigits[index] {
                            codeDigits[index] = filtered
                        }

                        // Handle paste: distribute digits across fields
                        if filtered.count > 1 {
                            let digits = Array(filtered.prefix(6 - index))
                            for (offset, digit) in digits.enumerated() {
                                codeDigits[index + offset] = String(digit)
                            }
                            focusedField = min(index + digits.count, 5)
                            return
                        }

                        if filtered.count == 1 && index < 5 {
                            focusedField = index + 1
                        }

                        if filtered.isEmpty && index > 0 {
                            focusedField = index - 1
                        }
                    }
            }
        }
    }
}
