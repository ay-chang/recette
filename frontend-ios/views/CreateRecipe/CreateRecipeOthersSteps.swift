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
            DifficultySelectorView(selectedDifficulty: $recipe.difficulty)
            
            /** Serving Size */
            ServingSizeSelectorView(servingSize: $recipe.servingSize)
            
            /** Cook Time */
            CookTimeSelectorView(cookTimeInMinutes: $recipe.cookTimeInMinutes)
            
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

