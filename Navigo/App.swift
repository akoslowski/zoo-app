import SwiftUI

@main
struct NavigoApp: App {
    var body: some Scene {
        WindowGroup {
                TabView {
                    ContentView()
                        .environment(\.detailView, DetailViewProvider(dependencies: [42,1]))
                        .tabItem {
                            Label {
                                Text("Animals")
                            } icon: {
                                Image(systemName: "circle")
                            }
                        }
                    
                    Text("More")
                        .tabItem {
                            Label {
                                Text("More")
                            } icon: {
                                Image(systemName: "circle")
                            }
                        }
                }
            }
    }
}
