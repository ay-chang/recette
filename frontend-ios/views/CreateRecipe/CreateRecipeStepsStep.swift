import SwiftUI

struct CreateRecipeStepsStep: View {
    @ObservedObject var recipe: CreateRecipeModel
    var onNext: () -> Void
    var onBack: () -> Void
    var onCancel: () -> Void

    @State private var showAddStep = false
    @State private var isEditing = false
    @State private var editingIndex: Int? = nil
    @State private var swipedIndex: Int? = nil
    

    var body: some View {
        // Header
        ZStack {
            Text("Steps")
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
        
        /** Intro box */
        Text("Let’s break it down. How would you describe the process of making this recipe step by step?")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
        
        /** Step List */
        VStack(alignment: .leading, spacing: 24) {
            /** Step list title and edit button */
            HStack() {
                Text("Step List:")
                    .font(.headline)
                Spacer()
                Button(action: {
                    isEditing.toggle()
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(isEditing ? (Color(hex: "#e9c46a")): .gray)
                }
                
            }
            
            /** Main steps content */
            CreateRecipeStepsContent(
                recipe: recipe,
                isEditing: $isEditing,
                showAddStep: $showAddStep
            )


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
        .fullScreenCover(isPresented: $showAddStep) {
            AddStepView(recipe: recipe, showAddStep: $showAddStep)
        }
    }
    
}

struct CreateRecipeStepsContent: View {
    @ObservedObject var recipe: CreateRecipeModel
    @Binding var isEditing: Bool
    @Binding var showAddStep: Bool
    
    private func stepBinding(_ index: Int) -> Binding<String> {
        Binding(
            get: { index < recipe.steps.count ? recipe.steps[index] : "" },
            set: { newValue in
                guard index < recipe.steps.count else { return }
                recipe.steps[index] = String(newValue.prefix(250))
            }
        )
    }

    var body: some View {
        List {
            if !recipe.steps.isEmpty {
                ForEach(recipe.steps.indices, id: \.self) { index in
                    HStack(alignment: .top) {
                        
                        /** Number or red minus */
                        if !isEditing {
                            Text("\(index + 1).")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else {
                            Button(action: {
                                recipe.steps.remove(at: index)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red.opacity(0.9))
                                    .font(.system(size: 15))
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }

                        /** Step content */
                        if isEditing {
                            TextEditor(text: stepBinding(index))
                                .font(.callout)
                                .padding(.vertical, -8)
                        } else {
                            Text(recipe.steps[index])
                                .font(.callout)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3)),
                        alignment: .bottom
                    )
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .background(Color.clear)
            }

            /** Add Step Button (always shown) */
            Button(action: {
                isEditing = false
                showAddStep = true
            }) {
                HStack {
                    Text("+ Add a step")
                        .font(.callout)
                        .foregroundColor(.black.opacity(0.5))
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, recipe.steps.isEmpty ? 20 : 0)
                .overlay(alignment: .top) {
                    if recipe.steps.isEmpty {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3))
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .background(Color.clear)
        }
        .listStyle(.plain)
        .keyboardToolbarWithDone()
    }
}
