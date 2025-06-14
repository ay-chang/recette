import SwiftUI

struct RecipeDetailsContent: View {
    let recipe: RecetteSchema.GetRecipeByIDQuery.Data.RecipeById

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Recipe title
            Text(recipe.title)
                .font(.system(size: 28))
                .fontWeight(.medium)
            
            // Recipe description
            Text(recipe.description)
                .font(.system(size: 16))
                .fontWeight(.light)
            
            // List of tags
            RecipeTags(tags: recipe.tags)
                .padding(.top, -8)
            
            // List of Ingredients and Steps
            RecipeIngredients(ingredients: recipe.ingredients)
            RecipeSteps(steps: recipe.steps)
           
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.white))
        .padding(.bottom, 64)
    }
}
