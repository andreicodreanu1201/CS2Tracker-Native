import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some View {
        Group {
            if isLoggedIn{
               MainDashboardView()
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


#Preview {
    ContentView()
}
