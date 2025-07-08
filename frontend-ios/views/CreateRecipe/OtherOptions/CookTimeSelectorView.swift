import SwiftUI

struct CookTimeSelectorView: View {
    @Binding var cookTimeInMinutes: Int
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text("Cook time")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            ZStack {
                // Continuous Highlight Bar
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 36)
                    .padding(.horizontal, 32)

                HStack(spacing: 32) {
                    // Hour Picker + label
                    HStack(spacing: 4) {
                        Picker("Hours", selection: Binding(
                            get: { cookTimeInMinutes / 60 },
                            set: { cookTimeInMinutes = $0 * 60 + (cookTimeInMinutes % 60) }
                        )) {
                            ForEach(0..<13) { hour in
                                Text("\(hour)")
                                    .frame(maxWidth: .infinity)
                                    .background(Color.clear) // remove default highlight
                                    .clipped()
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 60)
                        .clipped()

                        Text("hr")
                            .foregroundColor(.gray)
                    }

                    // Minute Picker + label
                    HStack(spacing: 4) {
                        Picker("Minutes", selection: Binding(
                            get: { cookTimeInMinutes % 60 },
                            set: { cookTimeInMinutes = (cookTimeInMinutes / 60) * 60 + $0 }
                        )) {
                            ForEach(Array(stride(from: 0, through: 55, by: 5)), id: \.self) { min in
                                Text("\(min)")
                                    .frame(maxWidth: .infinity)
                                    .background(Color.clear)
                                    .clipped()
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 60)
                        .clipped()

                        Text("min")
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        
        
    }
}
