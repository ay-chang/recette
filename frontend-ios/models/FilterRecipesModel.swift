import Foundation

class FilterRecipesModel: ObservableObject {
    @Published var availableTags: [String] = []
    @Published var selectedTags: Set<String> = []
    @Published var selectedDifficulties: [String] = []
    @Published var maxCookTimeInMinutes: TimeOption? = nil
    
    func applyFilter(email: String, recipeListModel: RecipeListModel, onComplete: @escaping () -> Void) {
        recipeListModel.loadFilteredRecipes(email: email, filter: self)
        onComplete()
    }
    
    func clearFilters() {
        selectedTags = []
        selectedDifficulties = []
        maxCookTimeInMinutes = nil
    }
}

/** Variable that tells us if any filter option is selected */
extension FilterRecipesModel {
    var isFilterActive: Bool {
        return !selectedTags.isEmpty ||
               !selectedDifficulties.isEmpty ||
               maxCookTimeInMinutes != nil
    }
}



