import SwiftUI

struct ContentView: View {
    
    var isAuthenticated: Bool = false
    var body: some View {
        if isAuthenticated {
            NavigationStack {
                TabBarView()
            }
        }
        LogInView()
        
    }
}
#Preview {
    ContentView()
}
