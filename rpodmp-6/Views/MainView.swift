import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            TabView {
                MovieList().tabItem {
                    VStack {
                        Image(systemName: "video")
                        Text("Movies")
                    }
                }
                .tag(1)
                .navigationBarHidden(true)
                
                MovieMap().tabItem {
                    VStack {
                        Image(systemName: "map")
                        Text("Map")
                    }
                }
                .tag(2)
                .navigationBarHidden(true)

                Options().tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Options")
                    }
                }
                .tag(3)
            }
        }
    }
}
