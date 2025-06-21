import SwiftUI

/** This view acts as the navabar at the bottom of the screen */

struct MainTabView: View {
    @EnvironmentObject var session: UserSession
    @State private var showCreateRecipe = false
    @State private var selectedTab = 0
    
    var body: some View {

        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Recipes", systemImage: "list.bullet.rectangle")
                        .environment(\.symbolVariants, .none)
                }
                .tag(0)
            
            Color.clear // Invisible tab for "Create"
                .tabItem {
                    Label("Create", systemImage: "plus.app")
                        .environment(\.symbolVariants, .none)
                }
                .tag(1)
            
            GroceriesView()
                .tabItem {
                    Label("Grocery", systemImage: "cart")
                          .environment(\.symbolVariants, .none)
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                        .environment(\.symbolVariants, .none)
                }
                .tag(3)
        }
        .tint(Color(hex: "#e9c46a"))
        .onChange(of: selectedTab) { _, newTab in
            if newTab == 1 {
                selectedTab = 0
                DispatchQueue.main.async {
                    showCreateRecipe = true
                }
            }
        }
        .background(Color.white)
        .fullScreenCover(isPresented: $showCreateRecipe) {
            CreateRecipeCoordinator()
        }
        Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 1)
                .edgesIgnoringSafeArea(.bottom)
                .offset(y: -65) // This is a hardcoded value
        
    }
}



