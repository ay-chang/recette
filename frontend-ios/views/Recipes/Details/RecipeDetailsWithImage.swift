import SwiftUI

/*
 * Note: if changing the frame size (size of the image) make sure to adjust
 * .offset(y: 85) in RecipeDetailsWithImage using these details:
 * showWhiteTopBar = value < 15 as well, adjust numbers accordingly, these work with
 * frame size of 485. For adjusting the offset, add 100 for every 100 added to
 * frameHeight. For vlaue if you add, we subtract.
 */

struct RecipeDetailsWithImage: View {
    let recipe: RecipeDetails
    let onClose: () -> Void
    let onEllipsisTap: () -> Void

    @State private var showWhiteTopBar = false

    var body: some View {

        ZStack(alignment: .topLeading) {
            // Image Header
            if let imageurl = recipe.imageurl, !imageurl.isEmpty {
                RecipeImage(imageUrlString: imageurl, frameHeight: 550, frameWidth: UIScreen.main.bounds.width)
            } else {
                Image("pasta-placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 550)
                    .frame(width: UIScreen.main.bounds.width)
                    .clipped()
            }
            
            ScrollView {
                RecipeScrollSentinel { value in
                    withAnimation {
                        showWhiteTopBar = value < -45
                    }
                }
                
                // Main recipe content
                VStack(alignment: .leading, spacing: 24) {
                    RecipeDetailsContent(recipe: recipe)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
                .offset(y: 150)
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
