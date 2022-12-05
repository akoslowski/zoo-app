import SwiftUI

struct RecommendationListView: View {

    @State var animals: [Animal]  = Animal.makeRandomAnimals(count: 5)

    var body: some View {
        // use configurable animal list view instead? Make options available via env-obj?
        // AnimalListView(viewModel: <#T##AnimalListViewModel#>)
        List(animals) { animal in
            AnimalView(animal: animal) {
                print("present animal detail view without reco button")
            }
        }
        .navigationTitle("Recommendations")
        .listStyle(.plain)
    }
}

struct RecommendationListView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationStack() {
                RecommendationListView()
            }
            .tabItem {
                Label { Text("Recommendations") } icon: { Image(systemName: "circle") }
            }
        }
    }
}
