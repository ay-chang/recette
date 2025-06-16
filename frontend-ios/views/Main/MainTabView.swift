import SwiftUI

/** This view acts as the navabar at the bottom of the screen */

struct MainTabView: View {
    @EnvironmentObject var session: UserSession
    @State private var showCreateRecipe = false
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView(selectedTab: $selectedTab)
                    .tabItem {
                        Label("Recipes", systemImage: "list.bullet.rectangle")
                    }
                    .tag(0)
                
                Color.clear // Invisible tab for "Create"
                    .tabItem {
                        Label("Create", systemImage: "plus.app")
                            .foregroundColor(Color.white)
                            .background(Color.white)
                    }
                    .tag(1)
                
                GroceryListView()
                    .tabItem {
                        Label("Grocery", systemImage: "cart")

                    }
                    .tag(2)
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                            .background(Color.white)
                    }
                    .tag(3)
            }
            .tint(Color(hex: "#e9c46a"))
        }
        .onChange(of: selectedTab) { _, newTab in
            if newTab == 1 {
                selectedTab = 0
                DispatchQueue.main.async {
                    showCreateRecipe = true
                }
            }
        }
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



