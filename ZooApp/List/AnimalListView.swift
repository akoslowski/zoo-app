import SwiftUI

struct AnimalListView: View {
    // When using an @ObservedObject here, when going back the view is re-rendered and the viewModel recreated.
    @StateObject var viewModel: AnimalListViewModel

    var body: some View {
        List(viewModel.state.value) { animal in
            AnimalView(animal: animal)
                .onTapGesture {
                    viewModel.eventSubject.send(.userInteraction(.animalViewTapped(animal)))
                }
        }
        .addAnimalDetailViewNavigationDestination(
            navigationPath: $viewModel.state.navigationPath
        )
        .onAppear { viewModel.eventSubject.send(.sceneEvent(.sceneAppeared)) }
        .onDisappear { viewModel.eventSubject.send(.sceneEvent(.sceneDisappeared)) }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationTitle("Animals")
        .listStyle(.plain)
        .refreshable {
            try? await Task.sleep(nanoseconds: 700_000_000)
            Task {
                viewModel.eventSubject.send(.userInteraction(.refreshRequested))
            }
        }
        .animation(.linear, value: viewModel.state)
    }
}

struct AnimalListView_Previews: PreviewProvider {
    @ObservedObject private static var navigator: Navigator = .init()

    static var previews: some View {
        TabView {
            NavigationStack(path: $navigator.navigationPath) {
                AnimalListView(
                    viewModel: .init(
                        navigationPath: $navigator.navigationPath
                    )
                )
            }
            .environmentObject(navigator)
            .tabItem {
                Label { Text("Animals") } icon: { Image(systemName: "circle") }
            }
        }
    }
}
