import SwiftUI

struct OthersBarView: View {
    let difficulty: String?
    let servingSize: Int?
    let cookTimeInMinutes: Int?
    let iconSize: CGFloat
    let fontSize: CGFloat
    let itemSpacing: CGFloat
    
    var body: some View {
        /** Row of other options*/
        HStack (alignment: .center){
            /** Difficulty */
            if difficulty != nil {
                HStack (alignment: .center, spacing: 4) {
                    Image(systemName: "puzzlepiece.extension")
                        .font(.system(size: iconSize))
                        .foregroundColor(Color(hex: "#e9c46a"))
                        .fontWeight(.bold)
                    
                    Text("\(difficulty!)")
                        .foregroundColor(Color.black)
                        .font(.system(size: fontSize))
                        .fontWeight(.regular)
                }
                .padding(.trailing, itemSpacing)
            }
            
            /** Serving size */
            if let servingSize = servingSize, servingSize > 0 {
                let servingText = servingSize >= 10 ? "10+" : "\(servingSize)"
                
                HStack(alignment: .center, spacing: 4) {
                    Image(systemName: "person.2")
                        .font(.system(size: iconSize))
                        .foregroundColor(Color(hex: "#e9c46a"))
                        .fontWeight(.bold)
                    
                    Text("Serves \(servingText)")
                        .foregroundColor(Color.black)
                        .font(.system(size: fontSize))
                        .fontWeight(.regular)
                }
                .padding(.trailing, itemSpacing)
            }

            /** Cook time */
            if let cookTimeInMinutes = cookTimeInMinutes, cookTimeInMinutes > 0 {
                let hours = cookTimeInMinutes / 60
                let minutes = cookTimeInMinutes % 60

                HStack (alignment: .center, spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: iconSize))
                        .foregroundColor(Color(hex: "#e9c46a"))
                        .fontWeight(.bold)
                    
                    if hours > 0 {
                        Text("\(hours) hour\(hours == 1 ? "" : "s")")
                            .foregroundColor(Color.black)
                            .font(.system(size: fontSize))
                            .fontWeight(.regular)
                        if minutes > 0 {
                            Text("\(minutes) min\(minutes == 1 ? "" : "s")")
                                .foregroundColor(Color.black)
                                .font(.system(size: fontSize))
                                .fontWeight(.regular)
                        }
                    } else {
                        Text("\(minutes) min\(minutes == 1 ? "" : "s")")
                            .foregroundColor(Color.black)
                            .font(.system(size: fontSize))
                            .fontWeight(.regular)
                    }
                }
                .padding(.trailing, itemSpacing)
            }
            Spacer()
        }
    }
}
