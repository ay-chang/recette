import SwiftUI
import PhotosUI

struct EditRecipeDetailsImage: View {
    @Binding var selectedImage: UIImage?
    let imageUrlString: String?
    
    @State private var photoItem: PhotosPickerItem?
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Image (from S3 or selectedImage)
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 425)
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .clipped()
            } else {
                RecipeImage(imageUrlString: imageUrlString, frameHeight: 425, frameWidth: UIScreen.main.bounds.width)
            }
            
            // Overlay "Edit Cover" button
            PhotosPicker(selection: $photoItem, matching: .images, photoLibrary: .shared()) {
                HStack {
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                    Text("Edit Cover")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.6))
                .cornerRadius(8)
                .padding()
            }
        }
        .onChange(of: photoItem) {
            Task {
                if let data = try? await photoItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
        }
    }
}

