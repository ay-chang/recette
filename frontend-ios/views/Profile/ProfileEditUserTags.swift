import SwiftUI

struct ProfileEditUserTags: View {
    @EnvironmentObject var session: UserSession
    @State private var showAddTag = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        
        VStack (alignment: .leading, spacing: 12) {
            Text("Edit tags")
                .font(.title)
                .fontWeight(.semibold)
            
            TagContainerView(
                selectedTags: .constant([]),
                availableTags: $session.availableTags,
                addTagAction: {
                    showAddTag = true
                },
                showsAddTagButton: true,
                isInEditMode: true,
                deleteAction: { tag in
                    if let email = session.userEmail {
                        session.deleteTagFromUser(email: email, tagName: tag)
                    }
                }
            )
        }
        .padding(.horizontal)
        
        Spacer()
        
        .onAppear {
            if let email = session.userEmail {
                session.loadUserTags(email: email)
            }
        }
        .onChange(of: session.shouldRefreshTags) {
            if session.shouldRefreshTags, let email = session.userEmail {
                session.loadUserTags(email: email)
                session.shouldRefreshTags = false
            }
        }
        .fullScreenCover(isPresented: $showAddTag) {
            AddTagView(showAddTag: $showAddTag)
        }
    }
}
