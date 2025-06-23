import SwiftUI

struct EditRecipeOthers: View {
    @Binding var difficulty: String?
    @Binding var servingSize: Int
    @Binding var cookTimeInMinutes: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            /** Difficulty */
            DifficultySelector(selectedDifficulty: $difficulty)

            /** Serving Size */
            servingSizeSelector(servingSize: $servingSize)

            /** Cook Time */
            cookTimeSelector(cookTimeInMinutes: $cookTimeInMinutes)
        }
    }
}
