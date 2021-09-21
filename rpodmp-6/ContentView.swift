
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var app: Application
    
    var body: some View {
        VStack {
            if app.loggedMovie != nil {
                MainView()
            } else {
                SignIn()
            }
        }
        .font(app.font)
        .accentColor(app.color)
        .preferredColorScheme(app.colorScheme)
        .environment(\.locale, .init(identifier: app.locale))
    }
}

