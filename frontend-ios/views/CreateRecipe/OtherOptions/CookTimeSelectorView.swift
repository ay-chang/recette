import SwiftUI

struct CookTimeSelectorView: View {
    @Binding var cookTimeInMinutes: Int
    @Binding var showSheet: Bool
    
    @State private var tempHours: Int = 0
    @State private var tempMinutes: Int = 0

    var body: some View {
        VStack {
            Text("Select Cook Time")
                .font(.headline)
                .padding()

            HStack(spacing: 32) {
                HStack {
                    Picker("Hours", selection: $tempHours) {
                        ForEach(0..<13) { hour in
                            Text("\(hour)").tag(hour)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 60)
                    .clipped()

                    Text("hours")
                        .foregroundColor(.black.opacity(0.7))
                        .font(.subheadline)
                }

                HStack {
                    Picker("Minutes", selection: $tempMinutes) {
                        ForEach([0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55], id: \.self) { minute in
                            Text("\(minute)").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 60)
                    .clipped()

                    Text("mins")
                        .foregroundColor(.black.opacity(0.7))
                        .font(.subheadline)
                }
            }
            .frame(height: 160)

            Button("Done") {
                cookTimeInMinutes = (tempHours == 0 && tempMinutes == 0) ? 0 : (tempHours * 60 + tempMinutes)
                showSheet = false
            }
            .padding(.top)
        }
        .onAppear {
            tempHours = cookTimeInMinutes / 60
            tempMinutes = cookTimeInMinutes % 60
        }
        .presentationDetents([.height(320)])
    }
}
