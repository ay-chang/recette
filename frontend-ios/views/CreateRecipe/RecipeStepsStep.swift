import SwiftUI

struct RecipeStepsStep: View {
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
        
        // Intro box
        Text("Let’s break it down. How would you describe the process of making this recipe step by step?")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
        
        // Step List
        VStack(alignment: .leading, spacing: 24) {
            HStack() {
                Text("Step List:")
                    .font(.headline)
                Spacer()
                Button(action: {
                    isEditing.toggle()
                    if !isEditing {
                        editingIndex = nil
                    }
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(isEditing ? (Color(hex: "#e9c46a")): .gray)
                }
                
            }
            
            List {
                if !recipe.steps.isEmpty {
                    ForEach(recipe.steps.indices, id: \.self) { index in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .font(.callout)
                                .foregroundColor(.gray)

                            if editingIndex == index {
                                TextField("Edit step", text: $recipe.steps[index], onCommit: {
                                    editingIndex = nil
                                    
                                })
                                .textFieldStyle(.roundedBorder)
                            } else {
                                Text(recipe.steps[index])
                                    .font(.callout)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .onTapGesture {
                                        if isEditing {
                                            editingIndex = index
                                        }
                                    }
                            }

                            Spacer()
                            
                            if isEditing && swipedIndex != index {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8)
                            }
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
                        .contentShape(Rectangle())
                        .swipeActions(edge: .trailing) {
                            if isEditing {
                                Button(role: .destructive) {
                                    recipe.steps.remove(at: index)
                                } label: {
                                    Label("", systemImage: "trash")
                                }
                            }
                        }
                        
                    }
                    .listRowInsets(EdgeInsets()) // removes default padding
                    .listRowSeparator(.hidden)   // hides separator lines
                    .background(Color.clear)     // removes background behind each row

                }

                    // Add Step Button (always shown)
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
        .fullScreenCover(isPresented: $showAddStep) {
            AddStepView(recipe: recipe, showAddStep: $showAddStep)
        }
    }
    
}

