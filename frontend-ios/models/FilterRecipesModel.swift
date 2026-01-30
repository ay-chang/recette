import Foundation

class FilterRecipesModel: ObservableObject {
    @Published var availableTags: [String] = []
    @Published var selectedTags: Set<String> = []
    @Published var selectedDifficulties: [String] = []
    @Published var maxCookTimeInMinutes: TimeOption? = nil
    
    @MainActor
    func applyFilter(recipeListModel: RecipeListModel, onComplete: @escaping () -> Void) {
        recipeListModel.loadFilteredRecipes(filter: self)
        onComplete()
    }

    func clearFilters() {
        selectedTags = []
        selectedDifficulties = []
        maxCookTimeInMinutes = nil
    }
}

extension FilterRecipesModel {
    var isFilterActive: Bool {
        return !selectedTags.isEmpty ||
               !selectedDifficulties.isEmpty ||
               maxCookTimeInMinutes != nil
    }
}
