import SwiftUI
import PhotosUI

struct RecipeDetailsNoImage: View {
    let recipe: RecetteSchema.GetRecipeByIDQuery.Data.RecipeById
    @ObservedObject var model: RecipeDetailsModel // Injected externally
    let onClose: () -> Void
    let onEllipsisTap: () -> Void

    @State private var showWhiteTopBar = false
    @State private var photosPickerItem: PhotosPickerItem? = nil
    @EnvironmentObject var session: UserSession


    var body: some View {

        ZStack(alignment: .topLeading) {
            ScrollView {
                // Main recipe content
                VStack(alignment: .leading, spacing: 24) {
                    
                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        HStack {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                            Text("Add cover")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                    }
                    .onChange(of: photosPickerItem) { _, _ in
                        Task {
                            if let item = photosPickerItem,
                               let data = try? await item.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {

                                model.selectedImage = uiImage

                                if let email = session.userEmail {
                                    model.updateRecipeImage(image: uiImage, email: email) { success in
                                        if success {
                                            model.loadRecipe()
                                        } else {
                                            print("Failed to update image.")
                                        }
                                    }
                                }
                            }
                            photosPickerItem = nil
                        }
                    }
                    .padding(.top, 125)
                    .padding(.bottom, -12)
       
                    // Main Recipe Details
                    RecipeDetailsContent(recipe: recipe)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
            
            }
            .coordinateSpace(name: "scroll")
            
            RecipeTopBar(
                showWhiteBar: true,
                onClose: onClose,
                onEllipsisTap: onEllipsisTap
            )
            
        }
        .ignoresSafeArea(edges: .top)

            
        
        
    }
}
