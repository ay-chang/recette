//
//  AddStepView.swift
//  frontend-ios
//
//  Created by Allen Chang on 4/24/25.
//

import SwiftUI

struct AddStepView: View {
    @ObservedObject var recipe: CreateRecipeModel
    @Binding var showAddStep: Bool
    @State private var newStepText: String = ""
    
    var body: some View {
        // Header with cancel and save button
        ZStack {
            Text("Add a step")
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Button("Cancel") {
                    showAddStep = false
                }
                .foregroundColor(.black)
                .fontWeight(.light)

                Spacer()

                Button("Save") {
                    if !newStepText.trimmingCharacters(in: .whitespaces).isEmpty {
                        recipe.steps.append(newStepText)
                        showAddStep = false
                    }
                }
                .foregroundColor(.black)
                .fontWeight(.light)
            }
        }
        .padding()
        

        
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Now, let’s add a step to your recipe")
                    .font(.title2)
                    .fontWeight(.medium)// Options: .ultraLight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black
                
                Text("Try to keep each step easy to follow — one action at a time works great!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fontWeight(.regular)
                    .padding(.bottom, 8)
            }
            
            // Add Step Section
            VStack(alignment: .leading, spacing: 12) {
                TextEditor(text: Binding(
                    get: { String(newStepText.prefix(250)) },
                    set: { newValue in
                        newStepText = String(newValue.prefix(250))
                    }
                ))
                .frame(height: 200)
                .padding(8)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )

                /** Character count */
                HStack {
                    Spacer()
                    Text("\(newStepText.count) / 250")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding()
        
    }
}

