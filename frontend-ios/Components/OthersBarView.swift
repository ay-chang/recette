import SwiftUI

struct OthersBarView: View {
    let difficulty: String?
    let servingSize: Int?
    let cookTimeInMinutes: Int?
    let iconSize: CGFloat
    let fontSize: CGFloat
    
    var body: some View {
        /** Row of other options*/
        HStack (alignment: .center){
            /** Difficulty */
            if difficulty != nil {
                HStack (alignment: .center){
                    Image(systemName: "puzzlepiece.extension.fill")
                        .font(.system(size: iconSize))
                        .foregroundColor(Color(hex: "#e9c46a"))
                    Text("\(difficulty!)")
                        .foregroundColor(Color.black)
                        .font(.system(size: fontSize))
                        .fontWeight(.medium)
                }
                .padding(.trailing, 8)
            }
            
            /** Serving size */
            if let servingSize = servingSize, servingSize > 0 {
                HStack (alignment: .center){
                    Image(systemName: "fork.knife")
                        .font(.system(size: iconSize))
                        .foregroundColor(Color(hex: "#e9c46a"))
                    Text("Serves \(servingSize)")
                        .foregroundColor(Color.black)
                        .font(.system(size: fontSize))
                        .fontWeight(.medium)
                }
                .padding(.trailing, 8)
            }
            
            /** Cook time */
            if let cookTimeInMinutes = cookTimeInMinutes, cookTimeInMinutes > 0 {
                let hours = cookTimeInMinutes / 60
                let minutes = cookTimeInMinutes % 60

                HStack (alignment: .center){
                    Image(systemName: "clock.fill")
                        .font(.system(size: iconSize))
                        .foregroundColor(Color(hex: "#e9c46a"))
                    
                    if hours > 0 {
                        Text("\(hours) hour\(hours == 1 ? "" : "s")")
                            .foregroundColor(Color.black)
                            .font(.system(size: fontSize))
                            .fontWeight(.medium)
                        if minutes > 0 {
                            Text("\(minutes) min\(minutes == 1 ? "" : "s")")
                                .foregroundColor(Color.black)
                                .font(.system(size: fontSize))
                                .fontWeight(.medium)
                        }
                    } else {
                        Text("\(minutes) min\(minutes == 1 ? "" : "s")")
                            .foregroundColor(Color.black)
                            .font(.system(size: fontSize))
                            .fontWeight(.medium)
                    }
                }
                .padding(.trailing, 8)
            }
            Spacer()
        }
    }
}
