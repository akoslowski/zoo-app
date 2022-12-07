import SwiftUI

struct RecommendationListView: View {

    @State var animals: [Animal]  = Animal.makeRandomAnimals(count: 5)

    @EnvironmentObject var navigator: Navigator

    var body: some View {
        List(animals) { animal in
            // Example usage for a `NavigationLink`
            NavigationLink(destination: {
                AnimalDetailView(
                    viewModel: .init(
                        animal: animal,
                        // FIXME: `navigationPath` is not required when `shouldShowRecommendationButton` is set to `false`
                        shouldShowRecommendationButton: false,
                        navigationPath: $navigator.navigationPath
                    )
                )
            }, label: {
                AnimalView(animal: animal)
            })
        }
        .navigationTitle("Recommendations")
        .listStyle(.plain)
    }
}

struct RecommendationListView_Previews: PreviewProvider {
    @ObservedObject private static var navigator: Navigator = .init()

    static var previews: some View {
        TabView {
            NavigationStack() {
                RecommendationListView()
            }
            .environmentObject(navigator)
            .tabItem {
                Label { Text("Recommendations") } icon: { Image(systemName: "circle") }
            }
        }
    }
}
