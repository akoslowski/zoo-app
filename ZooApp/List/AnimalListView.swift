import SwiftUI
import Combine

final class AnimalListViewModel: ObservableObject {
    enum UserInterfaceEvent {
        case screenAppeared
        case screenDisappeared
        case animalViewTapped(Animal)
        case refreshButtonTapped
    }

    @Published var state: State<[Animal]>

    let eventSubject = PassthroughSubject<UserInterfaceEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init(navigationPath: Binding<NavigationPath>) {
        state = .init(
            navigationPath: navigationPath,
            element: Animal.makeRandomAnimals()
        )

        eventSubject
            .sink { print("ContentViewModel:received: \($0)") }
            .store(in: &subscriptions)

        eventSubject
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &subscriptions)
    }

    func handleEvent(_ event: UserInterfaceEvent) {
        switch event {
        case .animalViewTapped(let animal):
            try? state.update {
                $0.navigationPath.append(animal)
            }

        case .refreshButtonTapped:
            try? state.update {
                $0.navigationPath = .init()
                $0.element = Animal.makeRandomAnimals()
            }

        case .screenAppeared:
            break

        case .screenDisappeared:
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
            viewModel.eventSubject.send(.refreshButtonTapped)
        } label: {
            Image(systemName: "arrow.clockwise")
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.state.element) { item in
                    AnimalView(animal: item) {
                        viewModel.eventSubject.send(.animalViewTapped(item))
                    }
                }
            }
            .modifier(AnimalDetailView.NavigationDestination(
                navigationPath: $viewModel.state.navigationPath
            ))
        }
        .onAppear { viewModel.eventSubject.send(.screenAppeared) }
        .onDisappear { viewModel.eventSubject.send(.screenDisappeared) }
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
                AnimalListView(viewModel: .init(navigationPath: $navigator.navigationPath))
            }
            .tabItem {
                Label { Text("Animals") } icon: { Image(systemName: "circle") }
            }
        }
    }
}
