import SwiftUI

struct CreateRecipeOthersStep: View {
    @ObservedObject var recipe: CreateRecipeModel
    var onBack: () -> Void
    var onFinish: () -> Void
    var onCancel: () -> Void
    
    @State private var prepTime: String = ""

    var body: some View {
        // Header
        ZStack {
            Text("Other options")
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
        .padding()
        
        // Intro Box
        Text("These options are optional but can give your recipe more detail.")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
        
        VStack(alignment: .leading, spacing: 24) {
            /** Difficulty */
            DifficultySelector(selectedDifficulty: $recipe.difficulty)
            
            /** Serving Size */
            servingSizeSelector(servingSize: $recipe.servingSize)
            
            /** Cook Time */
            cookTimeSelector(cookTimeInMinutes: $recipe.cookTimeInMinutes)
            
            Spacer()
            
            // Navigation Buttons
            HStack {
                Button(action: onBack) {
                    Text("Back")
                        .padding()
                        .foregroundColor(.black)
                        .underline()
                }
                
                Spacer()

                Button(action: onFinish) {
                    Text("Finish")
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.top, 4)
        }
        .padding()

    }
}

struct DifficultySelector: View {
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

struct servingSizeSelector: View {
    @Binding var servingSize: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Serving Size")
                    .font(.headline)
                Spacer()
            }

            /** Minus Button*/
            HStack(spacing: 8) {
                Spacer()
                Button(action: {
                    if servingSize > 0 {
                        servingSize -= 1
                    }
                }) {
                    Text("–")
                        .font(.title2)
                        .frame(width: 40, height: 40)
                        .background(servingSize == 0 ? Color.gray.opacity(0.1) : Color(hex: "#e9c46a"))
                        .foregroundColor(servingSize == 0 ? Color.black : Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(servingSize == 0 ? Color.gray.opacity(0.1) : Color.clear, lineWidth: 1)
                        )
                }

                /** Serving Size text*/
                HStack(spacing: 0) {
                    Text("\(servingSize)")
                        .font(.body)
                        .foregroundColor(.black)
                    Text(" servings")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .frame(minWidth: 80)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                )
                .padding(8)

                /** Plus Button */
                Button(action: {
                    if servingSize < 20 {
                        servingSize += 1
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(servingSize == 20 ? Color.gray.opacity(0.1): Color(hex: "#e9c46a"))
                        .foregroundColor(servingSize == 20 ? Color.black : Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(servingSize == 20 ? Color.gray.opacity(0.1) : Color.clear, lineWidth: 1)
                        )
                }
                
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct cookTimeSelector: View {
    @Binding var cookTimeInMinutes: Int

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Cook time")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                // Fixed width time display
                Text(formattedTime(minutes: cookTimeInMinutes))
                    .font(.body)
                    .frame(width: 115, height: 36) // fixed size
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )

                Slider(
                    value: Binding(
                        get: { Double(cookTimeInMinutes) },
                        set: { cookTimeInMinutes = Int($0) }
                    ),
                    in: 0...(12 * 60),
                    step: 5
                )
                .accentColor(Color(hex: "#e9c46a")) // Recette background color
                .frame(width: 250)
            }
        }
    }

    func formattedTime(minutes: Int) -> String {
        let hrs = minutes / 60
        let mins = minutes % 60
        if hrs > 0 {
            if mins > 0 {
                return "\(hrs) hr \(mins) min"
            } else {
                return "\(hrs) hr"
            }
        } else {
            return "\(mins) min"
        }
    }
}



