import SwiftUI

struct ProfileFeedbackView: View {
    @EnvironmentObject var session: UserSession
    @Environment(\.dismiss) var dismiss
    @State private var feedbackText = ""
    @State private var submitted: Bool = false
    
    
    var body: some View {
      
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        
        .padding()
        
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Give us your feedback, we read everything")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Let us know if there are any new features you’d like to see, bugs you’ve noticed, or improvements that could make the app even better!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fontWeight(.regular)
                    .padding(.bottom, 8)
            }
            
            
            VStack(alignment: .leading, spacing: 12) {
                TextEditor(text: Binding(
                    get: { String(feedbackText.prefix(250)) },
                    set: { newValue in
                        feedbackText = String(newValue.prefix(250))
                    }
                ))
                .frame(height: 200)
                .padding(8)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )

                /** Character count */
                CharacterCountView(currentCount: feedbackText.count, maxCount: 250)
            }
            
            Spacer()
            
            if !submitted {
                Button(action: {
                    sendFeedback(message: feedbackText)
                    feedbackText = ""
                    submitted = true
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else {
                Text("Submitted!")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

func sendFeedback(message: String) {
    guard let url = URL(string: "\(Config.backendBaseURL)/api/feedback") else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    // Add jwt token
    if let token = AuthManager.shared.jwtToken {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    } else {
        print("Missing JWT token")
        return
    }

    let bodyString = "message=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
    request.httpBody = bodyString.data(using: .utf8)

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let http = response as? HTTPURLResponse {
            if let data = data { print("Body:", String(data: data, encoding: .utf8) ?? "") }
        }
        if let error = error { print("Error:", error) }
    }.resume()
}


