import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some View {
        Group {
            if isLoggedIn{
               MainTabView()
                
            } else {
                NavigationStack{
                    LoginView()
                }
            }
        }
        .background(Color(hex: "#0e0e0e"))
        .animation(.easeInOut, value: isLoggedIn)
    }
}

struct MainTabView: View {
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Dashboard
            MainDashboardView()
                .tag(0)
                .tabItem {
                    Label("Dashboard", systemImage: "terminal")
                }

            // Tab 2: Database (Lista)
            WeaponryDatabaseView()
                .tag(1)
                .tabItem {
                    Label("Database", systemImage: "square.stack.3d.up")
                }

            // Tab 3: Settings
        SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.2")
                }
        }
        .accentColor(Color(hex: "#00e639")) // Culoarea verde tactică pentru tab-ul activ
        .onAppear {
            // Opțional: Schimbă aspectul barei de jos să fie neagră complet
            UITabBar.appearance().backgroundColor = .black
        }
    }
}


#Preview {
    ContentView()
}
