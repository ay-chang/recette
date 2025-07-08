import SwiftUI

struct EditRecipeOthers: View {
    @Binding var difficulty: String?
    @Binding var servingSize: Int
    @Binding var cookTimeInMinutes: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            /** Difficulty */
//            DifficultySelectorView(selectedDifficulty: $difficulty)

            /** Serving Size */
//            ServingSizeSelectorView(servingSize: $servingSize)

            /** Cook Time */
//            CookTimeSelectorView(cookTimeInMinutes: $cookTimeInMinutes)
        }
    }
}
