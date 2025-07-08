import SwiftUI

struct ProfileOptionsButton: View {
    var buttonText: String
    var buttonImage: String
    var buttonAction: () -> Void
    
    var body: some View {
        
        Button (action: {
            buttonAction()
        }) {
            HStack (spacing: 8){
                Image(systemName: "\(buttonImage)")
                Text("\(buttonText)")
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.black.opacity(0.6))
                    .font(.footnote)
            }
            .font(.callout)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
            .foregroundColor(Color.black)
        }
    }
}
