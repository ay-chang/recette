import SwiftUI

struct EditRecipeDetailsSteps: View {
    @Binding var steps: [String]
    @Binding var editingStepIndex: Int?
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            /** Header */
            HStack {
                Text("Steps")
                    .font(.headline)
                Spacer()
            }
                
            /** List of steps */
            VStack (alignment: .leading) {
                ForEach(steps.indices, id: \.self) { index in
                    let step = $steps[index]
                    
                    HStack ( alignment: .center, spacing: 12) {
                        Button(action: {
                            steps.remove(at: index)
                            if editingStepIndex == index {
                                editingStepIndex = nil
                            } else if let current = editingStepIndex, current > index {
                                editingStepIndex = current - 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red.opacity(0.9))
                                .font(.system(size: 16))
                        }

                        
                        HStack {
                            if editingStepIndex == index {
                                EditRecipeDetailsStepsContent(text: step)
                            } else {
                                Text(step.wrappedValue)
                                    .onTapGesture {
                                        editingStepIndex = index
                                    }
                            }
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3)),
                        alignment: .bottom
                    )
                    .contentShape(Rectangle())
                }
                
            }
            
            /** Add step button */
            Button(action: {
                steps.append("")
                editingStepIndex = steps.count - 1
            }) {
                HStack {
                    Text("+ Add a step")
                        .font(.callout)
                        .foregroundColor(.black.opacity(0.5))
                    Spacer()
                }
                .padding(.horizontal)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct EditRecipeDetailsStepsContent: View {
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextEditor(text: $text)
                .frame(height: 100)
                .padding(8)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .onChange(of: text) {
                    if text.count > 150 {
                        text = String(text.prefix(150))
                    }
                }

            CharacterCountView(currentCount: text.count, maxCount: 150)
        }
    }
}

