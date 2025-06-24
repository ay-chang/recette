import SwiftUI
import PhotosUI

struct RecipeDetailsNoImage: View {
    let recipe: RecipeDetails
    let selectedImage: (UIImage) -> Void
    let onClose: () -> Void
    let onEllipsisTap: () -> Void

    @State private var showWhiteTopBar = false
    @State private var photosPickerItem: PhotosPickerItem? = nil

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Add cover button
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
                                selectedImage(uiImage)  // delegate back to the coordinator
                            }
                            photosPickerItem = nil
                        }
                    }
                    .padding(.top, 125)
                    .padding(.bottom, -12)

                    RecipeDetailsContent(recipe: recipe)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
            }
            .coordinateSpace(name: "scroll")
            .scrollIndicators(.hidden)

            RecipeTopBar(
                showWhiteBar: true,
                onClose: onClose,
                onEllipsisTap: onEllipsisTap
            )
        }
        .ignoresSafeArea(edges: .top)
    }
}
