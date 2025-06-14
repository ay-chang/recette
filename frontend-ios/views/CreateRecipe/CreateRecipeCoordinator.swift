import SwiftUI

enum CreateRecipeStep {
    case details
    case ingredients
    case steps
    case tags
}

struct CreateRecipeCoordinator: View {
    @EnvironmentObject var session: UserSession
    @Environment(\.dismiss) var dismiss
    @StateObject var recipe = CreateRecipeModel()
    @State private var step: CreateRecipeStep = .details
    @State private var errorMessage: String? = nil
    @State private var showErrorAlert: Bool = false


    var body: some View {
        VStack {
            switch step {
            case .details:
                RecipeDetailsStep(recipe: recipe, onNext: { step = .ingredients }, onCancel: { dismiss() })
            case .ingredients:
                RecipeIngredientsStep(recipe: recipe, onNext: { step = .steps }, onBack: { step = .details }, onCancel: { dismiss() })
            case .steps:
                RecipeStepsStep(recipe: recipe, onNext: { step = .tags }, onBack: { step = .ingredients }, onCancel: { dismiss() })
            case .tags:
                RecipeTagsStep(
                    recipe: recipe,
                    onBack: { step = .steps },
                    onFinish: {
                        if let email = session.userEmail {
                            recipe.saveRecipe(email: email) { result in
                                switch result {
                                case .success:
                                    DispatchQueue.main.async {
                                        session.shouldRefreshRecipes = true
                                        dismiss()
                                    }
                                case .failure(let error):
                                    DispatchQueue.main.async {
                                        errorMessage = error.localizedDescription
                                        showErrorAlert = true
                                    }
                                }
                            }
                        }
                    },
                    onCancel: { dismiss() }
                )
            }
        }
        .alert("", isPresented: $showErrorAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(errorMessage ?? "Something went wrong.")
        })
        .transition(.slide)
    }
}
