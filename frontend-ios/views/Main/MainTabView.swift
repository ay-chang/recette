import SwiftUI

/** This view acts as the navabar at the bottom of the screen */

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showCreateRecipe = false
    @EnvironmentObject var groceriesModel: GroceriesModel

    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            Group {
                switch selectedTab {
                case 0: HomeView(selectedTab: $selectedTab)
                // case 1: SocialView()
                case 1: GroceriesView()
                case 2: ProfileView()

                default: HomeView(selectedTab: $selectedTab)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 82)
            }

            // Custom tab bar
            HStack {
                tabItem(label: "Recipes", image: "list.bullet.rectangle", index: 0)
                Spacer()
                // tabItem(label: "Social", image: "person.2", index: 1)
                // Spacer()
                createButton()
                Spacer()
                tabItem(label: "Grocery", image: "cart", index: 1)
                Spacer()
                tabItem(label: "Profile", image: "person", index: 2)
            }
            .padding(.bottom, 36)
            .padding(.top, 10)
            .padding(.horizontal, 28)
            .background(Color.white)
            .overlay(alignment: .top) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.1))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .bottomSheet(isPresented: $groceriesModel.showOptions) {
            GrocerySheet(groceriesModel: groceriesModel)
        }
        .fullScreenCover(isPresented: $showCreateRecipe) {
            CreateRecipeCoordinator()
        }
    }

    /** Seperate View Builder for the create button as it takes up the entire screen when navigating to*/
    @ViewBuilder
    private func tabItem(label: String, image: String, index: Int) -> some View {
        Button(action: {
            selectedTab = index
        }) {
            VStack (spacing: 4) {
                Image(systemName: image)
                    .font(.system(size: 22))
                    .fontWeight(.regular)
                Text(label)
                    .font(.system(size: 10))
            }
            .foregroundColor(selectedTab == index ? Color(hex: "#e9c46a") : .gray)
        }
    }

    private func createButton() -> some View {
        Button(action: {
            showCreateRecipe = true
        }) {
            VStack (spacing: 4){
                Image(systemName: "plus.app")
                    .font(.system(size: 22))
                Text("Create")
                    .font(.system(size: 10))
                    .fontWeight(.regular)
            }
            .foregroundColor(.gray)
        }
    }
}




