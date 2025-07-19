import SwiftUI
import PhotosUI

struct CreateRecipeDetailsStep: View {
    @ObservedObject var recipe: CreateRecipeModel

    var onNext: () -> Void
    var onCancel: () -> Void

    @State private var photosPickerItem: PhotosPickerItem?

    var body: some View {
        /** Header Bar "X" and Create Recipe */
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
        
        /** Intro box (full width) */
        Text("We’re excited to see your recipe! Let’s start with the basics…")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
        
        /** Title, image picker, and nav buttons */
        ScrollView { // Scroll view is temp fix for ipad UI
            VStack(spacing: 24) {
                /** Recipe Title Section with Character Limit */
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
                    .keyboardToolbarWithDone()
                    
                    HStack{
                        Spacer()
                        Text("\(recipe.title.count) / 55")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
                    
                }
                
                /** Image Upload Section (same as before) */
                VStack (alignment: .leading, spacing: 8) {
                    Text("Add a recipe photo")
                        .font(.headline)
                    
                    PhotosPicker(selection: $photosPickerItem, matching: .not(.videos)) {
                        ZStack {
                            if let image = recipe.selectedImage {
                                GeometryReader { geometry in
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width, height: 380)
                                        .clipped()
                                        .cornerRadius(12)
                                }
                                .frame(height: 380)
                            } else {
                                VStack(spacing: 8) {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.system(size: 28))
                                        .foregroundColor(.gray)
                                    Text("Upload a final photo of your dish (optional)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, minHeight: 380)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                        .foregroundColor(.gray.opacity(0.5))
                                )
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        .frame(height: 380)
                    }
                    .onChange(of: photosPickerItem) { _, _ in
                        Task {
                            if let item = photosPickerItem {
                                do {
                                    if let data = try await item.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        let fixedImage = uiImage.fixOrientation()
                                        recipe.selectedImage = fixedImage
                                        print("Valid image")
                                    } else {
                                        print("Invalid image or could not decode")
                                    }
                                } catch {
                                    print("Error loading image: \(error)")
                                }
                            }
                            photosPickerItem = nil
                        }
                    }
                }
                

            }
            .padding()
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
        .padding()
                
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? self
    }
}


