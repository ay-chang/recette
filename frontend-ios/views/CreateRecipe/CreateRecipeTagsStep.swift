import SwiftUI

struct CreateRecipeTagsStep: View {
    @ObservedObject var recipe: CreateRecipeModel
    var onBack: () -> Void
    var onFinish: () -> Void
    var onCancel: () -> Void
    
    @State private var prepTime: String = ""
    @State private var showAddTag: Bool = false
    


    var body: some View {
        // Header
        ZStack {
            Text("Tags & Other options")
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
        Text("Keep your recipe organized with tags and give it more options.")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
        
        VStack(alignment: .leading, spacing: 8) {

            // ADD FEATURES HERE
            
            // Difficulty
            VStack(alignment: .leading) {
                Text("Select difficulty")
                    .font(.headline)
                
                HStack(spacing: 16) {
                    ForEach(["Easy", "Medium", "Hard"], id: \.self) { level in
                        Button(action: {
                            recipe.difficulty = level
                        }) {
                            Text(level)
                                .foregroundColor(recipe.difficulty == level ? .white : .black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(recipe.difficulty == level ? Color.black : Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                        }
                    }
                }
            }
            
            // Serving Size
            VStack(alignment: .leading) {
                Text("Serving size")
                    .font(.headline)

                Stepper(value: $recipe.servingSize, in: 1...20, step: 1) {
                    Text("\(recipe.servingSize) \(recipe.servingSize == 1 ? "serving" : "servings")")
                }
            }

            // Cook Time
            VStack(alignment: .leading) {
                Text("Cook time")
                    .font(.headline)

                HStack {
                    Picker("Hours", selection: Binding(
                        get: { recipe.cookTimeInMinutes / 60 },
                        set: { recipe.cookTimeInMinutes = $0 * 60 + (recipe.cookTimeInMinutes % 60) }
                    )) {
                        ForEach(0..<13) { hour in
                            Text("\(hour) hr").tag(hour)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 100)

                    Picker("Minutes", selection: Binding(
                        get: { recipe.cookTimeInMinutes % 60 },
                        set: { recipe.cookTimeInMinutes = (recipe.cookTimeInMinutes / 60) * 60 + $0 }
                    )) {
                        ForEach(Array(stride(from: 0, through: 55, by: 5)), id: \.self) { min in
                            Text("\(min) min").tag(min)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 100)
                }
            }

            
            
            
            /** Tags */
            VStack(alignment: .leading, spacing: 12) {
                Text("Organize your recipe with tags")
                    .font(.headline)
                
                TagContainerView(
                    selectedTags: $recipe.selectedTags,
                    availableTags: $recipe.availableTags,
                    addTagAction: {
                        showAddTag = true
                    }
                )

            }
            
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
        .fullScreenCover(isPresented: $showAddTag) {
            AddTagView(recipe: recipe, showAddTag: $showAddTag)
        }
    }

}

