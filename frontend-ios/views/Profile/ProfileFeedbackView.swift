import SwiftUI

struct ProfileFeedbackView: View {
    @EnvironmentObject var session: UserSession
    @Environment(\.dismiss) var dismiss
    @State private var feedbackText = ""
    
    
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
                Text("Give us your feedback")
                    .font(.title2)
                    .fontWeight(.medium)// Options: .ultraLight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black
                
                Text("We read every piece of feedback you send. Let us know if there are any new features you’d like to see, bugs you’ve noticed, or improvements that could make the app even better!")
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
            Button() {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }
}
