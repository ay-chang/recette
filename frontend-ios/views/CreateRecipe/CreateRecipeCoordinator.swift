import SwiftUI

enum CreateRecipeStep {
    case details
    case ingredients
    case steps
    case tags
    case others
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
                CreateRecipeDetailsStep(recipe: recipe, onNext: { step = .ingredients }, onCancel: { dismiss() })
            case .ingredients:
                CreateRecipeIngredientsStep(recipe: recipe, onNext: { step = .steps }, onBack: { step = .details }, onCancel: { dismiss() })
            case .steps:
                CreateRecipeStepsStep(recipe: recipe, onNext: { step = .tags }, onBack: { step = .ingredients }, onCancel: { dismiss() })
            case .tags:
                CreateRecipeTagsStep(recipe: recipe, onNext: { step = .others}, onBack: {step = .steps}, onCancel: { dismiss() })
            case .others:
                CreateRecipeOthersStep(
                    recipe: recipe,
                    onBack: { step = .tags },
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
        .onAppear {
            print("Loading user tags...")
            if let email = session.userEmail {
                session.loadUserTags(email: email)
            }
        }
        .onChange(of: session.shouldRefreshTags) {
            if session.shouldRefreshTags {
                if let email = session.userEmail {
                    session.loadUserTags(email: email)
                }
                session.shouldRefreshTags = false
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
