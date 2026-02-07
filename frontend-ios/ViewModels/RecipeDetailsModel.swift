import SwiftUI

struct RecipeDetails: Identifiable, Equatable {
    let id: String
    var title: String
    var description: String
    var imageurl: String?
    var ingredients: [Ingredient]
    var steps: [String]
    var tags: [String]
    var difficulty: String?
    var cookTimeInMinutes: Int?
    var servingSize: Int?
    var isPublic: Bool
}

@MainActor
class RecipeDetailsModel: ObservableObject {
    @Published var recipe: RecipeDetails?
    @Published var selectedImage: UIImage?

    let recipeId: String
    init(recipeId: String) {
        self.recipeId = recipeId
    }

    
    func loadRecipe() {
        Task {
            do {
                let dto = try await RecipeService.shared.getById(recipeId)

                self.recipe = RecipeDetails(
                    id: dto.id,
                    title: dto.title,
                    description: dto.description,
                    imageurl: dto.imageurl,
                    ingredients: (dto.ingredients ?? []).map { Ingredient(name: $0.name, measurement: $0.measurement) },
                    steps: dto.steps ?? [],
                    tags: dto.tags ?? [],
                    difficulty: dto.difficulty,
                    cookTimeInMinutes: dto.cookTimeInMinutes,
                    servingSize: dto.servingSize,
                    isPublic: dto.isPublic ?? false
                )
            } catch {
                print("Failed to load recipe: \(error)")
            }
        }
    }

    func deleteRecipe(completion: @escaping (Bool) -> Void) {
        if let imageurl = recipe?.imageurl {
            S3Manager.deleteImage(at: imageurl)
        }

        Task {
            do {
                print("RecipeDetailsModel: Deleting recipe via REST API...")
                try await RecipeService.shared.delete(id: recipeId)
                print("RecipeDetailsModel: Recipe deleted successfully")
                await MainActor.run {
                    completion(true)
                }
            } catch {
                print("RecipeDetailsModel ERROR: \(error)")
                await MainActor.run {
                    completion(false)
                }
            }
        }
    }

    func toggleVisibility(_ isPublic: Bool) {
        Task {
            do {
                _ = try await RecipeService.shared.toggleVisibility(id: recipeId, isPublic: isPublic)
                self.recipe?.isPublic = isPublic
            } catch {
                print("RecipeDetailsModel ERROR toggling visibility: \(error)")
            }
        }
    }

    func updateRecipeImage(image: UIImage, email: String, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                let imageurl = try await S3Manager.uploadImage(image)
                print("RecipeDetailsModel: Updating recipe image via REST API...")
                _ = try await RecipeService.shared.updateImage(id: recipeId, imageUrl: imageurl)
                print("RecipeDetailsModel: Recipe image updated successfully")
                await MainActor.run {
                    self.loadRecipe()
                    completion(true)
                }
            } catch {
                print("RecipeDetailsModel ERROR: \(error)")
                await MainActor.run {
                    completion(false)
                }
            }
        }
    }
}

struct SelectedRecipe: Identifiable {
    let id: String
}
