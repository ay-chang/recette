import SwiftUI

struct ProfileEditUserTags: View {
    @EnvironmentObject var session: UserSession
    @State private var showAddTag = false
    
    var body: some View {
        VStack{
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(.gray).opacity(0.8)
                .padding(.top, 10)
                .padding(.bottom, 24)
            
            VStack (alignment: .leading, spacing: 12) {
                Text("Edit tags")
                    .font(.title2)
                    .fontWeight(.semibold)
                TagContainerView(
                    selectedTags: .constant([]),
                    availableTags: $session.availableTags,
                    addTagAction: {
                        showAddTag = true
                    },
                    showsAddTagButton: true,
                    isInEditMode: true
                )
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            if let email = session.userEmail {
                session.loadUserTags(email: email)
            }
        }
        .fullScreenCover(isPresented: $showAddTag) {
            AddTagView(showAddTag: $showAddTag)
        }
    }
}
