import SwiftUI

struct ServingSizeSelectorView: View {
    @Binding var servingSize: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Serving Size")
                    .font(.headline)
                Spacer()
            }

            /** Minus Button*/
            HStack(spacing: 8) {
                Spacer()
                Button(action: {
                    if servingSize > 0 {
                        servingSize -= 1
                    }
                }) {
                    Text("–")
                        .font(.title2)
                        .frame(width: 40, height: 40)
                        .background(servingSize == 0 ? Color.gray.opacity(0.1) : Color(hex: "#e9c46a"))
                        .foregroundColor(servingSize == 0 ? Color.black : Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(servingSize == 0 ? Color.gray.opacity(0.1) : Color.clear, lineWidth: 1)
                        )
                }

                /** Serving Size text*/
                HStack(spacing: 0) {
                    Text("\(servingSize)")
                        .font(.body)
                        .foregroundColor(.black)
                    Text(" servings")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .frame(minWidth: 80)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                )
                .padding(8)

                /** Plus Button */
                Button(action: {
                    if servingSize < 20 {
                        servingSize += 1
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(servingSize == 20 ? Color.gray.opacity(0.1): Color(hex: "#e9c46a"))
                        .foregroundColor(servingSize == 20 ? Color.black : Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(servingSize == 20 ? Color.gray.opacity(0.1) : Color.clear, lineWidth: 1)
                        )
                }
                
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
