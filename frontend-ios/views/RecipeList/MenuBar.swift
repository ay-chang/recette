import SwiftUI

struct MenuBar: View {
    @Binding var isListView: Bool
    @Binding var showFilterSheet: Bool

    var body: some View {
        HStack (alignment: .center) {
            Button(action: {
                showFilterSheet = true
            }) {
                HStack (alignment: .center){
                    Text("Filter")
                        .font(.system(size: 16))
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16))
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .foregroundColor(Color.black)
            .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                )
                .cornerRadius(15)

            Spacer()

            // Toggle list/grid view
            HStack {
                Button(action: {
                    isListView = false
                }) {
                    Image(systemName: "square.grid.2x2")
                        .font(.title2)
                        .foregroundColor(isListView ? Color.gray.opacity(0.5) : Color.gray)
                }
                
                Button(action: {
                    isListView = true
                }) {
                    Image(systemName: "list.bullet")
                        .font(.title2)
                        .foregroundColor(isListView ? Color.gray : Color.gray.opacity(0.5))
                }
            }

        }
        .padding()
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.1)),
            alignment: .bottom
        )
        .background(Color.white)
        .sheet(isPresented: $showFilterSheet) {
            FilterSheetView()
        }
    }
}
