import SwiftUI

struct ProfileFeedbackView: View {
    @EnvironmentObject var session: UserSession
    @Environment(\.dismiss) var dismiss
    @State private var feedbackText = ""
    @State private var showSubmittedSheet = false
    
    
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
            
            Button(action: {
                sendFeedback(message: feedbackText)
                showSubmittedSheet = true
                feedbackText = ""
            }) {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#e9c46a"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .sheet(isPresented: $showSubmittedSheet) {
            SubmittedSheet()
                .presentationDragIndicator(.hidden)
        }
        .padding()
    }
}

struct SubmittedSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Capsule()
            .frame(width: 40, height: 6)
            .foregroundColor(.gray.opacity(0.8))
            .padding(.top, 10)
            .padding(.bottom, 10)
        
        Spacer()

        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color(hex: "#e9c46a"), lineWidth: 3)
                    .frame(width: 72, height: 72)
                Image(systemName: "checkmark")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(hex: "#e9c46a"))
            }
            .padding(.top, 12)

            Text("Thanks for sharing!")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Hearing from you helps us create the best experience in Recette.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)

        Spacer()
        
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


