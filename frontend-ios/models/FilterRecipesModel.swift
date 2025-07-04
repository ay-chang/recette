import Foundation

class FilterRecipesModel: ObservableObject {
    @Published var availableTags: [String] = []
    @Published var selectedTags: Set<String> = []
    @Published var selectedDifficulties: [String] = []
    @Published var maxCookTimeInMinutes: TimeOption? = nil
    
    
    
    
    
    func loadUserTags(email: String) {
        let getUserTagsQuery = RecetteSchema.GetUserTagsQuery(email: email)
        
        Network.shared.apollo.fetch(query: getUserTagsQuery) { result in
            switch result {
            case .success(let graphQLResult):
                if let tags = graphQLResult.data?.userTags {
                    DispatchQueue.main.async {
                        self.availableTags = tags.map { $0.name }
                    }
                }
            case .failure(let error):
                print("Failed to load tags: \(error)")
            }
        }
    }
}
