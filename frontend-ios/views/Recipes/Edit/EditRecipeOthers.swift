import SwiftUI

struct EditRecipeOthers: View {
    @Binding var difficulty: String?
    @Binding var servingSize: Int
    @Binding var cookTimeInMinutes: Int
    @State private var showDifficulty: Bool = false
    @State private var showServingSize: Bool = false
    @State private var showCookTime: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            /** Difficulty */
            Button(action: {
                showDifficulty = true
            }) {
                HStack (spacing: 2) {
                    Text("Difficulty: ")
                    Text("\(difficulty ?? "None")")
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .foregroundColor(.black)
            }
            .sheet(isPresented: $showDifficulty) {
                DifficultySelectorView(selectedDifficulty: $difficulty, showDifficulty: $showDifficulty)
            }

            /** Serving Size */
            Button(action: {
                showServingSize = true
            }) {
                HStack (spacing: 2) {
                    Text("Serving Size: ")
                    Text("\(servingSize == 0 ? "None" : (servingSize >= 10 ? "\(servingSize)+" : "\(servingSize)"))")
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .foregroundColor(.black)
            }
            .sheet(isPresented: $showServingSize) {
                ServingSizeSelectorView(servingSize: $servingSize, showSheet: $showServingSize)
            }

            /** Cook Time */
            Button(action: {
                showCookTime = true
            }) {
                HStack (spacing: 2) {
                    if cookTimeInMinutes == 0 {
                        HStack (spacing: 2) {
                            Text("Cook Time: ")
                            Text("None")
                                .fontWeight(.medium)
                        }
                    } else {
                        let hours = cookTimeInMinutes / 60
                        let minutes = cookTimeInMinutes % 60
                        HStack (spacing: 2) {
                            Text("Cook Time: ")
                            Text("\(hours > 0 ? "\(hours) hours " : "")\(minutes) mins")
                                .fontWeight(.medium)
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .foregroundColor(.black)
            }
            .sheet(isPresented: $showCookTime) {
                CookTimeSelectorView(cookTimeInMinutes: $cookTimeInMinutes, showSheet: $showCookTime)
            }
        }
    }
}
