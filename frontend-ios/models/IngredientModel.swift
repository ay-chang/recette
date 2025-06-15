import Foundation

struct Ingredient: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var measurement: String
}
