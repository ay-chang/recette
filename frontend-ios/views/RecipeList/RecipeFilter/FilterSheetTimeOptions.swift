import SwiftUI

enum TimeOption: String, CaseIterable {
    case under30 = "Under 30 mins"
    case under1 = "Under 1 hour"
    case under2 = "Under 2 hours"
    case over2 = "2+ hours"
}

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

