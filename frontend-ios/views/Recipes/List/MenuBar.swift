import SwiftUI

struct MenuBar: View {
    @Binding var isListView: Bool
    @Binding var showFilterSheet: Bool
    @State private var showComingSoon = false

    var body: some View {
        HStack (alignment: .center) {
            Spacer()

            Button(action: {
                showFilterSheet = true
            }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16, weight: .regular))
                    .frame(width: 20, height: 20)
            }
            .padding(10)
            .foregroundColor(Color.black)
            .overlay(
                Circle()
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
            )

            Button(action: {
                showComingSoon = true
            }) {
                Image(systemName: "bookmark")
                    .font(.system(size: 16, weight: .regular))
                    .frame(width: 20, height: 20)
            }
            .padding(10)
            .foregroundColor(Color.black)
            .overlay(
                Circle()
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
            )
            .alert("Feature coming soon", isPresented: $showComingSoon) {
                Button("OK", role: .cancel) { }
            }

        }
        .padding(.bottom)
        .padding(.horizontal)
    }
}
