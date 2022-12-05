import SwiftUI
import Combine

final class AnimalListViewModel: ObservableObject {

    enum UserInteraction: Hashable {
        case animalViewTapped(Animal)
        case refreshButtonTapped
    }

    enum SceneEvent: Hashable {
        case sceneAppeared
        case sceneDisappeared
    }

    enum UserInterfaceEvent: Hashable {
        case sceneEvent(SceneEvent)
        case userInteraction(UserInteraction)
    }

    @Published var state: SceneState<[Animal]>

    let eventSubject = PassthroughSubject<UserInterfaceEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init(navigationPath: Binding<NavigationPath>) {
        state = .init(
            navigationPath: navigationPath,
            value: []
        )

        eventSubject
            .print("# \(Self.self).\(#function)")
            .sink { _ in /* do tracking maybe */}
            .store(in: &subscriptions)

        eventSubject
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &subscriptions)
    }

    func handleEvent(_ event: UserInterfaceEvent) {
        switch event {
        case .sceneEvent(let sceneEvent):
            handleSceneEvent(sceneEvent)

        case .userInteraction(let interaction):
            handleInteraction(interaction)
        }
    }

    func handleInteraction(_ interaction: UserInteraction) {
        switch interaction {
        case .animalViewTapped(let animal):
            try? state.update {
                $0.navigationPath.append(animal)
            }

        case .refreshButtonTapped:
            try? state.update {
                $0.navigationPath = .init()
                $0.value = Animal.makeRandomAnimals()
            }
        }
    }

    func handleSceneEvent(_ sceneEvent: SceneEvent) {
        switch sceneEvent {
        case .sceneAppeared:
            try? state.update {
                $0.value = Animal.makeRandomAnimals()
            }

        case .sceneDisappeared:
            break
        }
    }
}

struct AnimalListView: View {
    // When using an @ObservedObject here, when going back the view is re-rendered and the viewModel recreated.
    // @ObservedObject var viewModel: ContentViewModel
    @StateObject var viewModel: AnimalListViewModel

    var refreshButton: some View {
        Button {
            viewModel.eventSubject.send(.userInteraction(.refreshButtonTapped))
        } label: {
            Image(systemName: "arrow.clockwise.circle")
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.state.value) { item in
                    AnimalView(animal: item) {
                        viewModel.eventSubject.send(.userInteraction(.animalViewTapped(item)))
                    }
                }
            }
            .addAnimalDetailViewNavigationDestination(
                navigationPath: $viewModel.state.navigationPath
            )
        }
        .onAppear { viewModel.eventSubject.send(.sceneEvent(.sceneAppeared)) }
        .onDisappear { viewModel.eventSubject.send(.sceneEvent(.sceneDisappeared)) }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationTitle("Animals")
        .toolbar { refreshButton }
    }
}

struct ContentView_Previews: PreviewProvider {
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
            .tabItem {
                Label { Text("Animals") } icon: { Image(systemName: "circle") }
            }
        }
    }
}
