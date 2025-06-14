import SwiftUI

/** Reusable character count view */

struct CharacterCountView: View {
    let currentCount: Int
    let maxCount: Int
    
    var body: some View {
        HStack{
            Spacer()
            Text("\(currentCount) / \(maxCount)")
                .font(.callout)
                .foregroundColor(.gray)
        }
    }
}
