import SwiftUI

struct CreateRecipeDescriptionView: View {
    @ObservedObject var recipe: CreateRecipeModel
    var onNext: () -> Void
    var onBack: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Text("Description")
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
        Text("Describe your recipe and tell us blah blah blah blah.")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
        

        /** Desription Text box */
        VStack (alignment: .leading) {
            Text("Give your recipe a description")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                TextEditor(text: Binding(
                    get: { String(recipe.description.prefix(250)) },
                    set: { newValue in
                        recipe.description = String(newValue.prefix(250))
                    }
                ))
                    .frame(height: 150)
                    .padding(8)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                CharacterCountView(currentCount: recipe.description.count, maxCount: 250)
            }
            
            Spacer()
            
            /** Navigation Buttons */
            HStack {
                Button(action: onBack) {
                    Text("Back")
                        .padding()
                        .foregroundColor(.black)
                        .underline()
                }
                
                Spacer()

                Button(action: onNext) {
                    Text("Next")
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
