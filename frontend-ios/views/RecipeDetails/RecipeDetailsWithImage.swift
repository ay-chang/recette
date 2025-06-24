import SwiftUI

/*
 * Note: if changing the frame size (size of the iamge) make sure to adjust
 * .offset(y: 85) in RecipeDetailsWithImage using these details:
 * showWhiteTopBar = value < 15 as well, adjust numbers accordingly, these work with
 * frame size of 485
 */

struct RecipeDetailsWithImage: View {
    let recipe: RecipeDetails
    let onClose: () -> Void
    let onEllipsisTap: () -> Void

    @State private var showWhiteTopBar = false

    var body: some View {

        ZStack(alignment: .topLeading) {
            // Image Header
            RecipeImage(imageUrlString: recipe.imageurl, frameHeight: 485, frameWidth: UIScreen.main.bounds.width)
            
            ScrollView {
                RecipeScrollSentinel { value in
                    withAnimation {
                        showWhiteTopBar = value < 15
                    }
                }
                
                // Main recipe content
                VStack(alignment: .leading, spacing: 24) {
                    RecipeDetailsContent(recipe: recipe)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
                .offset(y: 85)
            
            }
            .coordinateSpace(name: "scroll")
            .scrollIndicators(.hidden)
            
            RecipeTopBar(
                showWhiteBar: showWhiteTopBar,
                onClose: onClose,
                onEllipsisTap: onEllipsisTap
            )
            
        }
        .ignoresSafeArea(edges: .top)
    }
    
}
