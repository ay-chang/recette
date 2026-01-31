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
                    iconSize: 20,
                    fontSize: 14,
                    itemSpacing: 8
                )
            }

            /** Recipe description */
            if !recipe.description.isEmpty {
                Text(recipe.description)
                    .font(.system(size: 16))
                    .fontWeight(.regular)
            }

            /** List of tags */
            RecipeTags(tags: recipe.tags)
                .padding(.bottom, 12)
    
            /** List of Ingredients */
            RecipeIngredients(ingredients: recipe.ingredients, recipeId: recipe.id)
                .padding(.bottom, 12)
            
            /** List of Steps */
            RecipeSteps(steps: recipe.steps)
                .padding(.bottom, 12)
           
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 64)
    }
}
