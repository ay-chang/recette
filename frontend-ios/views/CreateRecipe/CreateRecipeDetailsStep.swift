import SwiftUI
import PhotosUI

struct CreateRecipeDetailsStep: View {
    @ObservedObject var recipe: CreateRecipeModel
    var onNext: () -> Void
    var onCancel: () -> Void

    @State private var photosPickerItem: PhotosPickerItem?

    var body: some View {
        // Header Bar "X" and Create Recipe
        ZStack {
            Text("Create Recipe")
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
        .padding()
        // Intro box (full width)
        Text("We’re excited to see your recipe! Let’s start with the basics…")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))

        /** Title, image picker, and nav buttons */
        VStack(spacing: 24) {
            // Recipe Title Section with Character Limit
            VStack(alignment: .leading, spacing: 8) {
                Text("Name your recipe")
                    .font(.headline)

                TextField("Enter title", text: Binding(
                    get: { recipe.title },
                    set: { newValue in
                        recipe.title = String(newValue.prefix(55))
                    }
                ))
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )

                HStack{
                    Spacer()
                    Text("\(recipe.title.count) / 55")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
 
            }
            

            // Image Upload Section (same as before)
            VStack (alignment: .leading, spacing: 8) {
                Text("Add a recipe photo")
                    .font(.headline)
                
                PhotosPicker(selection: $photosPickerItem, matching: .not(.videos)) {
                    ZStack {
                        if let image = recipe.selectedImage {
                            GeometryReader { geometry in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: 360)
                                    .clipped()
                                    .cornerRadius(12)
                            }
                            .frame(height: 360)
                        } else {
                            VStack(spacing: 8) {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.system(size: 28))
                                    .foregroundColor(.gray)
                                Text("Upload a final photo of your dish")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, minHeight: 360)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                    .foregroundColor(.gray.opacity(0.5))
                            )
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .frame(height: 360)
                }
                .onChange(of: photosPickerItem) { _, _ in
                    Task {
                        if let item = photosPickerItem,
                           let data = try? await item.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            recipe.selectedImage = uiImage
                        }
                        photosPickerItem = nil
                    }
                }
            }
            

            Spacer()

            Button(action: onNext) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#e9c46a"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

