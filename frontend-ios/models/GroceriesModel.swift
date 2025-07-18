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
    
    /**
      * This property returns the grocery items grouped by their associated recipe, preserving the original
      * order of the items array. Uses a set to track which recipes have already been seen to prevent
      * grouping the same recipe multiple times.
      */
    var groupedByRecipe: [(id: String, title: String, items: [GroceryItem])] {
        var seen = Set<String>()
        var orderedGroups: [(id: String, title: String, items: [GroceryItem])] = []
        
        for item in items {
            if seen.contains(item.recipeId) { continue }
            seen.insert(item.recipeId)
            
            let groupItems = items.filter { $0.recipeId == item.recipeId }
            orderedGroups.append((id: item.recipeId, title: item.recipeTitle, items: groupItems))
        }
        
        return orderedGroups
    }


    func loadGroceries(email: String) {
        let query = RecetteSchema.GetUserGroceriesQuery(email: email)
        
        Network.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                if let groceries = graphQLResult.data?.getUserGroceries {
                    
                    let mappedItems: [GroceryItem] = groceries.map { grocery in
                        let id = grocery.id
                        let name = grocery.name
                        let measurement = grocery.measurement
                        let recipeId = grocery.recipe?.id ?? "(no-id)"
                        let recipeTitle = grocery.recipe?.title ?? "(No Recipe)"
                        let isChecked = grocery.checked
                        
                        return GroceryItem(
                            id: id,
                            name: name,
                            measurement: measurement,
                            recipeId: recipeId,
                            recipeTitle: recipeTitle,
                            isChecked: isChecked
                        )
                    }
                    
                    DispatchQueue.main.async {
                        self?.items = mappedItems
                    }
                } else if let errors = graphQLResult.errors {
                    print("GraphQL errors: \(errors.map { $0.message })")
                } else {
                    print("Unexpected: No groceries and no errors.")
                }
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
            }
        }
    }
    
    func addGroceries(_ ingredients: [Ingredient], recipeId: String, completion: @escaping (Bool) -> Void) {
        let groceryInputs = ingredients.map {
            RecetteSchema.GroceryInput(name: $0.name, measurement: $0.measurement)
        }

        let mutation = RecetteSchema.AddGroceriesMutation(
            groceries: groceryInputs,
            recipeId: recipeId
        )

        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let groceries = graphQLResult.data?.addGroceries {
                    print("Successfully added \(groceries.count) groceries")
                    completion(true)
                } else if let errors = graphQLResult.errors {
                    print("GraphQL errors: \(errors.map { $0.message })")
                    completion(false)
                }
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }


    
    func removeRecipeFromGroceries(recipeId: String) {
        let mutation = RecetteSchema.RemoveRecipeFromGroceriesMutation(recipeId: recipeId)
        
        Network.shared.apollo.perform(mutation: mutation) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                if let success = graphQLResult.data?.removeRecipeFromGroceries, success {
                    print("Successfully removed groceries for recipe \(recipeId)")
                    DispatchQueue.main.async {
                        self?.items.removeAll { $0.recipeId == recipeId }
                    }
                } else if let errors = graphQLResult.errors {
                    print("GraphQL errors: \(errors.map { $0.message })")
                } else {
                    print("Unexpected: No success flag and no errors.")
                }
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
            }
        }
    }


    
    func toggleGroceryCheck(id: String, checked: Bool) {
        let mutation = RecetteSchema.ToggleGroceryCheckMutation(id: id, checked: checked)
        
        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let updated = graphQLResult.data?.toggleGroceryCheck {
                    print("Updated grocery \(updated.id) to checked: \(updated.checked)")
                } else if let errors = graphQLResult.errors {
                    print("GraphQL errors: \(errors.map { $0.message })")
                }
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
            }
        }
    }
    
    func hasRecipe(_ recipeId: String) -> Bool {
        let found = items.contains(where: { $0.recipeId == recipeId })
        return found
    }





}
