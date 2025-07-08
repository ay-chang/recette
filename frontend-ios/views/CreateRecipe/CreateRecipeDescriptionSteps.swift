import SwiftUI

struct CreateRecipeDescriptionStep: View {
    @ObservedObject var recipe: CreateRecipeModel
    @State private var showDifficulty: Bool = false
    @State private var showServingSize = false
    @State private var showCookTime = false
    var onNext: () -> Void
    var onBack: () -> Void
    var onCancel: () -> Void
    
    @State private var prepTime: String = ""

    var body: some View {
        // Header
        ZStack {
            Text("Description & other options")
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
        Text("Give your recipe a description and set some optional other options")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
        
        VStack(alignment: .leading, spacing: 24) {
            
            /** Description */
            VStack(alignment: .leading, spacing: 8) {
                Text("Give your recipe a description")
                    .font(.headline)
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
            
            /** Other Option Selectors */
            VStack(alignment: .leading, spacing: 12) {
                Text("Set some other descriptors")
                    .font(.headline)
                
                /** Difficulty Selector*/
                Button(action: {
                    showDifficulty = true
                }) {
                    HStack (spacing: 2) {
                        Text("Difficulty: ")
                        Text("\(recipe.difficulty ?? "None")")
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
                    DifficultySelectorView(selectedDifficulty: $recipe.difficulty, showDifficulty: $showDifficulty)
                }

                /** Serving Size  Selector*/
                Button(action: {
                    showServingSize = true
                }) {
                    HStack (spacing: 2) {
                        Text("Serving Size: ")
                        Text("\(recipe.servingSize == 0 ? "None" : "\(recipe.servingSize)")")
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
                    ServingSizeSelectorView(servingSize: $recipe.servingSize, showSheet: $showServingSize)
                }

                
                /** Cook Time Selector*/
                Button(action: {
                    showCookTime = true
                }) {
                    HStack (spacing: 2) {
                        if recipe.cookTimeInMinutes == 0 {
                            HStack (spacing: 2) {
                                Text("Cook Time: ")
                                Text("None")
                                    .fontWeight(.medium)
                            }
                        } else {
                            let hours = recipe.cookTimeInMinutes / 60
                            let minutes = recipe.cookTimeInMinutes % 60
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
                    CookTimeSelectorView(cookTimeInMinutes: $recipe.cookTimeInMinutes, showSheet: $showCookTime)
                }
                
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

