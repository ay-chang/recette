import SwiftUI

struct RecipeOthers: View {
    let difficulty: String?
    let cookTimeInMinutes: Int?
    let servingSize: Int?
    
    var body: some View {
        /** Row of other options*/
        HStack (alignment: .center){
            /** Difficulty */
            if difficulty != nil {
                HStack (alignment: .center){
                    Image(systemName: "puzzlepiece.extension.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color(hex: "#e9c46a"))
                    Text("\(difficulty!)")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                }
                .padding(.trailing, 12)
            }
            
            /** Serving size */
            if let servingSize = servingSize, servingSize > 0 {
                HStack (alignment: .center){
                    Image(systemName: "fork.knife")
                        .font(.system(size: 22))
                        .foregroundColor(Color(hex: "#e9c46a"))
                    Text("Serves \(servingSize)")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                }
                .padding(.trailing, 12)
            }
            
            /** Cook time */
            if let cookTimeInMinutes = cookTimeInMinutes, cookTimeInMinutes > 0 {
                let hours = cookTimeInMinutes / 60
                let minutes = cookTimeInMinutes % 60

                HStack (alignment: .center){
                    Image(systemName: "clock")
                        .font(.system(size: 22))
                        .foregroundColor(Color(hex: "#e9c46a"))
                    
                    if hours > 0 {
                        Text("\(hours) hour\(hours == 1 ? "" : "s")")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                        if minutes > 0 {
                            Text("\(minutes) min\(minutes == 1 ? "" : "s")")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                        }
                    } else {
                        Text("\(minutes) min\(minutes == 1 ? "" : "s")")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                    }
                }
                .padding(.trailing, 12)
            }
            Spacer()
        }
    }
}
