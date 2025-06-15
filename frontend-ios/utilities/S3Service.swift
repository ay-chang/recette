import UIKit

/* S3 Helper functions for manipulating data in our S3 bucket*/

enum S3Manager {
    
    /**
     * Uploads a JPEG image to the backend server using multipart/form-data. Returns
     * the public image URL as a string upon successful upload.
     */
    static func uploadImage(_ image: UIImage) async throws -> String {
        guard let url = URL(string: "\(Config.backendBaseURL)/api/upload") else {
            throw URLError(.badURL)
        }

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let filename = "\(UUID().uuidString).jpg"
        let fieldName = "file"

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("Upload response status: \(httpResponse.statusCode)")
            print("Response body: \(String(data: data, encoding: .utf8) ?? "N/A")")
        }

        guard let imageURL = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotParseResponse)
        }

        return imageURL
    }

    
    static func deleteImage(at imageURL: String) {
        guard let url = URL(string: "\(Config.backendBaseURL)/api/delete-image?url=\(imageURL)") else {
            print("Invalid delete URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        print("DELETING IMAGE WITH URL: \(imageURL)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to delete image: \(error.localizedDescription)")
            } else {
                print("Image deleted from S3")
            }
        }.resume()
    }
}
