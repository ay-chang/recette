import SwiftUI

/* Top white bar with X */

struct RecipeTopBar: View {
    let showWhiteBar: Bool
    let onClose: () -> Void
    let onEllipsisTap: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            if showWhiteBar {
                Color.white
                    .frame(height: 120)
                    .edgesIgnoringSafeArea(.top)
                    .overlay(
                        HStack {
                            Button(action: onClose) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                    .padding(10)
                            }
                            Spacer()
                            Button(action: onEllipsisTap){
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.black)
                                    .padding(14.5)
                            }
                        }
                        .padding(.top, 70)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                    )
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3)),
                        alignment: .bottom
                    )
            } else {
                HStack{
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding(.top, 77) // offset by extra 2 so X stays in same place
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Button(action: onEllipsisTap) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                            .padding(14.5)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding(.top, 77) // offset by extra 2 so X stays in same place
                    .padding(.trailing, 16)
                }
               
            }
        }
    }
}
