import Foundation

struct RecipeListItems: Identifiable {
    let id: String
    var title: String
    var description: String
    var imageurl: String?
    var difficulty: String?
    var servingSize: Int?
    var cookTimeInMinutes: Int?
}

enum TimeOption: String, CaseIterable {
    case under15 = "15 mins or less"
    case under30 = "30 mins or less"
    case under60 = "1 hour or less"
    case under90 = "1 hour 30 minutes or less"
    case under120 = "2 hours or less"

    var minutesValue: Int {
        switch self {
        case .under15: return 15
        case .under30: return 30
        case .under60: return 60
        case .under90: return 90
        case .under120: return 120
        }
    }
}

import Foundation

@MainActor
final class RecipeListModel: ObservableObject {
    @Published var recipes: [RecipeListItems] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    func loadAllUserRecipes() {
        errorMessage = nil
        isLoading = true

        Task {
            do {
                print("RecipeListModel: Loading recipes from REST API...")
                let dtos = try await RecipeService.shared.getMine()
                print("RecipeListModel: Received \(dtos.count) recipes")
                self.recipes = dtos.map {
                    RecipeListItems(
                        id: $0.id,
                        title: $0.title,
                        description: $0.description,
                        imageurl: $0.imageurl,
                        difficulty: $0.difficulty,
                        servingSize: $0.servingSize,
                        cookTimeInMinutes: $0.cookTimeInMinutes
                    )
                }
                self.isLoading = false
            } catch {
                print("RecipeListModel ERROR: \(error)")
                self.errorMessage = error.localizedDescription
                self.recipes = []
                self.isLoading = false
            }
        }
    }

    func loadFilteredRecipes(filter: FilterRecipesModel) {
        errorMessage = nil
        isLoading = true

        Task {
            do {
                let dtos = try await RecipeService.shared.getMineFiltered(filter: filter)
                self.recipes = dtos.map {
                    RecipeListItems(
                        id: $0.id,
                        title: $0.title,
                        description: $0.description,
                        imageurl: $0.imageurl,
                        difficulty: $0.difficulty,
                        servingSize: $0.servingSize,
                        cookTimeInMinutes: $0.cookTimeInMinutes
                    )
                }
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.recipes = []
                self.isLoading = false
            }
        }
    }
}




