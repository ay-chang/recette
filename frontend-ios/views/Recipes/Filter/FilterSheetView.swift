import SwiftUI

struct FilterSheetView: View {
    @ObservedObject var filterRecipesModel: FilterRecipesModel
    @ObservedObject var recipeListModel: RecipeListModel
    @EnvironmentObject var session: UserSession
    var onApply: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(.gray.opacity(0.8))
                .padding(.top, 10)
                .padding(.bottom, 4)

            Text("Filter")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)

            Divider()
                .padding(.bottom, 4)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    /** Tags section*/
                    FilterSheetTags(filterRecipesModel: filterRecipesModel)

                    /** Difficulties section */
                    FilterSheetDifficulties(filterRecipesModel: filterRecipesModel)

                    /** Time options*/
                    FilterSheetTimeOptions(filterRecipesModel: filterRecipesModel)
                }
            }

            Spacer()

            HStack {
                Button(action: {
                        filterRecipesModel.clearFilters()
                    }) {
                        Text("Clear")
                            .padding()
                            .foregroundColor(.black)
                            .underline()
                    }
                Spacer()
                Button(action: {
                    if let email = session.userEmail {
                        filterRecipesModel.applyFilter(recipeListModel: recipeListModel) {
                            onApply() // Close the sheet
                        }
                    }
                }) {
                    Text("Apply")
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .presentationDetents([.large])
        .presentationBackground(.white)
        .onAppear {
            if let email = session.userEmail {
                session.loadUserTags(email: email)
            }
        }
    }
}

struct FilterRow: View {
    let label: String
    @Binding var isChecked: Bool

    var body: some View {
        HStack {
            Button(action: {
                isChecked.toggle()
            }) {
                HStack {
                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                        .foregroundColor(isChecked ? Color(hex: "#e9c46a") : .black)
                    Text(label)
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(BorderlessButtonStyle())

            Spacer()
        }
    }
}
