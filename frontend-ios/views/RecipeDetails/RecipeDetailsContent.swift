import SwiftUI

struct RecipeDetailsContent: View {
    let recipe: RecipeDetails

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            /** Recipe title */
            Text(recipe.title)
                .font(.system(size: 28))
                .fontWeight(.medium)
            
            /** Check if any of the properties even exist and then display others bar*/
            if recipe.difficulty != nil ||
               (recipe.cookTimeInMinutes ?? 0) > 0 ||
               (recipe.servingSize ?? 0) > 0 {
                OthersBarView(
                    difficulty: recipe.difficulty,
                    servingSize: recipe.servingSize,
                    cookTimeInMinutes: recipe.cookTimeInMinutes,
                    iconSize: 22,
                    fontSize: 14
                )
            }

            /** Recipe description */
            Text(recipe.description)
                .font(.system(size: 16))
                .fontWeight(.light)
            
            /** List of tags */
            RecipeTags(tags: recipe.tags)
    
            /** List of Ingredients and Steps */
            RecipeIngredients(ingredients: recipe.ingredients, recipeId: recipe.id)
            RecipeSteps(steps: recipe.steps)
           
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 64)
    }
}
