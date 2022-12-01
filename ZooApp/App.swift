import SwiftUI

@main
struct ZooApp: App {

    @StateObject var rootNavigator = Navigator()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack(path: $rootNavigator.navigationPath) {
                    ContentView(viewModel: .init(navigationPath: $rootNavigator.navigationPath))
                        .environment(\.detailView, DetailViewProvider(dependencies: [42,1]))
                }
                .tabItem {
                    Label { Text("Animals") } icon: { Image(systemName: "circle") }
                }

                Text("More")
                    .tabItem {
                        Label { Text("More") } icon: { Image(systemName: "circle") }
                    }
            }
        }
    }
}
