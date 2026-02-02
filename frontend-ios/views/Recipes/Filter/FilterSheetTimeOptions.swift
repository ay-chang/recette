import SwiftUI

struct FilterSheetTimeOptions: View {
    @ObservedObject var filterRecipesModel: FilterRecipesModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 12) {
            /** Title */
            Text("Time")
                .font(.title3)
                .bold()
            Divider()
            
            ForEach(TimeOption.allCases, id: \.self) { option in
                FilterRow(
                    label: option.rawValue,
                    isChecked: Binding(
                        get: { filterRecipesModel.maxCookTimeInMinutes == option },
                        set: { newValue in
                            filterRecipesModel.maxCookTimeInMinutes = newValue ? option : nil
                        }
                    )
                )
            }
        }
    }
}

