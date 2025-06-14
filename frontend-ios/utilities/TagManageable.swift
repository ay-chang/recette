import Foundation
import Combine

protocol TagManageable: ObservableObject {
    var selectedTags: Set<String> { get set }
    var availableTags: [String] { get set }
    func addTagToBackend(email: String, tagName: String)
}
