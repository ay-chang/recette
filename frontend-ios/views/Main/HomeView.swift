import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: UserSession
    @Binding var selectedTab: Int

    var body: some View {
        RecipesView()
    }

}
