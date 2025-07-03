import SwiftUI

struct FilterSheetView: View {
    @ObservedObject var filterRecipesModel = FilterRecipesModel()
    @EnvironmentObject var session: UserSession
    
    @State private var medium = false
    @State private var hard = false
    
    @State private var under30 = false
    @State private var under1 = false
    @State private var under2 = false
    @State private var over2 = false
    
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(.gray.opacity(0.8))
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Tags title
                    Text("Tags")
                        .font(.title3)
                        .bold()
                        .padding(.vertical, 8)
                    Divider()
                    
                    TagContainerView(
                        selectedTags: $filterRecipesModel.selectedTags,
                        availableTags: $filterRecipesModel.availableTags,
                        showsAddTagButton: false
                    )
                    .padding(.vertical, 16)

                    
                    // Difficulty title
                    Text("Difficulty")
                        .font(.title3)
                        .bold()
                        .padding(.vertical, 8)
                    Divider()
                    
                    /** Difficulty items */
                    filterRow(label: "Easy", isChecked: Binding(
                        get: { filterRecipesModel.selectedDifficulties.contains("Easy") },
                        set: { newValue in
                            if newValue {
                                filterRecipesModel.selectedDifficulties.append("Easy")
                            } else {
                                filterRecipesModel.selectedDifficulties.removeAll { $0 == "Easy" }
                            }
                        }
                    ))

                    filterRow(label: "Medium", isChecked: Binding(
                        get: { filterRecipesModel.selectedDifficulties.contains("Medium") },
                        set: { newValue in
                            if newValue {
                                filterRecipesModel.selectedDifficulties.append("Medium")
                            } else {
                                filterRecipesModel.selectedDifficulties.removeAll { $0 == "Medium" }
                            }
                        }
                    ))
                    
                    filterRow(label: "Hard", isChecked: Binding(
                        get: { filterRecipesModel.selectedDifficulties.contains("Hard") },
                        set: { newValue in
                            if newValue {
                                filterRecipesModel.selectedDifficulties.append("Hard")
                            } else {
                                filterRecipesModel.selectedDifficulties.removeAll { $0 == "Hard" }
                            }
                        }
                    ))
                    
                    // Time title
                    Text("Time")
                        .font(.title3)
                        .bold()
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                    Divider()
                    
                    // Time items
                    filterRow(label: "Under 30 mins", isChecked: $under30)
                    filterRow(label: "Under 1 hour", isChecked: $under1)
                    filterRow(label: "Under 2 hours", isChecked: $under2)
                    filterRow(label: "2+ hours", isChecked: $over2)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            

            
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            if let email = session.userEmail {
                filterRecipesModel.loadUserTags(email: email)
            }
        }
    }

    
    private func filterRow(label: String, isChecked: Binding<Bool>) -> some View {
        HStack {
            Button(action: {
                isChecked.wrappedValue.toggle()
            }) {
                HStack {
                    Image(systemName: isChecked.wrappedValue ? "checkmark.square.fill" : "square")
                        .foregroundColor(isChecked.wrappedValue ? Color(hex: "#e9c46a") : .black)
                    Text(label)
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
        }
        .padding(.vertical, 12)
    }
    
}
