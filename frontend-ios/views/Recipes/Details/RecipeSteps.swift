import SwiftUI

/* List of steps for recipe details */

struct RecipeSteps: View {
    let steps: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instructions")
                .font(.title3)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 12)
                .overlay(Rectangle().frame(height: 1).foregroundColor(Color.gray.opacity(0.3)), alignment: .bottom)
            
            VStack(alignment: .leading, spacing: 36) {
                
                if steps.isEmpty {
                    Text("No instructions yet")
                        .foregroundColor(Color.gray)
                    
                } else {
                    ForEach(steps.indices, id: \.self) { i in
                        HStack(alignment: .top, spacing: 12) {
//                            Text("\(i + 1)")
//                                .font(.system(size: 20))
//                                .fontWeight(.medium)
//                                .foregroundColor(.white)
//                                .frame(width: 28, height: 28)
//                                .background(Circle().fill(Color(hex: "#e9c46a")))
//                                .alignmentGuide(.top) { d in d[.top] }
                            Text("\(i + 1).")
                                .foregroundColor(Color.gray)
                                .fontWeight(.light)

                            Text(steps[i])
                                .font(.system(size: 16))
                                .fontWeight(.regular)
                                .fixedSize(horizontal: false, vertical: true) // allows multiline wrapping
                        }
                    }
                }
            }
            
        }
        .padding(.bottom, 96) // padding for the last step
    }
}

