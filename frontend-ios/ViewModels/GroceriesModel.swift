import Foundation

struct GroceryItem: Identifiable {
    let id: String
    let name: String
    let measurement: String
    let recipeId: String
    let recipeTitle: String
    var isChecked: Bool = false
}

class GroceriesModel: ObservableObject {
    @Published var items: [GroceryItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showOptions = false
    @Published var isEditing = false
    
    /**
      * This property returns the grocery items grouped by their associated recipe, preserving the original
      * order of the items array. Uses a set to track which recipes have already been seen to prevent
      * grouping the same recipe multiple times.
      */
    var groupedByRecipe: [(id: String, title: String, items: [GroceryItem])] {
        var seen = Set<String>()
        var orderedGroups: [(id: String, title: String, items: [GroceryItem])] = []
        for item in items {
            if seen.insert(item.recipeId).inserted {
                let groupItems = items.filter { $0.recipeId == item.recipeId }
                orderedGroups.append((id: item.recipeId, title: item.recipeTitle, items: groupItems))
            }
        }
        return orderedGroups
    }


    func loadGroceries(email: String) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let groceries = try await GroceryService.shared.getMyGroceries()
                DispatchQueue.main.async {
                    self.items = groceries.map { g in
                        GroceryItem(
                            id: g.id,
                            name: g.name,
                            measurement: g.measurement,
                            recipeId: g.recipeId ?? "(no-id)",
                            recipeTitle: g.recipeTitle,
                            isChecked: g.checked
                        )
                    }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.items = []
                    self.isLoading = false
                }
            }
        }
    }
    
    func addGroceries(_ ingredients: [Ingredient], recipeId: String, completion: @escaping (Bool) -> Void) {
        let groceryInputs = ingredients.map {
            GroceryInput(name: $0.name, measurement: $0.measurement)
        }

        Task {
            do {
                let groceries = try await GroceryService.shared.addGroceries(groceries: groceryInputs, recipeId: recipeId)
                print("Successfully added \(groceries.count) groceries")
                completion(true)
            } catch {
                print("Error adding groceries: \(error.localizedDescription)")
                completion(false)
            }
        }
    }


    
    func removeRecipeFromGroceries(recipeId: String) {
        Task {
            do {
                try await GroceryService.shared.removeRecipeFromGroceries(recipeId: recipeId)
                print("Successfully removed groceries for recipe \(recipeId)")
                DispatchQueue.main.async {
                    self.items.removeAll { $0.recipeId == recipeId }
                }
            } catch {
                print("Error removing groceries: \(error.localizedDescription)")
            }
        }
    }


    
    func toggleGroceryCheck(id: String, checked: Bool) {
        Task {
            do {
                let updated = try await GroceryService.shared.toggleGroceryCheck(id: id, checked: checked)
                print("Updated grocery \(updated.id) to checked: \(updated.checked)")
            } catch {
                print("Error toggling grocery check: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAllGroceries() {
        Task {
            do {
                try await GroceryService.shared.deleteAllGroceries()
                DispatchQueue.main.async {
                    self.items = []
                }
            } catch {
                print("Error deleting all groceries: \(error.localizedDescription)")
            }
        }
    }

    func hasRecipe(_ recipeId: String) -> Bool {
        let found = items.contains(where: { $0.recipeId == recipeId })
        return found
    }





}
