import SwiftUI

struct FilterSheetDifficulties: View {
    @ObservedObject var filterRecipesModel: FilterRecipesModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            /** Title */
            Text("Difficulty")
                .font(.title3)
                .bold()
                .padding(.vertical, 8)
            Divider()
            
            FilterRow(label: "Easy", isChecked: Binding(
                get: { filterRecipesModel.selectedDifficulties.contains("Easy") },
                set: { newValue in
                    if newValue {
                        filterRecipesModel.selectedDifficulties.append("Easy")
                    } else {
                        filterRecipesModel.selectedDifficulties.removeAll { $0 == "Easy" }
                    }
                }
            ))
            
            FilterRow(label: "Medium", isChecked: Binding(
                get: { filterRecipesModel.selectedDifficulties.contains("Medium") },
                set: { newValue in
                    if newValue {
                        filterRecipesModel.selectedDifficulties.append("Medium")
                    } else {
                        filterRecipesModel.selectedDifficulties.removeAll { $0 == "Medium" }
                    }
                }
            ))
            
            FilterRow(label: "Hard", isChecked: Binding(
                get: { filterRecipesModel.selectedDifficulties.contains("Hard") },
                set: { newValue in
                    if newValue {
                        filterRecipesModel.selectedDifficulties.append("Hard")
                    } else {
                        filterRecipesModel.selectedDifficulties.removeAll { $0 == "Hard" }
                    }
                }
            ))
        }
    }
    
}
